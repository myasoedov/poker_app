FROM elixir:1.7.4

WORKDIR /tmp

ENV NODE_VERSION=v8.11.4
ENV NODE_DISTRO=linux-x64
ENV NODE_HOME=/usr/local/lib/nodejs/node-$NODE_VERSION

RUN wget --quiet https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-$NODE_DISTRO.tar.xz
RUN mkdir /usr/local/lib/nodejs
RUN tar -xJf node-$NODE_VERSION-$NODE_DISTRO.tar.xz -C /usr/local/lib/nodejs
RUN mv /usr/local/lib/nodejs/node-$NODE_VERSION-$NODE_DISTRO $NODE_HOME

ENV PATH=$NODE_HOME:$PATH

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix archive.install hex phx_new 1.4.0 --force

ADD ./mix.exs ./mix.lock ./

VOLUME poker-deps:/app/deps
VOLUME poker-build:/app/_build

RUN mix deps.get
RUN mix deps.compile
