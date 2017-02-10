{% set elasticsearch = pillar['elasticsearch'] %}

/etc/logstash/conf.d/10-syslog.conf:
  file.managed:
    - name: /etc/logstash/conf.d/10-syslog.conf
    - source: salt://logstash/files/10-syslog.conf
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - mode: 644
    - require:
      - pkg: logstash
    - watch_in:
      - service: logstash