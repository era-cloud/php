#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM debian:bookworm-slim

# prevent Debian's PHP packages from being installed
# https://github.com/docker-library/php/pull/542
RUN set -eux; \
	{ \
		echo 'Package: php*'; \
		echo 'Pin: release *'; \
		echo 'Pin-Priority: -1'; \
	} > /etc/apt/preferences.d/no-debian-php

# dependencies required for running "phpize"
# (see persistent deps below)
ENV PHPIZE_DEPS \
	autoconf \
	procps \
	wget \
	dpkg-dev \
	file \
	g++ \
	gcc \
	libc-dev \
	make \
	pkg-config \
	re2c

# persistent / runtime deps
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		$PHPIZE_DEPS \
		apt-transport-https \
		ca-certificates \
		ncat \
		ca-certificates \
		curl \
		unzip \
		xz-utils \
		adduser \
	; \
	rm -rf /var/lib/apt/lists/*; \
	rm -rf /usr/share/doc /usr/share/man /usr/share/info /usr/share/bug
# ensure app user exists
RUN set -eux; \
	addgroup --gid 82 --system app; \
	adduser --uid 82 --no-create-home --disabled-login --disabled-password --system --ingroup app app;

ENV PHP_INI_DIR=/usr/local/etc/php \
	APP_ROOT=/app-src \
	PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/app-src:/app-src/bin
RUN set -eux; \
	mkdir -p "$PHP_INI_DIR/conf.d"; \
# allow running as an arbitrary user (https://github.com/docker-library/php/issues/743)
	[ ! -d ${APP_ROOT} ]; \
	mkdir -p ${APP_ROOT}; \
	chown app:app ${APP_ROOT}; \
	chmod 1777 ${APP_ROOT}

# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# https://github.com/docker-library/php/issues/272
# -D_LARGEFILE_SOURCE and -D_FILE_OFFSET_BITS=64 (https://www.php.net/manual/en/intro.filesystem.php)
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -pie"

ENV GPG_KEYS 1198C0117593497A5EC5C199286AF1F9897469DC 49D9AF6BC72A80D6691719C8AA23F5BE9C7097D4 D95C03BC702BE9515344AE3374E44BC9067701A5

ENV PHP_VERSION 8.5.9
ENV PHP_URL="https://www.php.net/distributions/php-8.5.9.tar.xz" PHP_ASC_URL="https://www.php.net/distributions/php-8.5.9.tar.xz.asc"
ENV PHP_SHA256="0db7855f25bcd0ab1d592cdb35e284d6f6a5d2ae0f6f621122e364cc39b708f4"

RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends gnupg; \
	rm -rf /var/lib/apt/lists/*; \
	\
	mkdir -p /usr/src; \
	cd /usr/src; \
	\
	curl -fsSL -o php.tar.xz "$PHP_URL"; \
	\
	if [ -n "$PHP_SHA256" ]; then \
		echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; \
	fi; \
	\
	curl -fsSL -o php.tar.xz.asc "$PHP_ASC_URL"; \
	export GNUPGHOME="$(mktemp -d)"; \
	for key in $GPG_KEYS; do \
		i=0; \
		until gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; do \
			i=$((i+1)); \
			if [ "$i" -ge 3 ]; then exit 1; fi; \
			echo "gpg: keyserver timeout, retry $i/3 for key $key"; \
			sleep 5; \
		done; \
	done; \
	gpg --batch --verify php.tar.xz.asc php.tar.xz; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME"; \
	\
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

COPY docker-php-source /usr/local/bin/

RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libargon2-dev \
		libcurl4-openssl-dev \
		liblz4-dev \
		libonig-dev \
		libreadline-dev \
		libsodium-dev \
		libsqlite3-dev \
		libssl-dev \
		libxml2-dev \
		libzstd-dev \
		zlib1g-dev \
	; \
	\
	export \
		CFLAGS="$PHP_CFLAGS" \
		CPPFLAGS="$PHP_CPPFLAGS" \
		LDFLAGS="$PHP_LDFLAGS" \
# https://github.com/php/php-src/blob/d6299206dd828382753453befd1b915491b741c6/configure.ac#L1496-L1511
		PHP_BUILD_PROVIDER='https://github.com/docker-library/php' \
		PHP_UNAME='Linux - Docker' \
	; \
	docker-php-source extract; \
	cd /usr/src/php; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
# https://bugs.php.net/bug.php?id=74125
	if [ ! -d /usr/include/curl ]; then \
		ln -sT "/usr/include/$debMultiarch/curl" /usr/local/include/curl; \
	fi; \
	test "$PHP_INI_DIR" != "${PHP_INI_DIR%/php}"; \
	./configure \
		--build="$gnuArch" \
		--sysconfdir="${PHP_INI_DIR%/php}" \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
		\
# make sure invalid --configure-flags are fatal errors instead of just warnings
		--enable-option-checking=fatal \
		\
# https://github.com/docker-library/php/issues/439
		--with-mhash \
		\
# https://github.com/docker-library/php/issues/822
		--with-pic \
		\
# --enable-mbstring is included here because otherwise there's no way to get the extension installers (PIE) to use it properly (see https://github.com/docker-library/php/issues/195)
		--enable-mbstring \
# --enable-mysqlnd is included here because it's harder to compile after the fact than extensions are (since it's a plugin for several extensions, not an extension in itself)
		--enable-mysqlnd \
# https://wiki.php.net/rfc/argon2_password_hash
		--with-password-argon2 \
# https://wiki.php.net/rfc/libsodium
		--with-sodium=shared \
# always build against system sqlite3 (https://github.com/php/php-src/commit/6083a387a81dbbd66d6316a3a12a63f06d5f7109)
		--with-pdo-sqlite=/usr \
		--with-sqlite3=/usr \
		\
		--with-curl \
		--with-iconv \
		--with-openssl \
		--with-readline \
		--with-zlib \
		\
# https://github.com/bwoebi/phpdbg-docs/issues/1#issuecomment-163872806 ("phpdbg is primarily a CLI debugger, and is not suitable for debugging an fpm stack.")
		--disable-phpdbg \
		--with-libdir="lib/$debMultiarch" \
		\
		--disable-cgi \
		\
		--enable-zts \
# https://externals.io/message/118859
		--disable-zend-signals \
	; \
	make -j "$(nproc)"; \
	find -type f -name '*.a' -delete; \
	make install; \
	find \
		/usr/local \
		-type f \
		-perm '/0111' \
		-exec sh -euxc ' \
			strip --strip-all "$@" || : \
		' -- '{}' + \
	; \
	make clean; \
	\
# https://github.com/docker-library/php/issues/692 (copy default example "php.ini" files somewhere easily discoverable)
	cp -v php.ini-* "$PHP_INI_DIR/"; \
	cp -v php.ini-production "$PHP_INI_DIR/php.ini"; \
	\
	cd /; \
	docker-php-source delete; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	find /usr/local -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
		| sort -u \
		| xargs -rt dpkg-query --search \
# https://manpages.debian.org/trixie/dpkg/dpkg-query.1.en.html#S (we ignore diversions and it'll be really unusual for more than one package to provide any given .so file)
		| awk 'sub(":$", "", $1) { print $1 }' \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
	# the PHP build purge above removed liblz4-dev/libzstd-dev; reinstall them for the phpredis build
	apt-get update; \
	apt-get install -y --no-install-recommends liblz4-dev libzstd-dev; \
	\
# install PIE (PHP Installer for Extensions), the official replacement for PECL
# https://php.github.io/pie/ https://github.com/php/pie
	curl -fL --output /usr/local/bin/pie 'https://github.com/php/pie/releases/latest/download/pie.phar'; \
	chmod +x /usr/local/bin/pie; \
	\
	pie install --no-cache --no-build-tools-check --no-system-dependencies-check --skip-enable-extension msgpack/msgpack-php; \
	pie install --no-cache --no-build-tools-check --no-system-dependencies-check --skip-enable-extension 'igbinary/igbinary:^3.2@RC'; \
	pie install --no-cache --no-build-tools-check --no-system-dependencies-check --skip-enable-extension php-ds/ext-ds; \
	pie install --no-cache --no-build-tools-check --no-system-dependencies-check phpredis/phpredis \
		--enable-redis \
		--enable-redis-igbinary \
		--enable-redis-lz4 \
		--enable-redis-msgpack \
		--enable-redis-zstd \
		--with-liblz4=yes \
		--with-libzstd=yes; \
	# keep the runtime libs (liblz4-1/libzstd1) in the final image, drop the -dev packages
	apt-mark manual liblz4-1 libzstd1; \
	apt-get purge -y liblz4-dev libzstd-dev; \
	rm -rf /var/lib/apt/lists/*; \
	 \
	rm -rf /tmp/*; \
	rm -rf /usr/share/doc /usr/share/man /usr/share/info /usr/share/bug; \
	\
# smoke test
	php --version

COPY docker-php-ext-* docker-php-entrypoint /usr/local/bin/

# sodium was built as a shared module (so that it can be replaced later if so desired), so let's enable it too (https://github.com/docker-library/php/issues/598)
RUN docker-php-ext-enable sodium; \
	docker-php-ext-enable ds; \
	docker-php-ext-enable igbinary; \
	docker-php-ext-enable msgpack; \
	docker-php-ext-enable redis; \
	sed -i "s@;date.timezone =@date.timezone = Asia/Shanghai@g" "$PHP_INI_DIR/php.ini"; \
	sed -i "s@upload_max_filesize = 2M@upload_max_filesize = 2048M@g" "$PHP_INI_DIR/php.ini"; \
	sed -i "s@post_max_size = 8M@post_max_size = 2048M@g" "$PHP_INI_DIR/php.ini"; \
	sed -i "s@max_input_time = 60@max_input_time = 1800@g" "$PHP_INI_DIR/php.ini"; \
	sed -i "s@max_execution_time = 30@max_execution_time = 1800M@g" "$PHP_INI_DIR/php.ini"; \
	sed -i "s@memory_limit = 128M@memory_limit = 2048M@g" "$PHP_INI_DIR/php.ini"; \
	php --ri redis

# swoole module
ENV EXTRA_EXT \
	bcmath bz2 calendar exif ffi gd gettext intl \
	mysqli pcntl pdo_mysql pdo_pgsql shmop soap \
	sockets sysvmsg sysvsem sysvshm tidy zip

ENV EXTRA_LIBS \
	autoconf \
	libbz2-dev \
	libffi-dev \
	zlib1g-dev \
	libpng-dev \
	libicu-dev \
	libpq-dev \
	libxml2-dev \
	libzip-dev \
	libssl-dev \
	libcurl4-openssl-dev \
	libbrotli1 \
	libbrotli-dev \
	liblz4-dev \
	libzstd-dev \
	libsqlite3-dev \
	libtidy-dev \
	libc-ares-dev \
	libzip-dev

RUN set -ex; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends $EXTRA_LIBS; \
	rm -rf /var/lib/apt/lists/*; \
	docker-php-ext-install $EXTRA_EXT; \
	docker-php-ext-enable redis; \
	docker-php-ext-install sockets; \
	docker-php-source extract; \
	# swoole 6.2.2 fails to compile on newer g++ (GCC 15) without -fpermissive:
	# "converting to 'bool' from 'std::nullptr_t' requires direct-initialization"
	export CXXFLAGS="$CXXFLAGS -fpermissive"; \
	pie install --no-cache --no-build-tools-check --no-system-dependencies-check swoole/swoole \
		--enable-swoole-curl \
		--enable-cares \
		--enable-brotli \
		--enable-swoole-pgsql \
		--enable-swoole-sqlite \
		--with-openssl-dir=/usr \
		--enable-swoole-thread \
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
	# drop the -dev build dependencies while keeping the runtime libs the
	# compiled extensions actually link against (mirrors the PHP build above)
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
	rm -rf /tmp/*

RUN set -eux; \
	curl -o /usr/local/bin/composer https://mirrors.aliyun.com/composer/composer.phar; \
	chmod a+x /usr/local/bin/composer; \
	composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

ENTRYPOINT ["docker-php-entrypoint"]
STOPSIGNAL SIGWINCH

WORKDIR ${APP_ROOT}

EXPOSE 80\
	443

CMD ["php", "-a"]
