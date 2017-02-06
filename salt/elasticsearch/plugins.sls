include:
  - elasticsearch.pkg


{% from 'elasticsearch/map.jinja' import elasticsearch with context %}

{% set major_version = elasticsearch['major_version'] %}
{%- if major_version == 5 %}
{%- set plugin_bin = elasticsearch['plugin_bin_5'] %}
{%- else %}
{%- set plugin_bin = elasticsearch['plugin_bin_2'] %}
{%- endif %}

{% set plugins = elasticsearch.plugins %}
{% for name, repo in plugins.items() %}
elasticsearch-{{ name }}:
  cmd.run:
    - name: /usr/share/elasticsearch/bin/{{ plugin_bin }} install {{ repo }} --verbose
    - require:
      - sls: elasticsearch.pkg
    - unless: test -x /usr/share/elasticsearch/plugins/{{ name }}
{% endfor %}
