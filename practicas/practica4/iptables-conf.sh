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
