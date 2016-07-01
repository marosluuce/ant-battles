FROM alpine:3.4

ENV RELX_REPLACE_OS_VARS=true

ENV erlang_version 18.3.2-r0
RUN apk --update add erlang=${erlang_version} \
                     erlang-erts=${erlang_version} \
                     erlang-crypto=${erlang_version} \
                     erlang-sasl=${erlang_version}

ADD rel /rel
ADD elm/index.html /elm/index.html
ADD elm/elm.js     /elm/elm.js

EXPOSE 4000

CMD ["/rel/ant_battles/bin/ant_battles", "foreground"]
