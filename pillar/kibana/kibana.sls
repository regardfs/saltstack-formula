kibana:
  users:
    kibanaadmin: '$apr1$6IBWIBmK$J2jawGxS0iCYJY253i6xs1'
  port: 8001
  host: localhost
  htpasswd_file: /etc/nginx/htpasswd.elbusers
  config: /opt/kibana/config/kibana.yml
  serverip: 172.17.8.101

