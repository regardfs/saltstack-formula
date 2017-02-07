{% from 'nginx/map.jinja' import nginx with context %}


{% if grains['os_family'] == 'Debian' %}
{% for pkg in nginx.required_pkgs.Debian %}
{{ pkg }}_install:
  pkg.installed:
    - name: {{ pkg }}
    - hold: true
    - refresh: True
{% endfor %}
{% endif %}

install-libgd3:
  pkg.installed:
    - name: libgd3
    - version: {{ nginx.libgd3_version }}
    - hold: True

nginx-repo:
  pkgrepo:
    - absent
    - humanname: Nginx official package repository
    - name: deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx
    - dist: trusty
    - file: /etc/apt/sources.list.d/nginx-repo.list

nginx-ppa-repo:
  pkgrepo:
    - managed
    - humanname: nginx-ppa-{{ grains['oscodename'] }}
    - name: deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main
    - file: /etc/apt/sources.list.d/nginx-stable-trusty.list
    - dist: trusty
    - keyid: C300EE8C
    - keyserver: keyserver.ubuntu.com


nginx-common:
  pkg.installed:
    - sources:
      - nginx-common: https://launchpad.net/~teward/+archive/ubuntu/nginx-1.8/+files/nginx-common_1.8.1-1+trusty0_all.deb
    - hold: true

nginx:
  pkg.installed:
    - sources:
      - nginx-full: https://launchpad.net/~teward/+archive/ubuntu/nginx-1.8/+files/nginx-full_1.8.1-1+trusty0_amd64.deb
    - skip_verfy: True
    - refresh: True
    - hold: True
    - require:
      - pkg: install-libgd3
      - pkg: nginx-common
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/nginx.conf

remove-default:
  file.absent:
    - name : /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx

