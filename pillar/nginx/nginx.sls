nginx:
  install_from_source: True
  modules_dir: /usr/local/src/modules
  nginx_version: 1.11.9
  dependencies_dir: /usr/local/src/dependencies
  dependencies_modules:
    pcre-8.40.tar.gz:
      url: ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz
      checksum: "sha1=10384eb3d411794cc15f55b9d837d3f69e35391e"
    zlib-1.2.11.tar.gz:
      url: http://zlib.net/zlib-1.2.11.tar.gz
      checksum: "sha1=e6d119755acdf9104d7ba236b1242696940ed6dd"
  required_pkgs:
    Debian:
      - openssl
      - libssl-dev
      - libperl-dev
      - gcc
      - g++
