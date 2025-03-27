FROM python:3.13.2-alpine3.21@sha256:323a717dc4a010fee21e3f1aac738ee10bb485de4e7593ce242b36ee48d6b352
ENV APP_NAME=container-vaping
ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin
ENV USE_EMOJI=false
# uv and project
WORKDIR /opt/${APP_NAME}
RUN apk --no-cache add \
      fping \
      librrd \
      zeromq \
    && python3 -m pip install pipx
COPY --chmod=444 config/config.yaml config.yaml
COPY --chmod=444 requirements.txt requirements.txt
RUN pipx install https://github.com/MattKobayashi/vaping/archive/refs/heads/main.zip \
    && pipx inject --force --requirement requirements.txt vaping
ENTRYPOINT ["vaping", "start", "--home=/opt/container-vaping", "--no-fork"]
LABEL org.opencontainers.image.authors="MattKobayashi <matthew@kobayashi.au>"
