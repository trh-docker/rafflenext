FROM quay.io/spivegin/caddy_only:latest AS caddy_only
FROM quay.io/spivegin/dartdev:latest AS git
WORKDIR /opt/tlm/
RUN ssh-keyscan -H github.com > ~/.ssh/known_hosts &&\
    ssh-keyscan -H gitlab.com >> ~/.ssh/known_hosts
# RUN git clone git@gitlab.com:rafflenext/web.git trivia_web
RUN git clone https://deploy:5nLIzDZnmKxxLsCDObGX@sc.tpnfc.us/RaffleNext/gcx_grand.git && \
    git clone https://deploy:5nLIzDZnmKxxLsCDObGX@sc.tpnfc.us/askforitpro/game_trivia.git &&\
    git clone git@gitlab.com:trhhosting/gcx_grand_scss.git &&\
    cd gcx_grand &&\
    pub run build_runner build -r --delete-conflicting-outputs -o release

FROM quay.io/spivegin/tlmbasedebian
RUN mkdir /opt/bin
WORKDIR /opt/tlm/
ADD Caddyfile /opt/tlm/
COPY --from=git /opt/tlm/gcx_grand/release/web /opt/tlm/trivia_web
COPY --from=caddy_only /opt/bin/caddy /opt/bin/caddy
RUN chmod +x /opt/bin/caddy && ln -s /opt/bin/caddy /bin/caddy
CMD ["caddy", "-conf", "/opt/tlm/Caddyfile"]
EXPOSE 8080