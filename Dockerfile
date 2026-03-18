# Containerized Claude Code environment for Massdriver development
FROM node:20-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Install Massdriver CLI v1.14.3
RUN ARCH=$(dpkg --print-architecture) && \
    curl -sSL -o /tmp/mass.tar.gz "https://github.com/massdriver-cloud/mass/releases/download/1.14.3/mass-1.14.3-linux-${ARCH}.tar.gz" && \
    tar -xzf /tmp/mass.tar.gz -C /usr/local/bin mass && \
    rm /tmp/mass.tar.gz && \
    chmod +x /usr/local/bin/mass

# Install Checkov for compliance scanning
RUN pip3 install checkov --break-system-packages

# Create working directory
WORKDIR /workspace

# Create config directory for Massdriver
RUN mkdir -p /root/.config/massdriver

# Default command
CMD ["bash"]
