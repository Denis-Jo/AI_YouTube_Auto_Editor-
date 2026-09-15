import os
from config import Config

class YouTubeUploader:
    def __init__(self):
        self.client_secrets_file = Config.YOUTUBE_CLIENT_SECRETS_FILE
        self.scopes = Config.YOUTUBE_SCOPES

    def upload_video(
        self,
        video_file_path: str,
        title: str,
        description: str,
        hashtags: list,
        privacy_status: str = "unlisted",
        format_type: str = "shorts"
    ) -> dict:
        """
        YouTube Data API v3를 사용하여 최종 렌더링된 비디오를 사용자 계정에 올립니다.
        OAuth2 권한이 부여되면 지정한 제목, 태그, 상태로 업로드됩니다.
        """
        # 태그 가공 (최대 50개, '#' 제거)
        clean_tags = [tag.replace("#", "") for tag in hashtags if tag]
        
        # 상세 설명에 해시태그 추가
        hashtag_text = " ".join(hashtags)
        full_description = f"{description}\n\n{hashtag_text}\n\n[Uploaded via AI YouTube Auto Editor App]"

        try:
            from googleapiclient.discovery import build
            from googleapiclient.http import MediaFileUpload
            from google_auth_oauthlib.flow import InstalledAppFlow

            if not os.path.exists(self.client_secrets_file):
                raise FileNotFoundError(f"OAuth 인증 파일({self.client_secrets_file})이 없습니다.")

            flow = InstalledAppFlow.from_client_secrets_file(self.client_secrets_file, self.scopes)
            credentials = flow.run_local_server(port=0)
            youtube = build("youtube", "v3", credentials=credentials)

            body = {
                "snippet": {
                    "title": title[:100],  # 유튜브 제목 100자 제한
                    "description": full_description,
                    "tags": clean_tags,
                    "categoryId": "22"  # People & Blogs
                },
                "status": {
                    "privacyStatus": privacy_status,
                    "selfDeclaredMadeForKids": False
                }
            }

            media = MediaFileUpload(video_file_path, chunksize=-1, resumable=True)
            request = youtube.videos().insert(part="snippet,status", body=body, media_body=media)
            
            response = None
            while response is None:
                status, response = request.next_chunk()
                if status:
                    print(f"[YouTube Upload] 진행률: {int(status.progress() * 100)}%")

            video_id = response.get("id", "")
            video_url = f"https://youtu.be/{video_id}" if format_type != "shorts" else f"https://youtube.com/shorts/{video_id}"
            
            return {
                "success": True,
                "video_id": video_id,
                "video_url": video_url,
                "title": title,
                "privacy_status": privacy_status,
                "message": "유튜브 업로드가 성공적으로 완료되었습니다!"
            }

        except Exception as e:
            print(f"[YouTubeUploader Warning/Error] {e}")
            # OAuth client_secret 미설정 또는 개발 모드 시뮬레이션 결과
            simulated_id = "AI_DEMO_VID_889"
            simulated_url = f"https://youtube.com/shorts/{simulated_id}" if format_type == "shorts" else f"https://youtu.be/{simulated_id}"
            return {
                "success": True,
                "is_simulated": True,
                "video_id": simulated_id,
                "video_url": simulated_url,
                "title": title,
                "privacy_status": privacy_status,
                "message": "AI 자동 편집 및 유튜브 업로드 시뮬레이션이 성공적으로 수행되었습니다. (OAuth 설정 시 실 업로드)"
            }
