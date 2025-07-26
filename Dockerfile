FROM node:slim

ENV NODE_ENV=production
ENV USER=choreouser
ENV UID=10008
ENV GID=10008

RUN --mount=type=cache,target=/var/cache/apt \
    set -ex \
    && echo "deb http://deb.debian.org/debian stable main" > /etc/apt/sources.list \
    && apt-get update -qq \
    && apt-get install -y --no-install-recommends linux-libc-dev \
    && groupadd -g $GID choreo \
    && useradd -u $UID -g choreo -M -s /bin/bash $USER \
    && mkdir -p /home/$USER \
    && chown -R $USER:choreo /home/$USER \
    && apt-get clean

WORKDIR /home/choreouser

COPY --chmod=755 files/* ./
RUN npm install --production --no-audit --no-fund

EXPOSE 3000

USER 10008

CMD ["node", "--optimize-for-size", "--max-old-space-size=460", "index.js"]
