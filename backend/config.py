import os

class Config:
    # Directory paths
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    PROJECT_ROOT = os.path.dirname(BASE_DIR)
    UPLOAD_DIR = os.path.join(BASE_DIR, "uploads")
    PROCESSED_DIR = os.path.join(BASE_DIR, "processed")
    OUTPUT_DIR = os.path.join(BASE_DIR, "output")
    PWA_DIR = os.path.join(PROJECT_ROOT, "frontend", "pwa")
    
    # Server Port
    PORT = int(os.environ.get("PORT", 8000))
    
    # API Keys
    GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "")
    OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY", "")
    
    # YouTube OAuth settings
    YOUTUBE_CLIENT_SECRETS_FILE = os.path.join(BASE_DIR, "client_secret.json")
    YOUTUBE_SCOPES = ["https://www.googleapis.com/auth/youtube.upload"]

# Ensure work directories exist
for path in [Config.UPLOAD_DIR, Config.PROCESSED_DIR, Config.OUTPUT_DIR, Config.PWA_DIR]:
    os.makedirs(path, exist_ok=True)

