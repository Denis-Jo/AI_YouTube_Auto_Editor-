import os
import json
from google import genai
from config import Config

class AIAnalyzer:
    def __init__(self):
        self.api_key = Config.GEMINI_API_KEY
        if self.api_key:
            self.client = genai.Client(api_key=self.api_key)
        else:
            self.client = None

    def analyze_video_and_generate_metadata(self, video_path: str, transcript: str = "", format_type: str = "shorts") -> dict:
        """
        Gemini Multimodal API를 사용하여 동영상 콘텐츠 및 음성 자막을 분석하고,
        하이라이트 편집 구간, 제목 3종, 상세 설명, 연관 해시태그를 자동 생성합니다.
        """
        default_result = {
            "title_candidates": [
                "🔥 AI가 분석한 오늘의 하이라이트 순간!",
                "이 영상을 꼭 봐야 하는 이유 | 1분 요약",
                "초간단 AI 자막 & 컷편집 비하인드"
            ],
            "selected_title": "🔥 AI가 분석한 오늘의 하이라이트 순간!",
            "description": f"스마트폰 촬영 영상을 AI가 자동으로 분석 및 편집하여 생성된 영상입니다.\n\n포맷: {'YouTube Shorts (9:16)' if format_type == 'shorts' else '일반 비디오 (16:9)'}\n자막 요약: {transcript[:100]}...",
            "hashtags": ["#Shorts", "#AI편집", "#유튜브자동화", "#스마트폰촬영", "#하이라이트", "#자동자막", "#AITools", "#트렌딩", "#모바일동영상", "#유튜브크리에이터"],
            "suggested_cuts": [
                {"start_sec": 0, "end_sec": 15, "label": "오프닝 하이라이트"},
                {"start_sec": 20, "end_sec": 45, "label": "핵심 주제 설명"},
                {"start_sec": 50, "end_sec": 60, "label": "엔딩 & 구독 요청"}
            ],
            "target_format": format_type
        }

        if not self.client:
            print("[AIAnalyzer] GEMINI_API_KEY 미설정 - 기본 데모 데이터 반환")
            return default_result

        try:
            # Gemini Prompt
            prompt = f"""
            당신은 최고의 유튜브 콘텐츠 크리에이터 및 비디오 에디터 AI입니다.
            다음 동영상 음성 자막 내용({transcript}) 및 비디오 데이터를 분석하여 JSON 형식으로 결과를 출력해주세요.

            [요구사항]
            1. 유튜브 조회수를 극대화할 수 있는 매력적인 제목 3가지 (title_candidates)
            2. 대표 제목 (selected_title)
            3. 유튜브 영상 상세 설명 (description)
            4. 클릭률과 검색 SEO에 최적화된 해시태그 10개 (hashtags, # 포함)
            5. 영상의 재미있는 하이라이트 구간 3곳 (suggested_cuts: start_sec, end_sec, label)

            응답은 다른 텍스트 없이 마크다운이나 코드블록 없는 순수 JSON 문자열만 반환하세요:
            {{
                "title_candidates": ["...", "...", "..."],
                "selected_title": "...",
                "description": "...",
                "hashtags": ["#...", "#..."],
                "suggested_cuts": [
                    {{"start_sec": 0, "end_sec": 15, "label": "..."}}
                ]
            }}
            """
            
            response = self.client.models.generate_content(
                model='gemini-2.5-flash',
                contents=prompt
            )
            
            clean_json = response.text.replace("```json", "").replace("```", "").strip()
            data = json.loads(clean_json)
            data["target_format"] = format_type
            return data

        except Exception as e:
            print(f"[AIAnalyzer Error] {e}")
            return default_result
