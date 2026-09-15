# 🎬 119.AI_YouTube_Auto_Editor
> **AI 기반 스마트폰 영상 자동 분석 & 컷편집 & 예능 자막 & SEO 해시태그 & 유튜브 자동 업로드 PWA 모바일 앱 & 클라우드 시스템** (iOS Safari, Android & Render.com 지원)

---

## 🌟 주요 기능 (Key Features)

1. **📱 아이폰(iOS) PWA (Progressive Web App) 완전 지원**
   - 별도 앱스토어 설치 없이 아이폰 Safari에서 접속 후 **'홈 화면에 추가'**를 누르면 모바일 앱처럼 구동!
   - 아이폰 비디오 갤러리/카메라 영상 즉시 선택 및 업로드 (`accept="video/*"`).
   - Glassmorphic iOS 다크 모드 디자인 & Safe Area inset 완벽 대응.
2. **⚡ 원클릭 원스톱 AI 파이프라인 (`/api/auto-pipeline`)**
   - 비디오 선택 한 번으로 **Whisper STT 자막 + Gemini AI 멀티모달 분석 + FFmpeg 9:16 인코딩 + 유튜브 채널 자동 게시**를 원클릭으로 완수!
3. **☁️ Render.com 클라우드 1-Click 자동 배포 지원**
   - `Dockerfile`, `render.yaml`, `Procfile` 탑재로 Render.com 클라우드에 1분 만에 웹 서비스 배포 가능.
   - 단일 서비스로 PWA 정적 프론트엔드와 FastAPI 백엔드를 동시 처리.
4. **🎨 정밀 AI 스튜디오 모드**
   - **YouTube Shorts (9:16 세로)** 및 **일반 롱폼 영상 (16:9 가로)** 변환.
   - AI 추천 제목 3종 선택, SEO 최적화 해시태그 클라우드, 예능 자막 오버레이 실시간 미리보기.
5. **🔒 유튜브 자동 업로드 파이프라인**
   - **Google OAuth 2.0 & YouTube Data API v3**를 통해 사용자 본인 채널로 즉시 자동 게시 (일부공개/전체공개/비공개).

---

## 🏗️ 프로젝트 구조 (Project Structure)

```
119.AI_YouTube_Auto_Editor/
├── Dockerfile                    # Render.com Docker 배포 설정 (FFmpeg + Python 3.10)
├── render.yaml                   # Render Blueprint 클라우드 자동 배포 지정서
├── Procfile                      # Render Native Python 호환 스크립트
├── backend/
│   ├── main.py                   # FastAPI REST API & PWA 서버 (Port 8000 / $PORT)
│   ├── config.py                 # 환경변수 & API 키 & PWA 경로 설정
│   ├── requirements.txt          # 백엔드 라이브러리 목록 (Gunicorn, FastAPI 등)
│   ├── test_backend.py           # 파이프라인 자동 테스트 스크립트
│   └── services/
│       ├── ai_analyzer.py        # Gemini 비디오 분석 및 메타데이터 생성기
│       ├── stt_service.py        # Whisper 음성인식 자막 파서
│       ├── video_editor.py       # FFmpeg 자동 컷편집 & 자막 렌더링
│       └── youtube_uploader.py   # YouTube Data API v3 업로드 서비스
├── frontend/
│   └── pwa/                      # 📱 아이폰/모바일 PWA 앱
│       ├── index.html            # iOS 반응형 모바일 PWA 인터페이스
│       ├── manifest.json         # PWA 웹 앱 매니페스트 (iOS/Android 설치 설정)
│       ├── sw.js                 # PWA Service Worker (오프라인 캐싱 지원)
│       └── icons/                # iOS Touch Icon (180x180, 192x192, 512x512)
└── README.md
```

---

## 🚀 빠른 시작 가이드 (Quick Start Guide)

### 1. 로컬 PWA & 백엔드 실행 (Python 3.10+)

```bash
cd backend
pip install -r requirements.txt

# API 키 설정 (선택 사항 - 미설정 시 AI 데모/시뮬레이션 모드로 안전 구동)
export GEMINI_API_KEY="your_gemini_api_key"
export OPENAI_API_KEY="your_openai_api_key"

# FastAPI & PWA 통합 서버 실행
python main.py
```

- **아이폰 / 웹 접속**: 브라우저에서 `http://localhost:8000` (동일 와이파이 네트워크 접속 시 `http://내컴퓨터IP:8000`)
- **API 문서**: `http://localhost:8000/docs`

---

## ☁️ Render.com 클라우드 배포 가이드 (Deployment to Render.com)

아이폰에서 언제 어디서나 외부 인터넷 URL로 접속하려면 Render.com에 무료 배포하세요:

1. [Render.com](https://render.com) 회원가입 및 접속
2. **New +** > **Blueprint** 클릭
3. 본 프로젝트 Git 리포지토리 연결
4. `render.yaml`이 자동으로 인식되며 **Apply** 버튼 누르기!
5. 생성된 주소 (예: `https://ai-youtube-auto-editor.onrender.com`)를 아이폰 Safari에서 접속 후 **'홈 화면에 추가'**를 실행합니다.

---

## 🔒 유튜브 Google OAuth2 설정 가이드

실제 사용자의 유튜브 채널로 직접 동영상을 업로드하려면 Google Cloud Console에서 OAuth 인증키를 받아주세요:

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. **YouTube Data API v3** 사용 설정
3. **OAuth 2.0 클라이언트 ID** 생성 (데스크톱 애플리케이션)
4. 다운로드 받은 JSON 파일을 `backend/client_secret.json` 경로에 저장
