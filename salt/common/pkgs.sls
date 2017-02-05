{% for pkg in pillar['common_pkgs'] %}
{{ pkg }}:
  pkg.installed
{% endfor %}