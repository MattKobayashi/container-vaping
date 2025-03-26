FROM python:3.13.2-alpine3.21@sha256:323a717dc4a010fee21e3f1aac738ee10bb485de4e7593ce242b36ee48d6b352
ENV USERNAME=container-vaping
ENV GROUPNAME=$USERNAME
ENV UID=911
ENV GID=911
# uv and project
WORKDIR /opt/${USERNAME}
RUN apk --no-cache add \
      fping \
      librrd \
      uv \
      zeromq \
    && addgroup \
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
ADD https://github.com/20c/vaping.git#4d5e0f182676bb7555cde8988230181be4d8d9c2:src /opt/${USERNAME}
COPY --chmod=755 --chown=${UID}:${GID} entrypoint.sh entrypoint.sh
COPY --chmod=644 --chown=${UID}:${GID} pyproject.toml pyproject.toml
COPY --chmod=644 --chown=${UID}:${GID} README.md README.md
COPY --chmod=644 --chown=${UID}:${GID} config/config.yaml config.yaml
ENTRYPOINT ["sh", "entrypoint.sh"]
LABEL org.opencontainers.image.authors="MattKobayashi <matthew@kobayashi.au>"
