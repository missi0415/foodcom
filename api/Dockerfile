FROM ruby:2.7.1-alpine

ARG WORKDIR

ENV RUNTIME_PACKAGES="linux-headers libxml2-dev make gcc libc-dev nodejs tzdata postgresql-dev postgresql git less" \
    DEV_PACKAGES="build-base curl-dev" \
    HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# ENV test（このRUN命令は確認のためなので無くても良い）
RUN echo ${HOME}

WORKDIR ${HOME}

COPY Gemfile* ./
# ADD Gemfile ${HOME}/Gemfile
# ADD Gemfile.lock ${HOME}/Gemfile.lock

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4 && \
    apk del build-dependencies

COPY . .
# 開発環境-------------------------
# EXPOSE ${CONTAINER_PORT}

EXPOSE 3000
# CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0", "-e", "production"]
#----------------------------------

#　本番環境
# ADD . ${HOME}
CMD ["bundle", "exec", "rails", "s", "puma", "-b", "0.0.0.0", "-p", "3000", "-e", "production"]

