{% from 'elasticsearch/map.jinja' import elasticsearch with context %}

include:
  - elasticsearch.service

{% set sysconfig_file = elasticsearch.sysconfig_file %}
{% if sysconfig_file %}
{{ sysconfig_file }}:
  file.managed:
    - source: salt://elasticsearch/files/sysconfig
    - owner: elasticsearch
    - group: elasticsearch
    - mode: 0600
    - template: jinja
    - watch_in:
      - service: elasticsearch_service
    - context:
        sysconfig: {{ elasticsearch.sysconfig }}
{% endif %}

{%- set java_home = elasticsearch.java_home %}
{% if java_home %}
java_home_sysconfig:
  file.replace:
    - name: {{ sysconfig_file }}
    - pattern: ^[\s#]*JAVA_HOME=.*$
    - repl: JAVA_HOME={{ java_home }}
    - prepend_if_not_found: true
    - watch_in:
      - service: elasticsearch
{% endif %}

