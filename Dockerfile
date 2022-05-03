FROM ruby:2.7.4

# install rails dependencies
RUN apt-get clean all && apt-get update -qq && apt-get install -y build-essential libpq-dev \
    curl gnupg2 apt-utils default-libmysqlclient-dev git libcurl3-dev cmake \
    libssl-dev pkg-config openssl imagemagick file nodejs yarn


WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .

# RUN apk del build_deps

ENV RAILS_ENV production

EXPOSE 3000