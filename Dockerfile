# Look here for latest version alpine/openclaw - Docker Image
FROM ghcr.io/openclaw/openclaw:2026.4.5-slim

# Switch to root , to install packages
USER root

RUN apt update -q
RUN apt install chromium iproute2 sudo tmux screen  unzip -y
RUN apt install vim inetutils-ping netcat-traditional jq -y
RUN ln -s /app/openclaw.mjs /bin/openclaw

# Fix node permission
RUN echo '%sudo ALL=(ALL) NOPASSWD: ALL ' >> /etc/sudoers
RUN usermod -aG sudo node
RUN chown -R node: /usr/local/lib/node_modules /usr/local/bin

USER node

SHELL ["/bin/bash", "-c"]

RUN source ~/.bashrc
# Install bun for faster dependencies install
RUN curl -fsSL https://bun.com/install | bash
ENV BUN_INSTALL="/home/node/.bun"
ENV PATH="/home/node/.local/bin:$BUN_INSTALL/bin:$PATH"
RUN chmod +x /home/node/.bun/bin/bun
RUN ls -l /home/node/.bun/bin/bun
RUN source /home/node/.bashrc
RUN /home/node/.bun/bin/bun --version

# Install agent-browser for web ui navigation
RUN npm i -g playwright
RUN bunx playwright install-deps chromium && \
    bunx playwright install chromium
RUN bun add -g agent-browser
RUN agent-browser install --with-deps

# Install qmd , for memory management
RUN bun pm -g untrusted
RUN npm install -g @tobilu/qmd

# Add opencode
RUN bun add -g opencode-ai

# Install himalya
RUN curl -sSL https://raw.githubusercontent.com/pimalaya/himalaya/master/install.sh | PREFIX=~/.local sh

RUN tmux new -d
