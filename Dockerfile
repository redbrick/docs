FROM python:3.12-slim

WORKDIR /app

# Install system dependencies required for Git plugin and Material imaging features
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gcc \
    python3-dev \
    zlib1g-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

# Fire up ProperDocs from the root app directory
CMD ["properdocs", "serve", "--dev-addr=0.0.0.0:8000"]
