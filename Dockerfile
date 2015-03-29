FROM ruby:2.2.1
MAINTAINER Ash Wilson <smashwilson@gmail.com>

RUN useradd --no-create-home azure

WORKDIR /usr/src/page

ADD Gemfile /usr/src/page/Gemfile
ADD Gemfile.lock /usr/src/page/Gemfile.lock
RUN bundle install
ADD . /usr/src/page

RUN mkdir /var/www/
RUN chown -R azure:azure /usr/src/page /var/www/

VOLUME /var/www/
USER azure

ENTRYPOINT ["jekyll", "build", "--destination", "/var/www"]
