{% set python = salt['pillar.get']('python', {}) %}

python_{{ python.version }}_file:
  file.managed:
    - name: {{ python.installfilename }}
    - source: {{ python.tarballsource }}
    - user: {{ python.user }}
    - group: {{ python.group }}
    - mode: {{ python.mode }}
    - source_hash: {{ python.checksum }}
    - makedirs: True

python_file_uncompress:
  cmd.run:
    - name: tar zxvf {{ python.installfilename }}
    - cwd: {{ python.installdir }}
    - require:
      - file: python_{{ python.version }}_file
    - runas: {{ python.user }}

install_python:
  cmd.run:
    - name: ./configure --prefix={{ python.installdir }}  && make && make install
    - cwd: {{ python.makedir }}
    - require:
      - cmd: python_file_uncompress
    - runas: {{ python.user }}