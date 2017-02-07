{% from 'elasticsearch/map.jinja' import elasticsearch with context %}

/opt/kibana/config/kibana.yml:
  file.managed:
  - name: /opt/kibana/config/kibana.yml
  - source: salt://kibana/files/kibana.yml
  - user: {{ elasticsearch.user }}
  - group: {{ elasticsearch.group }}
  - mode: 644
  - require:
    - pkg: kibana_pkg
