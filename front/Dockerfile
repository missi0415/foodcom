FROM node:14.15.0-alpine

ARG WORKDIR
ARG CONTAINER_PORT
# 本番環境
# ARG API_URL

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    HOST=0.0.0.0 \
    # API_URL=https://foodcom-api.work/ \
    NPM_CONFIG_PRODUCTION=false

# ENV check
RUN echo ${HOME}
RUN echo ${CONTAINER_PORT}
RUN echo ${API_URL}

WORKDIR ${HOME}

COPY package*.json ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache make gcc g++ python && \
    yarn install && \
    rm -rf /var/cache/apk/*

COPY . .

# 開発環境-------------------------
RUN yarn run build
EXPOSE ${CONTAINER_PORT}
# ----------------------------------

# 本番環境-------------------------
# RUN yarn run build
# EXPOSE 3000
# CMD ["yarn","run","start"]
#----------------------------------

