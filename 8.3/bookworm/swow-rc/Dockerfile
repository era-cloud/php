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
FROM ghcr.io/era-cloud/php:8.3-cli-bookworm

# 分层信息：便于 docker inspect 追溯这一层是基于哪个 base 构建的
LABEL cn.era-cloud.layer="extension" \
      cn.era-cloud.base="ghcr.io/era-cloud/php:8.3-cli-bookworm" \
      cn.era-cloud.ext.swoole="v6.1.14" \
      cn.era-cloud.ext.swow="v1.6.2" \
      cn.era-cloud.ext.swoole-rc="v6.3.0-rc2" \
      cn.era-cloud.ext.swow-rc="v2.0.0-alpha.3"

# swow
ENV EXT_BUILD_LIBS \
	libcurl4-openssl-dev \
	libssl-dev \
	libxml2-dev \
	openssl \
	git \
	bash \
	autoconf

RUN set -ex; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends $PHPIZE_DEPS $EXT_BUILD_LIBS; \
	rm -rf /var/lib/apt/lists/*; \
	docker-php-source extract; \
	docker-php-source delete; \
	pie install --no-cache --no-build-tools-check --no-system-dependencies-check 'swow/swow-extension:dev-develop#7486e5422c357f4626b176ab87f842b3d2340497'; \
	echo "memory_limit=1G" >  /usr/local/etc/php/conf.d/00-default.ini; \
	echo "opcache.enable_cli = 'On'" >>  /usr/local/etc/php/conf.d/50-opcache.ini; \
	echo "extension=swow.so" > /usr/local/etc/php/conf.d/docker-php-ext-swow.ini; \
	php --version; \
	php -m; \
	php --ri swow; \
	# 只保留编译产物实际链接的运行时库，丢弃 -dev 构建依赖
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	find /usr/local -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| awk 'sub(":$", "", $1) { print $1 }' \
		| sort -u \
		| xargs -r apt-mark manual; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	rm -rf /usr/share/doc /usr/share/man /usr/share/info /usr/share/bug; \
	rm -rf /tmp/*; \
	rm -rf /root/.pie

ENTRYPOINT ["docker-php-entrypoint"]
STOPSIGNAL SIGWINCH

WORKDIR ${APP_ROOT}

EXPOSE 80\
	443

CMD ["php", "-a"]
