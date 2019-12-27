FROM quay.io/spivegin/caddy_only:latest AS caddy_only
FROM quay.io/spivegin/gitonly:latest AS git
WORKDIR /opt/tlm/
RUN git clone https://github.com/rafflenext/rafflenext.github.io.git trivia_web

FROM quay.io/spivegin/tlmbasedebian
RUN mkdir /opt/bin
WORKDIR /opt/tlm/
ADD Caddyfile /opt/tlm/
COPY --from=git /opt/tlm/trivia_web /opt/tlm/trivia_web
COPY --from=caddy_only /opt/bin/caddy /opt/bin/caddy
RUN chmod +x /opt/bin/caddy && ln -s /opt/bin/caddy /bin/caddy
CMD ["caddy", "-conf /opt/tlm/Caddyfile"]
EXPOSE 8080