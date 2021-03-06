{% set logstash = pillar['logstash'] %}
{% set version = logstash.version %}

{% if grains['os_family'] == 'Debian' %}
{% for pkg in logstash.required_pkgs.Debian %}
{{ pkg }}_install:
  pkg.installed:
    - name: {{ pkg }}
    - hold: true
    - refresh: True
{% endfor %}
{% endif %}


logstash:
  pkgrepo.managed:
    - humanname: Logstash Repository
    - name: deb http://packages.elastic.co/logstash/{{ version }}/debian stable main
    - file: /etc/apt/sources.list.d/logstash-{{ version }}.x.list
  pkg.installed:
    - require:
      - pkgrepo: logstash
    - skip_verfy: True
    - refresh: True
    - hold: True
  cmd.run:
    - name: sudo update-rc.d logstash defaults 97 8
    - require:
      - pkg: logstash
  service.running:
    - name: logstash
    - enable: True
    - watch:
      - file: /etc/logstash/conf.d/10-syslog.conf
    - require:
      - pkg: logstash