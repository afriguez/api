FROM elixir:1.16-alpine AS build

ENV MIX_ENV=prod

WORKDIR /app

COPY . /app/

RUN mix local.hex --force && \
	mix local.rebar --force && \
	mix deps.get && \
	mix compile && \
	mix release

FROM elixir:1.14-alpine

COPY --from=build /app/_build/prod/rel/api /opt/api

CMD ["/opt/api/bin/api", "start"]
