FROM funkygibbon/nginx-pagespeed

RUN echo "Remove all default config files of the funkygibbon image" && \
		cd ~/etc/nginx/sites-enabled/ && rm -f default.conf && rm -f default-ssl.conf


RUN echo "Build complete"
