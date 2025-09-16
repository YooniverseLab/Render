FROM ubuntu:20.04
LABEL maintainer="wingnut0310 <wingnut0310@gmail.com>"

# 필요한 패키지들을 설치합니다. supervisor도 추가했어요.
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    curl \
    gnupg \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# PufferPanel GPG 키와 저장소를 추가합니다.
RUN curl -sSLo /usr/share/keyrings/pufferpanel-archive-keyring.gpg https://packages.pufferpanel.com/pufferpanel.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/pufferpanel-archive-keyring.gpg] https://packages.pufferpanel.com/debian $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/pufferpanel.list

# PufferPanel과 데몬을 설치합니다.
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    pufferpanel \
    pufferpanel-daemon \
    && rm -rf /var/lib/apt/lists/*

# Supervisord 설정을 위한 파일을 추가합니다.
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# PufferPanel 포트 노출
EXPOSE 8080 5656 8443

# Supervisord를 시작합니다.
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
