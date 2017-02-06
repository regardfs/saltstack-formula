# by now it is only for ubuntu

kibana_repo:
  pkgrepo.managed:
    - humanname: kibana repo
    - name: deb http://packages.elastic.co/kibana/4.5/debian stable main
    - file: /etc/apt/sources.list.d/kibana.list
    - keyserver: keyserver.ubuntu.com