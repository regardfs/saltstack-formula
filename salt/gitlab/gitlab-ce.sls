{% set gitlab_install_shell = salt['pillar.get']('gitlab_install_shell') %}
gitlab-repo:
  cmd.run:
    - name: "curl -sS {{ gitlab_install_shell }}| sudo bash"
    - cwd: /tmp

gitlab-ce-install:
  pkg.installed:
    - name: gitlab-ce
    - require:
      - cmd: gitlab-repo
      - pkg: ruby

gitlab-ce-config:
  cmd.run:
    - name: gitlab-ctl reconfigure
    - require:
      - pkg: 'gitlab-ce-install'