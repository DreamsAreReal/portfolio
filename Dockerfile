FROM nginx:1.27-alpine
RUN rm -f /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/portfolio.conf
COPY site/ /usr/share/nginx/html/
# Pre-compress text assets at max level for gzip_static (better ratio + no runtime CPU)
RUN find /usr/share/nginx/html -type f \
    \( -name '*.html' -o -name '*.css' -o -name '*.js' -o -name '*.svg' \
       -o -name '*.xml' -o -name '*.webmanifest' -o -name 'robots.txt' \) \
    -exec sh -c 'gzip -9 -k -f "$1"' _ {} \;
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://127.0.0.1/ >/dev/null 2>&1 || exit 1
