# Floating stable tag on purpose: the previous pin (nginx:1.27-alpine) stopped
# being rebuilt upstream on 2025-04-16 when 1.27 left the mainline branch, so the
# image kept shipping Alpine 3.21.3 with 81 CVEs that a plain rebuild could not
# clear. `stable-alpine` always points at the current nginx stable release and is
# rebuilt whenever its Alpine base is patched. CI pins the result by digest anyway
# (the deployed image is tagged sha-<commit>), so builds stay traceable.
FROM nginx:stable-alpine

# Patch the Alpine packages the upstream tag has not been rebuilt with yet
# (libexpat 2.8.4 -> 2.8.5 on 2026-09-27) and drop root: the master process
# runs as the image's own `nginx` user (uid 101). Docker sets
# net.ipv4.ip_unprivileged_port_start=0 inside the container's network
# namespace, so port 80 still binds without any capability. The pid file moves
# to /tmp and the temp/cache dir is handed to `nginx`, the only two paths the
# master writes at runtime.
RUN apk upgrade --no-cache \
 && sed -i -e '/^user /d' -e 's|^pid .*|pid /tmp/nginx.pid;|' /etc/nginx/nginx.conf \
 && chown -R nginx:nginx /var/cache/nginx
RUN rm -f /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/portfolio.conf
COPY site/ /usr/share/nginx/html/
# Pre-compress text assets at max level for gzip_static (better ratio + no runtime CPU)
RUN find /usr/share/nginx/html -type f \
    \( -name '*.html' -o -name '*.css' -o -name '*.js' -o -name '*.svg' \
       -o -name '*.xml' -o -name '*.webmanifest' -o -name 'robots.txt' \) \
    -exec sh -c 'gzip -9 -k -f "$1"' _ {} \;
EXPOSE 80
USER nginx
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://127.0.0.1/ >/dev/null 2>&1 || exit 1
