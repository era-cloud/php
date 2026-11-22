#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

# 扩展层：在自家 base 镜像（cli / zts）上安装 swoole / swow。
# - base 层已编译 PHP + 全部 EXTRA_EXT（bcmath/gd/intl/zip…），并已启用
#   sodium / ds / igbinary / msgpack / redis。
# - 这里只装扩展本体，因此扩展版本升级时不会重编 PHP。
# - env.from 是自家镜像的短别名（如 ghcr.io/era-cloud/php:8.5-cli-trixie），
#   架构与 base 完全一致，由 generate-stackbrew-library.sh 继承。
FROM ghcr.io/era-cloud/php:8.2-cli-alpine3.24

# 分层信息：便于 docker inspect 追溯这一层是基于哪个 base 构建的
LABEL cn.era-cloud.layer="extension" \
      cn.era-cloud.base="ghcr.io/era-cloud/php:8.2-cli-alpine3.24" \
      cn.era-cloud.ext.swoole="v6.2.6" \
      cn.era-cloud.ext.swow="v1.6.2" \
      cn.era-cloud.ext.swoole-rc="v6.3.0-rc2" \
      cn.era-cloud.ext.swow-rc="v2.0.0-alpha.3"

# swow
ENV EXT_BUILD_LIBS \
	curl-dev \
	openssl-dev \
	pcre-dev pcre2-dev linux-headers gettext-dev \
	openssl \
	git \
	bash \
	autoconf

RUN set -ex; \
	apk add --no-cache --virtual .build-deps \
	g++ \
	gcc \
	libc-dev \
	make \
	pkgconf \
	$PHPIZE_DEPS \
	$EXT_BUILD_LIBS; \
	docker-php-source extract; \
	docker-php-source delete; \
	pie install --no-cache --no-build-tools-check --no-system-dependencies-check 'swow/swow-extension:dev-develop#7486e5422c357f4626b176ab87f842b3d2340497'; \
	echo "memory_limit=1G" >  /usr/local/etc/php/conf.d/00-default.ini; \
	echo "opcache.enable_cli = 'On'" >>  /usr/local/etc/php/conf.d/50-opcache.ini; \
	echo "extension=swow.so" > /usr/local/etc/php/conf.d/docker-php-ext-swow.ini; \
	php --version; \
	php -m; \
	php --ri swow; \
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache $runDeps; \
	apk del --no-network .build-deps; \
	rm -rf /tmp/*; \
	rm -rf /root/.pie

ENTRYPOINT ["docker-php-entrypoint"]
STOPSIGNAL SIGWINCH

WORKDIR ${APP_ROOT}

EXPOSE 80\
	443

CMD ["php", "-a"]
