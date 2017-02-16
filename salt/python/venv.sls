{% set python = salt['pillar.get']('python', {}) %}

{% for vuser, vuserinfor in python.vitrualenv_users.iteritems() %}

{{ vuser }}-venv:
  cmd.run:
    - name: su - {{ vuser }} -c "pyvenv {{ vuserinfor.venv_name }}"
    - onlyif: 'test 0 -eq `su - {{ vuser }} -c "source {{ vuserinfor.venv_name }}/bin/activate"|echo $?`'
    - require:
      - file: pyvenv_symlink

{{ vuserinfor.profile }}:
  file.append:
    - text:
      - source  {{ vuserinfor.venv_name }}/bin/activate
    - require:
      - cmd: {{ vuser }}-venv
    - watch:
      - cmd: {{ vuser }}-venv
{% endfor %}