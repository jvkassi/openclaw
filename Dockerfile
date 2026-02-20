FROM alpine/openclaw:2026.2.19

USER root

RUN apt update -q
RUN apt install chromium iproute2 sudo -y
RUN apt install vim inetutils-ping netcat-traditional jq -y
RUN ln -s /app/openclaw.mjs /bin/openclaw
RUN echo '%sudo ALL=(ALL) NOPASSWD: ALL ' >> /etc/sudoers
RUN usermod -aG sudo node


RUN chown -R node: /usr/local/lib/node_modules /usr/local/bin
RUN curl -sSL https://raw.githubusercontent.com/pimalaya/himalaya/master/install.sh | bash

USER node

SHELL ["/bin/bash", "-c"]

RUN source ~/.bashrc
RUN curl -fsSL https://bun.com/install | bash
ENV BUN_INSTALL="/home/node/.bun"
ENV PATH="$BUN_INSTALL/bin:$PATH"
RUN chmod +x /home/node/.bun/bin/bun
RUN ls -l /home/node/.bun/bin/bun
RUN source /home/node/.bashrc
RUN /home/node/.bun/bin/bun --version

RUN bun install -g https://github.com/tobi/qmd
RUN npm i -g playwright
RUN bunx playwright install-deps chromium && \
    bunx playwright install chromium
RUN bun add -g agent-browser
RUN agent-browser install --with-deps
