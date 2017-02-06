{% from 'elasticsearch/map.jinja' import elasticsearch with context %}

{% set major_version = elasticsearch['major_version'] %}
{%- if major_version == 5 %}
{%- set repo_url = elasticsearch['repo_url_5'] %}
{%- else %}
{%- set repo_url = elasticsearch['repo_url_2'] %}
{%- endif %}

{%- if major_version == 5 and grains['os_family'] == 'Debian' %}
apt-transport-https:
  pkg.installed
{%- endif %}

elasticsearch_repo:
  pkgrepo.managed:
    - humanname: Elasticsearch {{ major_version }}
{%- if grains.get('os_family') == 'Debian' %}
    - name: deb {{ repo_url }} stable main
    - dist: stable
    - file: /etc/apt/sources.list.d/elasticsearch_{{ major_version }}.list
    - keyid: D88E42B4
    - keyserver: keyserver.ubuntu.com
    - clean_file: true
{%- elif grains['os_family'] == 'RedHat' %}
    - name: elasticsearch
    - baseurl: {{ repo_url }}
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: http://artifacts.elastic.co/GPG-KEY-elasticsearch
{%- endif %}
