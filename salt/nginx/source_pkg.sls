{% from 'nginx/map.jinja' import nginx with context %}

{% set nginx_version = nginx.nginx_version %}

{% set tarball_url = nginx.get('tarball_url', 'http://nginx.org/download/nginx-' + nginx_version + '.tar.gz') -%}
{% set tarball_checksum = nginx.get('tarball_checksum', 'sha1=d8f225e7bb9503ee9084c25f6056a3493dfd4db8') -%}


nginx:
  file.managed:
    - name: {{ nginx.dependencies_dir+'/nginx-'+nginx_version+'.tar.gz' }}
    - source: {{ tarball_url }}
    - source_hash: {{ tarball_checksum }}
    - user: {{ nginx.default_user }}
    - group: {{ nginx.default_group }}
    - mode: 755
    - require:
{%- for module, moduleinfo in nginx.dependencies_modules.iteritems() %}
      - file: {{ nginx.dependencies_dir+'/'+module }}
{%- endfor %}
  cmd.wait:
    - env:
      - FILE: nginx-{{ nginx_version }}.tar.gz
    - cwd: {{ nginx.dependencies_dir }}
    - name: tar zxvf $FILE && cd `echo "${FILE%%.tar.gz}"` && chown {{ nginx.default_user }}:{{ nginx.default_group }} . && ./configure --prefix=/etc/nginx --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-pcre=../pcre-8.40 --with-zlib=../zlib-1.2.11 --with-http_ssl_module --with-stream --with-mail=dynamic && make && make install
    - watch:
      - file: {{ nginx.dependencies_dir+'/nginx-'+nginx_version+'.tar.gz' }}

