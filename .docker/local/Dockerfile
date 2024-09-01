FROM ruby:3.3.4-slim

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    libpq-dev \
    git \
    cmake \
    libgit2-dev \
    cmake \
    pkg-config \
    curl \
    wget \
    nano \
    vim \
    shared-mime-info \
    libmagic-dev \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    ca-certificates \
    inetutils-ping \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl https://deb.nodesource.com/setup_20.x | bash
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn

RUN sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-client

RUN echo 'IRB.conf[:USE_AUTOCOMPLETE] = false' >> ~/.irbrc
RUN echo 'IRB.conf[:SAVE_HISTORY] = 10000' >> ~/.irbrc
RUN echo 'IRB.conf[:HISTORY_FILE] = "/usr/src/app/log/.irb_history"' >> ~/.irbrc

ENV LANG=C.UTF-8 \
  BUNDLE_RETRY=3

RUN gem update --system && gem install --no-user-install bundler

WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app

EXPOSE 3000
