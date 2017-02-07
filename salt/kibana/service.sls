kibana_service:
  cmd.run:
    - name: "sudo update-rc.d kibana defaults 96 9"
    - require:
      - file: /opt/kibana/config/kibana.yml
  service.running:
    - name: kibana
    - enable: True
    - watch:
      - file: /opt/kibana/config/kibana.yml
    - require:
      - cmd: kibana_service