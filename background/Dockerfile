# Get base ruby 2.3
# Get base ruby 2.4
FROM ruby:2.3.3

# Install runtime dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
        build-essential \
        nodejs \
    && rm -rf /var/lib/apt/lists/*

ENV HOME_PATH /home/app
WORKDIR $HOME_PATH

ENV BUNDLE_GEMFILE=$HOME_PATH/Gemfile \
	BUNDLE_PATH=/bundle

RUN bundle config build.nokogiri --use-system-libraries

ADD Gemfile* $HOME_PATH/

RUN bundle install

ADD . $HOME_PATH

#RUN bundle exec sidekiq -r ./config/all_jobs.rb
