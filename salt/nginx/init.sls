{% from 'nginx/map.jinja' import nginx with context %}

include:
{% if nginx.install_from_source == "True" %}
  - nginx.source_pkg_pre
  - nginx.source_pkg
{% else %}
  - nginx.repo_pkg
  - nginx.repo_conf
{% endif %}