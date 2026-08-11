package trivy

# Default: do not ignore any finding.
default ignore = false

# linux-libc-dev ships the Linux kernel UAPI headers that are required only
# when compiling C extensions at runtime (docker-php-ext-install / PIE via
# libc6-dev). The headers are never loaded or executed in the running
# container, so their vulnerabilities are not exploitable at runtime. Ignoring
# this package removes ~85% of the CRITICAL/HIGH noise from the scan results
# while keeping every runtime-relevant finding tracked.
ignore {
	input.PkgName == "linux-libc-dev"
}
