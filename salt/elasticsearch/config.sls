{% from 'elasticsearch/map.jinja' import elasticsearch with context %}


{%- if elasticsearch.configs != None %}
{% set nodeconfigs = elasticsearch.configs %}
{% for node, nodeinfo in nodeconfigs.iteritems() %}
{% if node == grains['id'] %}
elasticsearch_cfg:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - user: root
    - source:
      - salt://elasticsearch/files/elasticsearch.yml
    - template: jinja
    - owner: elasticsearch
    - group: elasticsearch
    - mode: 644
    - context:
      nodeinfo: {{ nodeinfo }}


{% set data_dir = nodeinfo['path.data'] %}
{% set log_dir = nodeinfo['path.logs'] %}

{% for dir in (data_dir, log_dir) %}
{% if dir %}
{{ dir }}:
  file.directory:
    - user: {{ elasticsearch.user }}
    - group: {{ elasticsearch.group }}
    - mode: 0700
    - makedirs: True
{% endif %}
{% endfor %}

{% endif %}
{% endfor %}
{% endif %}

{% if salt['pillar.get']('elasticsearch:elasticsearch_in_sh') != None %}
ES_MIN_MEM_set:
  file.replace:
    - name: /usr/share/elasticsearch/bin/elasticsearch.in.sh
    - pattern:    ES_MIN_MEM=256m
    - repl:     ES_MIN_MEM=1g

ES_MAX_MEM_set:
  file.replace:
    - name: /usr/share/elasticsearch/bin/elasticsearch.in.sh
    - pattern:     ES_MAX_MEM=1g
    - repl:     ES_MAX_MEM=2g
{% endif %}

/etc/security/limits.conf:
  file.append:
    - text:
      - elasticsearch soft memlock unlimited
      - elasticsearch hard memlock unlimited
      - elasticsearch soft nofile 204800
      - elasticsearch hard nofile 204800