{% from 'nginx/map.jinja' import nginx with context %}

{% set nginx_version = nginx.nginx_version %}

{% set tarball_url = nginx.get('tarball_url', 'http://nginx.org/download/nginx-' + nginx_version + '.tar.gz') -%}
{% set tarball_checksum = nginx.get('tarball_checksum', 'sha1=d8f225e7bb9503ee9084c25f6056a3493dfd4db8') -%}


{% if nginx.install_from_source %}
{{ nginx.dependencies_dir+'/nginx-'+nginx_version+'.tar.gz' }}:
  file.managed:
    - source: {{ tarball_url }}
    - source_hash: {{ tarball_checksum }}
    - user: {{ nginx.default_user }}
    - group: {{ nginx.default_group }}
    - mode: 755
    - require:
{%- for module, moduleinfo in nginx.dependencies_modules.iteritems() %}
      - file: {{ nginx.dependencies_dir+'/'+module }}
{%- endfor %}
{% endif %}

