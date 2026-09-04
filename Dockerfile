FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy and install python dependencies
COPY backend/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend application
COPY backend/ /app/

# Port configuration
ENV PORT=10000
EXPOSE 10000

# Start command
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port $PORT"]
