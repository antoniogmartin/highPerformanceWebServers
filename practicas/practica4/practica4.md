

### Paso1: Generar e instalar un certificado autofirmado

**1.1 activar ssl en apache:**

`a2enmod ssl`


**1.2 Generar los certificados**

```openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout
/etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt
```

[foto]


**1.4Editamos el archivo de configuración del sitio**


default-ssl:`nano /etc/apache2/sites-available/default-ssl`

**1.5 Agregamos estas lineas debajo de donde pone SSLEngine on:**
```
SSLCertificateFile /etc/apache2/ssl/apache.crt
SSLCertificateKeyFile /etc/apache2/ssl/apache.key
```

**1.6 Activamos el sitio default--ssl y reiniciamos apache:**
```
	a2ensite default-ssl
	service apache2 reload
```
**1.7 Configuramos el archivo de opción de nginx en :**
`/etc/nginx/sites-availables/default`


y añadimos

```
server{
	listen 80;
	listen 443 ssl;
	ssl on;
	ssl_certificate <directorio_archivo.crt>
	ssl_certificate_key <directorio_archivo.key>
	...
	...
}
```


Visualización desde el navegador del certificado:
[foto]
### Paso 2: Configuración cortafuegos

**2.1 Creación del script iptable**

```

#!/bin/bash

#0)Borramos cualquier configuración anterior.
	 iptables -F
	 iptables -X
	 iptables -Z
	 iptables -t nat -F
#A) Vamos a denegar inicialmente todo el tráfico

	iptables -P INPUT DROP
	iptables -P OUTPUT DROP

#B) Permitir cualquier acceso desde localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#C)Aceptar HTTP/HTTPS

iptables -A INPUT  -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT  -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT

#D) Acceptar ssh
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

```

Para guardar la configuración cada vez que reiniciemos vamos a instalar el paquete iptables-persistent
```
	 sudo apt-get update
   sudo apt-get upgrade
```

Al instalar el paquete nos preguntará si queremos guardar la configuración actual, decimos que sí
  ` sudo apt-get install iptables-persistent`


 Si en algún momento queremos cambiar la configuración del cortafuegos y que se aplique en cada reinicio debemos ejecutar:
	`dpkg-reconfigure iptables-persistent`



**2.2 Creamos un tarea cron para usuario root y así realizar el proceso en cada inicio de la máquina**

Primeramente especificar archivo con formato crontab que contiene la lista de trabajos para cron `$crontab <file>`

Editar archivo crontab : `$crontab -e`

Escribir en el: `@reboot /usr/bin/iptables-conf.sh`



### 3 Parte opcional configuración de iptables en otra máquina y redirigir el tráfico

Script de configuración iptables:

```
#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward #activar variable en el kernel
#0)Borramos cualquier configuración anterior.
	 iptables -F
	 iptables -X
	 iptables -Z
	 iptables -t nat -F
#A) Vamos a denegar inicialmente todo el tráfico

	iptables -P INPUT DROP
	iptables -P OUTPUT DROP





#B) Permitir cualquier acceso desde localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#C)Aceptar HTTP/HTTPS
iptables -A INPUT  -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
iptables -A INPUT  -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT

#D) Acceptar ssh
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT




# Cambia la dirección de destino por 5.6.7.8
 iptables -t nat -A PREROUTING  -p tcp --dport 80 -j DNAT --to-destination 172.16.136.135:80
 iptables -t nat -A POSTROUTING -p tcp -d 172.16.136.135 --dport 80 -j SNAT --to-source 172.16.136.137

```
