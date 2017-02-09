elasticsearch:
  major_version: 2
  java_home: /usr/bin/java
  user: elasticsearch
  group: elasticsearch
  configs:
    vm-01:
      cluster.name: my-app
      node.name: "vm-01"
      node.master: 'true'
      node.data: 'true'
      index.number_of_shards: 1
      index.number_of_replicas: 0
      bootstrap.mlockall: 'true'
      network.host: 172.17.8.101
      gateway.recover_after_nodes: 1
      gateway.recover_after_time: 10m
      gateway.expected_nodes: 1
      action.disable_close_all_indices: 'true'
      action.disable_delete_all_indices: 'true'
      action.disable_shutdown: 'true'
      indices.recovery.max_bytes_per_sec: 100mb
      path.data: '/srv/data'
      path.logs: '/srv/logs'
  sysconfig:
    ES_STARTUP_SLEEP_TIME: 5
    ES_HEAP_SIZE: 2g
    MAX_OPEN_FILES: 65536
  plugins:
    lang-python: lang-python
    kopf: lmenezes/elasticsearch-kopf