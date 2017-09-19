# Get base ruby 2.4
FROM ruby:2.3.3

ENV PATH /google-cloud-sdk/bin:$PATH
ENV CLOUD_SDK_VERSION 171.0.0

# Install runtime dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        nodejs \
        curl \
        openjdk-7-jre \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl https://sdk.cloud.google.com | bash && \
  cat /root/google-cloud-sdk/path.bash.inc | bash && \
  cat /root/google-cloud-sdk/completion.bash.inc | bash && \
  /root/google-cloud-sdk/bin/gcloud components install -q pubsub-emulator beta


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
