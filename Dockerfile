FROM funkygibbon/nginx-pagespeed

RUN echo "Remove all default config files of the funkygibbon image" && \
		cd ~/etc/nginx/sites-enabled/
RUN rm -f default.conf
RUN rm -f default-ssl.conf


RUN echo "Build complete"
