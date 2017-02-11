{% set elasticsearch = pillar['elasticsearch'] %}

{% set patterns_dir = salt['cmd.run']('find / -name 'patterns'|grep -v lib') %}

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
  cmd.run:
    - name: /opt/logstash/bin/logstash -f /etc/logstash/conf.d/10-syslog.conf