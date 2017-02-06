{% from 'nginx/map.jinja' import nginx with context %}

nginx_group:
  group.present:
    - name: {{ nginx.default_group }}

nginx_user:
  user.present:
    - name: {{ nginx.default_user }}
    - home: {{ nginx.home }}
    - groups:
      - {{ nginx.default_group }}
    - require:
      - group: nginx_group
  file.directory:
    - name: {{ nginx.home }}
    - user: {{ nginx.default_user }}
    - group: {{ nginx.default_group }}
    - mode: 0755
    - require:
      - user: nginx_user
      - group: nginx_group

{{ nginx.modules_dir }}:
  file:
    - directory
    - makedirs: True

{{ nginx.dependencies_dir }}:
  file.directory:
    - user: {{ nginx.default_user }}
    - group: {{ nginx.default_group }}
    - makedirs: True

{% if grains['os_family'] == 'Debian' %}
{% for pkg in nginx.required_pkgs.Debian %}
{{ pkg }}_install:
  pkg.installed:
    - name: {{ pkg }}
{% endfor %}
{% endif %}


{% for module, moduleinfo in nginx.dependencies_modules.iteritems() %}
{{ nginx.dependencies_dir+'/'+module }}:
  file.managed:
    - source: {{ moduleinfo.url }}
    - source_hash: {{ moduleinfo.checksum }}
    - user: {{ nginx.default_user }}
    - group: {{ nginx.default_group }}
    - mode: 755
    - makedirs: true
  cmd.wait:
    - env:
      - FILE: {{ module }}
    - cwd: {{ nginx.dependencies_dir }}
    - name: tar zxvf $FILE && cd `echo "${FILE%%.tar.gz}"` && chown {{ nginx.default_user }}:{{ nginx.default_group }} . && ./config  && make && make install
    - watch:
      - file: {{ nginx.dependencies_dir+'/'+module }}
{% endfor %}

