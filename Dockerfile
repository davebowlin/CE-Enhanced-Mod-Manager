# Use an official Python runtime pinned to a stable Debian version
FROM python:3.11-slim-bookworm

# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DISPLAY=:1
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies with retries and better error handling
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-tk \
    xvfb \
    x11vnc \
    openbox \
    menu \
    wget \
    ca-certificates \
    net-tools \
    python3-pip \
    websockify \
    dos2unix \
    procps \
    python3-xdg \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC
RUN mkdir -p /opt/novnc && \
    wget -qO- https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar xz --strip 1 -C /opt/novnc && \
    ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# Set the working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir watchdog[watchmedo]

# Copy the rest of the application code
COPY . .

# Fix line endings for Windows users and ensure executable
RUN dos2unix /app/scripts/docker-entrypoint.sh && chmod +x /app/scripts/docker-entrypoint.sh

# Expose the noVNC port
EXPOSE 6080

# Run the startup script
CMD ["/app/scripts/docker-entrypoint.sh"]
