base:
  '*':
    - common.common_pkgs
    - common.common_systemcfg
  'ecom-1':
    - gitlab.gitlab
  'vm-01':
    - elasticsearch.elasticsearch
    - nginx.nginx
    - kibana.kibana
    - logstash.logstash
    - python.python