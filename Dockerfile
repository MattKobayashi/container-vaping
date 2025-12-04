FROM alpine:3.23.0@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375

RUN apk --no-cache add \
  fping \
  librrd \
  zeromq \
  pipx

ENV USERNAME=vaping
ENV GROUPNAME=$USERNAME
ENV UID=911
ENV GID=911
ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/vaping/.local/bin
ENV USE_EMOJI=false
# uv and project
WORKDIR /opt/${USERNAME}
RUN addgroup \
  --gid "$GID" \
  "$GROUPNAME" \
  && adduser \
  --disabled-password \
  --gecos "" \
  --home "$(pwd)" \
  --ingroup "$GROUPNAME" \
  --no-create-home \
  --uid "$UID" \
  $USERNAME \
  && chown -R ${UID}:${GID} /opt/${USERNAME}
COPY --chmod=755 --chown=${UID}:${GID} entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --chmod=644 --chown=${UID}:${GID} config/config.yaml config.yaml
COPY --chmod=644 --chown=${UID}:${GID} requirements.txt requirements.txt
USER ${USERNAME}
RUN pipx install https://github.com/MattKobayashi/vaping/archive/refs/heads/main.zip \
  && pipx inject --force --requirement requirements.txt vaping
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
LABEL org.opencontainers.image.authors="MattKobayashi <matthew@kobayashi.au>"
