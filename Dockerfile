# Usa un'immagine base Python
FROM python:3.11-slim

# Imposta la directory di lavoro
WORKDIR /app

# Installa le dipendenze di sistema per Playwright (minime)
RUN apt-get update && \
    apt-get install -y \
    wget \
    gnupg \
    curl \
    libnss3 \
    libatk-bridge2.0-0 \
    libxkbcommon0 \
    libgtk-3-0 \
    libasound2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libdrm2 \
    libxshmfence1 \
    && rm -rf /var/lib/apt/lists/*

# Copia i file delle dipendenze
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Installa Playwright con Chromium (solo il necessario)
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
RUN python -m playwright install chromium

# IMPORTANTE: Imposta variabili per ridurre l'uso di memoria
ENV NODE_OPTIONS="--max-old-space-size=256"
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=0

# Copia tutto il codice
COPY . .

# Espone la porta 8080
EXPOSE 8080

# Avvia l'applicazione
CMD ["python", "vidsrc_extractor.py"]
