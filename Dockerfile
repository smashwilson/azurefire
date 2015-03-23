FROM ruby:2.2.1
MAINTAINER Ash Wilson <smashwilson@gmail.com>

RUN gem install jekyll fog therubyracer
RUN useradd --no-create-home azure
ADD . /usr/src/page
RUN chown -R azure:azure /usr/src/page
WORKDIR /usr/src/page

USER azure
