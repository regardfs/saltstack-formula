{% set python = salt['pillar.get']('python', {}) %}

{% for vuser, vuserinfor in python.vitrualenv_users.iteritems() %}

profile_python_path:
  file.append:
    - name: {{ vuserinfor.profile }}
    - text:
      - PYTHONPATH={{ python.installdir }}/bin
      - PATH=$PYTHONPATH:$PATH
    - unless: "test \"{{ python.installdir }}/bin\" -eq `su - {{vuser}} -c \"echo $PYTHONPATH\"`"

{{ vuser }}-venv:
  cmd.run:
    - name: pyvenv {{ vuserinfor.venv_name }}
    - onlyif: 'test 0 -eq `source {{ vuserinfor.venv_name }}/bin/activate|echo $?`'
    - require:
      - file: profile_python_path
    - runas: {{ python.user }}

{{ vuserinfor.profile }}:
  file.append:
    - text:
      - source  {{ vuserinfor.venv_name }}/bin/activate
    - require:
      - cmd: {{ vuser }}-venv
    - watch:
      - cmd: {{ vuser }}-venv
{% endfor %}