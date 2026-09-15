import os
import sys
import json
import webbrowser

# Ensure backend directory is in sys.path
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, BASE_DIR)

from config import Config

def main():
    print("=" * 60)
    print("🔑 Google YouTube OAuth2 토큰 생성 도구 (token.json)")
    print("=" * 60)

    client_secrets_file = Config.YOUTUBE_CLIENT_SECRETS_FILE
    token_file = os.path.join(BASE_DIR, "token.json")

    # Check client_secret.json
    env_secret_json = os.environ.get("YOUTUBE_CLIENT_SECRET_JSON", "")
    if env_secret_json and not os.path.exists(client_secrets_file):
        with open(client_secrets_file, "w", encoding="utf-8") as f:
            f.write(env_secret_json)
        print("[+] YOUTUBE_CLIENT_SECRET_JSON 환경변수로부터 client_secret.json을 복원했습니다.")

    if not os.path.exists(client_secrets_file):
        print("\n❌ 오류: backend/client_secret.json 인증키 파일이 없습니다.")
        print("💡 Google Cloud Console에서 다운로드받은 client_secret.json을 backend 폴더에 놓아주세요.")
        sys.exit(1)

    try:
        from google_auth_oauthlib.flow import InstalledAppFlow

        print("\n🌐 잠시 후 브라우저가 열리며 구글 로그인 창이 표시됩니다...")
        print("   구글 계정으로 로그인 후 [허용/계속]을 눌러주세요.\n")

        flow = InstalledAppFlow.from_client_secrets_file(
            client_secrets_file,
            Config.YOUTUBE_SCOPES
        )
        creds = flow.run_local_server(port=0)

        with open(token_file, "w", encoding="utf-8") as f:
            f.write(creds.to_json())

        print("=" * 60)
        print("🎉 인증 성공! token.json 파일이 생성되었습니다.")
        print(f"📁 저장 위치: {token_file}")
        print("=" * 60)

        print("\n👇 아래 텍스트 전체(JSON)를 복사하여 Render 대시보드의 YOUTUBE_TOKEN_JSON 값으로 등록하세요:\n")
        print(creds.to_json())
        print("\n=" * 60)

    except Exception as e:
        print(f"\n❌ OAuth 인증 실패: {e}")

if __name__ == "__main__":
    main()
