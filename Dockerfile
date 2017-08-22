# Get base ruby 2.4
FROM ruby:2.4-alpine

RUN apk update \
	&& apk upgrade \
	&& apk add tzdata \
		sqlite-dev \
		postgresql-dev \
		zlib-dev \
		libxml2-dev \
		libxslt-dev \
		nodejs \
		g++ \
		make \
		bash \
	&& rm -rf /var/cache/apk/*

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