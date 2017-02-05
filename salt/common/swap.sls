/root/incre_swap.sh:
  file.managed:
    - source: salt://system/file/incre_swap.sh
    - user: root
    - group: root
    - mode: 744
    - template: jinja

swapspwace:
  cmd.run:
    - name: /root/incre_swap.sh
    - require:
      - file: /root/incre_swap.sh