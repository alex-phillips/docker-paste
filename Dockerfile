FROM lsiobase/nginx:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
ARG GIST_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips"

ENV HOME="/config"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	php7 \
	php7-mysqli \
	php7-pdo_mysql && \
 echo "**** install paste ****" && \
 mkdir -p /app/paste && \
 if [ -z ${PASTE_RELEASE+x} ]; then \
	PASTE_RELEASE=$(curl -sX GET "https://api.github.com/repos/jordansamuel/paste/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 /tmp/paste.tar.gz -L \
	"https://github.com/jordansamuel/paste/archive/${PASTE_RELEASE}.tar.gz" && \
 tar xf \
 /tmp/paste.tar.gz -C \
	/app/paste/ --strip-components=1 && \

 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# copy local files
COPY root/ /
