{% from 'nginx/map.jinja' import nginx with context %}
{% set kibana = pillar['kibana'] %}

include:
  - kibana

/etc/nginx/sites-available/elb_web.conf:
  file.managed:
    - name: /etc/nginx/sites-available/elb_web.conf
    - source: salt://nginx/files/elb_web.conf
    - template: jinja
    - user: {{ nginx.default_user }}
    - group: {{ nginx.default_group }}
    - mode: 644
    - context:
      kibana: {{ kibana }}
    - require:
      - service: kibana_service

/etc/nginx/sites-enabled/elb_web.conf:
  file.symlink:
    - name: /etc/nginx/sites-enabled/elb_web.conf
    - target: /etc/nginx/sites-available/elb_web.conf
    - watch:
      - file: /etc/nginx/sites-available/elb_web.conf
    - mode: 644

nginx.reload.elb_web:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/sites-enabled/elb_web.conf