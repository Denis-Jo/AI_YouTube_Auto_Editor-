FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies (FFmpeg, Korean Fonts for subtitles, build-essential)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    fonts-nanum \
    build-essential \
    libgl1 \
    libglib2.0-0 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy backend requirements and install Python dependencies
COPY backend/requirements.txt /app/backend/requirements.txt
RUN pip install --no-cache-dir -r backend/requirements.txt

# Copy entire application codebase
COPY . /app

# Environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8000
ENV PYTHONPATH=/app/backend

# Expose port
EXPOSE 8000

# Start FastAPI / Uvicorn server
CMD ["sh", "-c", "python backend/main.py"]
