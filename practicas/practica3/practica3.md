
## Práctica 3


**Paso 1:**Configurando nginx:

Editar el archivo `/etc/nginx/sites-available/default` y poner el contenido

```
upstream apaches {
	server <ip_maquina1>; 
	server <ip_maquina2>;
}
server{
listen 80;
server_name balanceador;
access_log /var/log/nginx/balanceador.access.log; error_log /var/log/nginx/balanceador.error.log; root /var/www/;
		location / {
		proxy_pass http://apaches;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; proxy_http_version 1.1;
		proxy_set_header Connection "";
		 }
}
```

**Paso 2** Para configurar haproxy:


Primeramente debemos para el servicio nginx que está escuchando en el puerto 80

service  nginx stop
despues incluimos en el archivo:

```
global
	daemon
	maxconn 256
  
defaults
	mode http
	contimeout 4000 clitimeout 42000 srvtimeout 43000
	frontend http-in bind *:80
	default_backend servers

backend servers
server m1 <ip_maquina1>:80 maxconn 32 
server m2 <ip_maquina2>:80 maxconn 32

sudo /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg
```

**Paso 3:** Someter a una alta carga el servidor


Desde la maquina anfitriona ejecutamos el comando:

ab -n 8000 -c 10 http://<ip_balanceador>/index.html
y obtenemos el resultado:
[foto]

Es importante para ejecutar el balanceo con nginx debemos matar el proceso haproxy:
 Buscamos el pid del proceso y lo matamos
  $ps aux | grep haproxy
  $ kill -9 pid_haproxy

 Ahora ejecutamos de nuevo el benchmark:
 ab -n 8000 -c 10 http://<ip_balanceador>/index.html


**Paso 4:** Extra Pound balancer

Instalamos pound
 sudo apt-get install pound

 configuramos el archivo `/etc/pound/pound.cfg`:

 ```
ListenHTTP
Address <ip_balanceador>
Port 80
	Service
	BackEnd
	Address <ip_maquina1>
	Port    80
	End
	BackEnd
	Address <ip_maquina2>
	Port    80
	End
End
End 
```

 Reiniciamos el servicio `sudo /etc/init.d/pound restart`

 Tras esto en el navegador de nuestra máquina anfitrión tecleamos la ip  del balanceador y debería mostrarnos el archivo index.html de la máquina 1
 



