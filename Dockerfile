FROM ubuntu:14.04

EXPOSE 80
EXPOSE 443

# http://nginx.org/en/download.html
ENV NGINX_VERSION 1.11.4

# https://github.com/pagespeed/ngx_pagespeed/releases
ENV PAGESPEED_VERSION 1.11.33.4

# https://www.openssl.org/source
ENV OPENSSL_VERSION 1.0.2i

RUN useradd -r -s /usr/sbin/nologin nginx && mkdir -p /var/log/nginx /var/cache/nginx
RUN	apt-get update
RUN	apt-get -y --no-install-recommends install wget git-core autoconf automake libtool build-essential zlib1g-dev libpcre3-dev libxslt1-dev libxml2-dev libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev
#RUN	echo "Downloading nginx v${NGINX_VERSION} from http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" && wget -qO - http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar zxf - -C /tmp && echo "	:DONE"
ADD ./nginx-${NGINX_VERSION}.tar.gz /tmp
#RUN	echo "Downloading ngx_pagespeed v${PAGESPEED_VERSION} from https://github.com/pagespeed/ngx_pagespeed/archive/v${PAGESPEED_VERSION}-beta.tar.gz" && wget -qO - https://github.com/pagespeed/ngx_pagespeed/archive/v${PAGESPEED_VERSION}-beta.tar.gz | tar zxf - -C /tmp && echo "	:DONE"
ADD ngx_pagespeed-${PAGESPEED_VERSION}-beta.tar /tmp
#RUN	echo "Downloading pagespeed psol v${PAGESPEED_VERSION} from https://dl.google.com/dl/page-speed/psol/${PAGESPEED_VERSION}.tar.gz" && wget -qO - https://dl.google.com/dl/page-speed/psol/${PAGESPEED_VERSION}.tar.gz | tar xzf  - -C /tmp/ngx_pagespeed-${PAGESPEED_VERSION}-beta && echo "	:DONE"
ADD ${PAGESPEED_VERSION}.tar /tmp/ngx_pagespeed-${PAGESPEED_VERSION}-beta
#RUN	echo "Downloading openssl v${OPENSSL_VERSION} from https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz" && wget -qO - https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | tar xzf  - -C /tmp && echo "	:DONE"
ADD openssl-${OPENSSL_VERSION}.tar /tmp
RUN	cd /tmp/nginx-${NGINX_VERSION} && \
	./configure \
		--prefix=/etc/nginx  \
		--sbin-path=/usr/sbin/nginx  \
		--conf-path=/etc/nginx/nginx.conf  \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp  \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp  \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp  \
		--user=nginx  \
		--group=nginx  \
		--with-http_ssl_module  \
		--with-http_realip_module  \
		--with-http_addition_module  \
		--with-http_sub_module  \
		--with-http_dav_module  \
		--with-http_flv_module  \
		--with-http_mp4_module  \
		--with-http_gunzip_module  \
		--with-http_gzip_static_module  \
		--with-http_random_index_module  \
		--with-http_secure_link_module \
		--with-http_stub_status_module  \
		--with-http_auth_request_module  \
		--without-http_autoindex_module \
		--without-http_ssi_module \
		--with-threads  \
		--with-stream  \
		--with-stream_ssl_module  \
		--with-mail  \
		--with-mail_ssl_module  \
		--with-file-aio  \
		--with-http_v2_module \
		--with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2'  \
		--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' \
		--with-ipv6 \
		--with-pcre-jit \
		--with-openssl=/tmp/openssl-${OPENSSL_VERSION} \
		--add-module=/tmp/ngx_pagespeed-${PAGESPEED_VERSION}-beta  && \
	make && \
	make install && \
	apt-get purge -yqq automake autoconf libtool git-core build-essential zlib1g-dev libpcre3-dev libxslt1-dev libxml2-dev libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev && \
	apt-get autoremove -yqq && \
	apt-get clean && \
	rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

ENV DEFAULT_APP_USER app
ENV DEFAULT_APP_GROUP app
ENV DEFAULT_APP_UID 1000
ENV DEFAULT_APP_GID 1000
ENV DEFAULT_UPLOAD_MAX_SIZE 30M
ENV DEFAULT_NGINX_MAX_WORKER_PROCESSES 8
ENV DEFAULT_CHOWN_APP_DIR true

ENV SSL_ENABLED true

COPY . /app

RUN chmod 750 /app/bin/*.sh

RUN /app/bin/init_nginx.sh

CMD ["/sbin/my_init"]
