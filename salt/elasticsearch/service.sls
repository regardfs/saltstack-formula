include:
  - elasticsearch.pkg
  - elasticsearch.config

elasticsearch_service:
  service.running:
    - name: elasticsearch
    - enable: True
{%- if salt['pillar.get']('elasticsearch:configs') %}
    - watch:
      - file: elasticsearch_cfg
{%- endif %}
    - require:
      - pkg: elasticsearch_pkg
  cmd.run:
    - name: sudo update-rc.d elasticsearch defaults 95 10
    - require:
      - pkg: elasticsearch_pkg

