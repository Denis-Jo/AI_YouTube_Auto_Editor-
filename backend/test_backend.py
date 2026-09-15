import os
from services.ai_analyzer import AIAnalyzer
from services.stt_service import STTService
from services.video_editor import VideoEditor
from services.youtube_uploader import YouTubeUploader

def test_pipeline():
    print("--- 1. Testing AI Multimodal & STT Services ---")
    stt = STTService()
    ai = AIAnalyzer()
    editor = VideoEditor()
    uploader = YouTubeUploader()

    # STT Test
    stt_res = stt.generate_subtitles("dummy_video.mp4")
    print(f"STT Transcript: {stt_res['transcript'][:60]}...")
    print(f"SRT Generated at: {stt_res['srt_path']}")

    # AI Metadata Test
    ai_res = ai.analyze_video_and_generate_metadata("dummy_video.mp4", stt_res['transcript'], format_type="shorts")
    print(f"Selected Title: {ai_res['selected_title']}")
    print(f"Hashtags ({len(ai_res['hashtags'])}): {ai_res['hashtags'][:5]}")

    # YouTube Uploader Test
    upload_res = uploader.upload_video(
        video_file_path="dummy_video.mp4",
        title=ai_res['selected_title'],
        description=ai_res['description'],
        hashtags=ai_res['hashtags'],
        privacy_status="unlisted",
        format_type="shorts"
    )
    print(f"Upload Video Result: {upload_res['video_url']}")
    print("✅ All AI & Publishing Pipeline Services verified successfully!")

if __name__ == "__main__":
    test_pipeline()
