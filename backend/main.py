import os
import sys
import shutil

# Ensure backend directory is in sys.path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from fastapi import FastAPI, UploadFile, File, Form, HTTPException

from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel

from config import Config
from services.ai_analyzer import AIAnalyzer
from services.stt_service import STTService
from services.video_editor import VideoEditor
from services.youtube_uploader import YouTubeUploader

app = FastAPI(
    title="AI YouTube Auto Editor API & PWA",
    description="스마트폰 동영상 AI 분석, 자동 컷편집, 자막/해시태그 생성 및 유튜브 자동 업로드 PWA 백엔드",
    version="1.1.0"
)

# CORS Middleware (React / Flutter / PWA Web Client 허용)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Services Initialization
ai_analyzer = AIAnalyzer()
stt_service = STTService()
video_editor = VideoEditor()
youtube_uploader = YouTubeUploader()

class ProcessRequest(BaseModel):
    video_path: str
    format_type: str = "shorts"  # 'shorts' or 'longform'
    selected_title: str = ""
    description: str = ""
    hashtags: list = []

class UploadYouTubeRequest(BaseModel):
    rendered_video_path: str
    title: str
    description: str
    hashtags: list
    privacy_status: str = "unlisted"
    format_type: str = "shorts"

@app.get("/api/health")
def health_check():
    return {
        "status": "healthy",
        "service": "AI YouTube Auto Editor Backend",
        "upload_dir": Config.UPLOAD_DIR,
        "output_dir": Config.OUTPUT_DIR,
        "pwa_dir": Config.PWA_DIR,
        "port": Config.PORT
    }

@app.post("/api/upload-raw-video")
async def upload_raw_video(file: UploadFile = File(...)):
    """휴대폰 촬영 원본 동영상 업로드 엔드포인트"""
    try:
        file_path = os.path.join(Config.UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        return {
            "success": True,
            "filename": file.filename,
            "file_path": file_path,
            "message": "동영상이 정상적으로 서버에 업로드 되었습니다."
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/analyze-video")
async def analyze_video(video_path: str = Form(...), format_type: str = Form("shorts")):
    """
    1. Whisper STT로 음성 자막 및 타임스탬프 추출
    2. Gemini Multimodal AI로 주요 하이라이트, 제목, 해시태그, 설명 생성
    """
    if not os.path.exists(video_path):
        raise HTTPException(status_code=404, detail="지정한 비디오 파일을 찾을 수 없습니다.")

    stt_result = stt_service.generate_subtitles(video_path)
    transcript = stt_result.get("transcript", "")

    ai_result = ai_analyzer.analyze_video_and_generate_metadata(
        video_path=video_path,
        transcript=transcript,
        format_type=format_type
    )

    return {
        "success": True,
        "video_path": video_path,
        "format_type": format_type,
        "transcript": transcript,
        "subtitles": stt_result.get("subtitles", []),
        "srt_path": stt_result.get("srt_path", ""),
        "metadata": ai_result
    }

@app.post("/api/process-and-render")
async def process_and_render(
    video_path: str = Form(...),
    srt_path: str = Form(""),
    format_type: str = Form("shorts")
):
    """FFmpeg 기반 자막 Overlay & Shorts(9:16) / 롱폼(16:9) 자동 렌더링"""
    if not os.path.exists(video_path):
        raise HTTPException(status_code=404, detail="동영상 파일이 존재하지 않습니다.")

    subtitles_info = {"srt_path": srt_path}
    rendered_output_path = video_editor.process_video(
        input_path=video_path,
        subtitles_info=subtitles_info,
        format_type=format_type
    )

    output_filename = os.path.basename(rendered_output_path)
    preview_url = f"/output/{output_filename}"

    return {
        "success": True,
        "rendered_video_path": rendered_output_path,
        "preview_url": preview_url,
        "format_type": format_type,
        "message": "AI 자동 편집 및 자막 렌더링이 완료되었습니다."
    }

@app.post("/api/publish-youtube")
async def publish_youtube(req: UploadYouTubeRequest):
    """최종 편집 영상을 사용자 유튜브 채널로 자동 업로드"""
    result = youtube_uploader.upload_video(
        video_file_path=req.rendered_video_path,
        title=req.title,
        description=req.description,
        hashtags=req.hashtags,
        privacy_status=req.privacy_status,
        format_type=req.format_type
    )
    return result

@app.post("/api/auto-pipeline")
async def auto_pipeline(
    video_path: str = Form(...),
    format_type: str = Form("shorts"),
    privacy_status: str = Form("unlisted")
):
    """
    [아이폰 원클릭 원스톱 자동 실행 엔드포인트]
    1. STT 음성인식 자막 추출
    2. Gemini AI 영상 멀티모달 분석 (제목/해시태그 생성)
    3. FFmpeg 비디오 종횡비 변환 및 예능 자막 Burn-in 렌더링
    4. YouTube Data API v3 채널 원클릭 자동 게시
    """
    if not os.path.exists(video_path):
        raise HTTPException(status_code=404, detail="지정한 비디오 파일을 찾을 수 없습니다.")

    # 1. STT
    stt_result = stt_service.generate_subtitles(video_path)
    transcript = stt_result.get("transcript", "")
    srt_path = stt_result.get("srt_path", "")

    # 2. AI Analysis
    ai_result = ai_analyzer.analyze_video_and_generate_metadata(
        video_path=video_path,
        transcript=transcript,
        format_type=format_type
    )
    title = ai_result.get("selected_title", "🔥 AI가 생성한 하이라이트 영상")
    description = ai_result.get("description", "스마트폰 동영상 AI 자동 편집 영상입니다.")
    hashtags = ai_result.get("hashtags", ["#Shorts", "#AI편집", "#유튜브자동화"])

    # 3. FFmpeg Video Render
    rendered_output_path = video_editor.process_video(
        input_path=video_path,
        subtitles_info={"srt_path": srt_path},
        format_type=format_type
    )

    # 4. YouTube Upload / Release
    yt_result = youtube_uploader.upload_video(
        video_file_path=rendered_output_path,
        title=title,
        description=description,
        hashtags=hashtags,
        privacy_status=privacy_status,
        format_type=format_type
    )

    return {
        "success": True,
        "title": title,
        "youtube_url": yt_result.get("video_url", ""),
        "youtube_id": yt_result.get("video_id", ""),
        "format_type": format_type,
        "rendered_video_path": rendered_output_path,
        "preview_url": f"/output/{os.path.basename(rendered_output_path)}",
        "hashtags": hashtags,
        "message": "원클릭 AI 영상 편집 및 유튜브 게시 파이프라인 완수!"
    }

# Static file servers
app.mount("/output", StaticFiles(directory=Config.OUTPUT_DIR), name="output")

if os.path.exists(Config.PWA_DIR):
    app.mount("/icons", StaticFiles(directory=os.path.join(Config.PWA_DIR, "icons")), name="icons")

    @app.get("/manifest.json")
    def get_manifest():
        return FileResponse(os.path.join(Config.PWA_DIR, "manifest.json"))

    @app.get("/sw.js")
    def get_sw():
        return FileResponse(os.path.join(Config.PWA_DIR, "sw.js"), media_type="application/javascript")

    @app.get("/")
    @app.get("/index.html")
    def read_root():
        return FileResponse(os.path.join(Config.PWA_DIR, "index.html"))

    @app.get("/favicon.ico")
    def get_favicon():
        return FileResponse(os.path.join(Config.PWA_DIR, "icons", "icon-192.png"))


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=Config.PORT, reload=True)
