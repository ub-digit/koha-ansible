<VirtualHost *:8080>
  ProxyPreserveHost Off

  ErrorLog /var/log/koha/{{ koha_instance_name }}/mailhog-proxy-error.log
  CustomLog /var/log/koha/{{ koha_instance_name }}/mailhog-proxy-access.log combined

  LogLevel warn

  ProxyPass /api/v2/websocket ws://127.0.0.1:8025/api/v2/websocket
  ProxyPassReverse /api/v2/websocket ws://127.0.0.1:8025/api/v2/websocket

  ProxyPass / http://127.0.0.1:8025/
  ProxyPassReverse / http://127.0.0.1:8025/

  <Proxy *>
    Order deny,allow
    Allow from all
    AuthType Basic
    AuthName "Password required"
    AuthUserFile "{{ mailhog_htpasswd_filepath }}"
    Require valid-user
  </Proxy>

</VirtualHost>
