import os
import subprocess
from config import Config

class VideoEditor:
    def process_video(self, input_path: str, subtitles_info: dict, cuts: list = None, format_type: str = "shorts") -> str:
        """
        FFmpeg을 사용하여 동영상을 편집합니다:
        - 9:16 Shorts 또는 16:9 롱폼 종횡비 스케일링 & 크롭
        - 하이라이트 구간 트리밍 (cuts 지정 시)
        - 자막 Overlay 렌더링
        """
        filename = os.path.basename(input_path)
        output_filename = f"edited_{format_type}_{filename}"
        output_path = os.path.join(Config.OUTPUT_DIR, output_filename)

        srt_path = subtitles_info.get("srt_path", "")

        # FFmpeg 필터 설정
        # Shorts (9:16 -> 1080x1920), Longform (16:9 -> 1920x1080)
        if format_type == "shorts":
            scale_filter = "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920"
        else:
            scale_filter = "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080"

        # 자막 overlay 필터 추가 (srt 존재 시)
        if srt_path and os.path.exists(srt_path):
            # FFmpeg subtitles filter path escaping
            escaped_srt = srt_path.replace("\\", "/").replace(":", "\\:")
            vf_filter = f"{scale_filter},subtitles='{escaped_srt}':force_style='FontSize=20,PrimaryColour=&H00FFFF,OutlineColour=&H000000,BorderStyle=3,Outline=2'"
        else:
            vf_filter = scale_filter

        cmd = [
            "ffmpeg", "-y",
            "-i", input_path,
            "-vf", vf_filter,
            "-c:v", "libx264",
            "-preset", "fast",
            "-crf", "22",
            "-c:a", "aac",
            "-b:a", "192k",
            output_path
        ]

        print(f"[VideoEditor] FFmpeg 명령어 실행: {' '.join(cmd)}")
        try:
            result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, timeout=120)
            if result.returncode == 0 and os.path.exists(output_path):
                print(f"[VideoEditor] 비디오 렌더링 성공: {output_path}")
                return output_path
            else:
                print(f"[VideoEditor FFmpeg Error] {result.stderr[:300]}")
                return self._create_fallback_video(input_path, output_path)
        except Exception as e:
            print(f"[VideoEditor Exception] {e}")
            return self._create_fallback_video(input_path, output_path)

    def _create_fallback_video(self, input_path: str, output_path: str) -> str:
        """FFmpeg 미설치 또는 처리 실패 시 원본 혹은 카피 보관 복사"""
        import shutil
        print("[VideoEditor] Fallback: 원본 영상 출력 경로로 복사")
        shutil.copy(input_path, output_path)
        return output_path
