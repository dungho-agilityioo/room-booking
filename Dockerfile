# Get base ruby 2.4
FROM ruby:2.4-alpine

ENV PATH /google-cloud-sdk/bin:$PATH
ENV CLOUD_SDK_VERSION 171.0.0

RUN apk update \
	&& apk upgrade \
	&& apk add tzdata \
		sqlite-dev \
    git \
		postgresql-dev \
		zlib-dev \
		libxml2-dev \
		libxslt-dev \
		nodejs \
		g++ \
		make \
		bash \
    curl \
    python \
    libc6-compat \
    openssh-client \
  && rm -rf /var/cache/apk/*
  && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image

VOLUME ["/root/.config"]

ENV HOME_PATH /home/app
ENV RAILS_VERSION 5.0.1
WORKDIR $HOME_PATH

RUN gem install rake --no-document

ENV BUNDLE_GEMFILE=$HOME_PATH/Gemfile \
	BUNDLE_PATH=/bundle

RUN bundle config build.nokogiri --use-system-libraries
RUN gem install rails --version "$RAILS_VERSION"

ADD Gemfile* $HOME_PATH/

RUN bundle install

ADD . $HOME_PATH

EXPOSE 3000
