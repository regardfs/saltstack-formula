{% from 'elasticsearch/map.jinja' import elasticsearch with context %}

include:
  - elasticsearch.repo

elasticsearch_pkg:
  pkg.installed:
    - name: {{ elasticsearch.pkg }}
    - version: {{ elasticsearch.major_version }}.*
    - require:
      - sls: elasticsearch.repo
