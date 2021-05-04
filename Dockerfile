FROM jekyll/builder

WORKDIR /tmp
ADD Gemfile /tmp/
ADD tale.gemspec /tmp/
RUN bundle update
RUN bundle install --no-deployment

FROM jekyll/jekyll

VOLUME /src
EXPOSE 4000

WORKDIR /src
ENTRYPOINT ["jekyll", "serve", "--livereload", "-H", "0.0.0.0"]