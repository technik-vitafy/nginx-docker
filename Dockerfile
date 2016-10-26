FROM funkygibbon/nginx-pagespeed

RUN cd ~ && cd /etc/nginx/sites-enabled/ && rm -f default.conf && rm -f default-ssl.conf

RUN echo "Build complete"
