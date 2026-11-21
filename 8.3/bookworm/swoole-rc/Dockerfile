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
      cn.era-cloud.ext.swoole="v6.2.6" \
      cn.era-cloud.ext.swow="v1.6.2" \
      cn.era-cloud.ext.swoole-rc="v6.3.0-rc2" \
      cn.era-cloud.ext.swow-rc="v2.0.0-alpha.3"

# swoole module（PHP 与 EXTRA_EXT 已由 base 层提供，这里只准备 swoole 的编译依赖）
ENV EXT_BUILD_LIBS \
	libcurl4-openssl-dev \
	libssl-dev \
	libbrotli-dev \
	libc-ares-dev \
	libsqlite3-dev \
	libpq-dev \
	liblz4-dev \
	libzstd-dev \
	libxml2-dev \
	autoconf

RUN set -ex; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends $EXT_BUILD_LIBS; \
	rm -rf /var/lib/apt/lists/*; \
	docker-php-source extract; \
	# swoole 6.2.2 fails to compile on newer g++ (GCC 15) without -fpermissive:
	# "converting to 'bool' from 'std::nullptr_t' requires direct-initialization"
	export CXXFLAGS="$CXXFLAGS -fpermissive"; \
	pie install --no-cache --no-build-tools-check --no-system-dependencies-check 'swoole/swoole:dev-master#62310ca5fa8ae63d725226c53cd237bb00e7e581' \
		--enable-swoole-curl \
		--enable-cares \
		--enable-brotli \
		--enable-swoole-pgsql \
		--enable-swoole-sqlite \
		--with-openssl-dir=/usr \
		; \
	docker-php-ext-enable swoole; \
	docker-php-source delete; \
	php --version; \
	php -m; \
	{ \
	echo "[swoole]"; \
	echo "extension=swoole"; \
	echo "swoole.unixsock_buffer_size=512M"; \
	echo "swoole.use_shortname=Off"; \
	echo "swoole.enable_preemptive_scheduler=On"; \
	} | tee /usr/local/etc/php/conf.d/docker-php-ext-swoole.ini; \
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
