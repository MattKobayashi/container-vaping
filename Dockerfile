FROM python:3.13.1-alpine3.19@sha256:8287ca207e905649e9f399b5f91a119e5e9051d8cd110d5f8c3b4bd9458ebd1d
ENV USERNAME=container-vaping
ENV GROUPNAME=$USERNAME
ENV UID=911
ENV GID=911
ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/container-vaping/.local/bin
ENV USE_EMOJI=false
# uv and project
WORKDIR /opt/${USERNAME}
RUN apk --no-cache add \
      fping \
      librrd \
      zeromq \
    && python3 -m pip install pipx \
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
COPY --chmod=644 --chown=${UID}:${GID} config/config.yaml config.yaml
COPY --chmod=644 --chown=${UID}:${GID} requirements.txt requirements.txt
USER ${USERNAME}
RUN pipx install --verbose https://github.com/20c/vaping/archive/4d5e0f182676bb7555cde8988230181be4d8d9c2.tar.gz \
    && pipx inject --force --requirement requirements.txt --verbose vaping
ENTRYPOINT ["vaping", "start", "--home=/opt/container-vaping", "--no-fork"]
LABEL org.opencontainers.image.authors="MattKobayashi <matthew@kobayashi.au>"
