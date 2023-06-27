# CAMP LAUNCHER

####WebSocket连接的说明:
```
如果出现WebSocketException: Connection to '连接地址,#结尾,如果不指定端口号,还会显示域名:0端口号' was not upgraded to websocket
在nginx中添加如下设置:
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection 'upgrade';
```