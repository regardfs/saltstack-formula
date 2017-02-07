{% from 'nginx/map.jinja' import nginx with context %}


{% set kibana = pillar['kibana'] %}


{{ kibana.htpasswd_file }}:
  file.managed:
    - name: {{ kibana.htpasswd_file }}
    - source: salt://htpasswd/files/htpasswd.elbusers
    - template: jinja
    - user: {{ nginx.default_user }}
    - group: {{ nginx.default_group }}
    - mode: 644