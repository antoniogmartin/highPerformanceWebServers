#!/bin/bash 

	iptables -F
	iptables -X
	iptables -Z
	iptables -t nat -F

	iptables -P INPUT ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -P FORWARD ACCEPT
