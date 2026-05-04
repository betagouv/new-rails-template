FROM ruby:4.0.3-slim

RUN apt-get update && apt-get install -y --no-install-recommends build-essential git libyaml-dev

RUN gem install rails

WORKDIR /app

COPY template.rb ./

RUN git config --global user.email "runner@github.com"
RUN git config --global user.name "the Docker"

RUN rails new --skip-kamal -T -f -m ./template.rb foobar

WORKDIR /app/foobar

EXPOSE 3000

CMD ["./bin/rails", "s", "-b", "0.0.0.0"]
