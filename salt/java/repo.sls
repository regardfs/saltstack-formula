# http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
# http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jre-8u121-linux-x64.tar.gz

{% set java_version = salt['pillar.get']('java_version', '8') %}

oracle-java{{ java_version }}-installer:
  {% if grains['os'] == 'Ubuntu' %}
  pkgrepo.managed:
    - ppa: webupd8team/java
  {% elif grains['os'] == 'Debian' %}
  pkgrepo.managed:
    - humanname: WebUp8Team Java Repository
    - name: "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trust main"
    - dist: trust
    - file: /etc/apt/sources.list.d/webup8team.list
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com
  {% endif %}
  pkg.installed:
    - require:
      - pkgrepo: oracle-java{{ java_version }}-installer
  debconf.set:
   - data:
       'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True}
   - require_in:
       - pkg: oracle-java{{ java_version }}-installer