FROM elixir:1.7.4

WORKDIR /tmp

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

ADD ./mix.exs ./mix.lock ./

VOLUME poker-deps:/app/deps
VOLUME poker-build:/app/_build

RUN mix deps.get
RUN mix deps.compile
