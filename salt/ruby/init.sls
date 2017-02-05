ruby-ppa-repo:
  pkgrepo.managed:
    - ppa: brightbox/ruby-ng

ruby:
  pkg.installed:
    - name: {{ salt['pillar.get']('ruby_version', 'ruby2.3') }}
    - required:
      - pkgrepo.managed: ruby-ppa-repo