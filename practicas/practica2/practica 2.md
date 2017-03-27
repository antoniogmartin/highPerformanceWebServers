# Práctica 2


### 1. Clonar carpeta con rsync de la maquina 1 a la 2.  

	Previamente : `chown -R usuario:usuario /var/www/`

    1. Antes de nada debemos editar el archivo /etc/ssh/sshd_config
	En este archivo deberemos cambiar la linea a:
	 **PermitRootLogin yes**  

    2. Ahora podremos ejecutar la orden  

`rsync -avz -e ssh /var/www/root@<ip_maquina1>:/var/www/` Envía archivos y carpetas de la maquina actual a la otra
![Test rsync](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica2/images/test-rsync.png)

### 2. Acceso sin contraseña ssh
    1. generamos la clave con la orden $ssh-keygen -t dsa
    2. Hacemos copia de la clave existente de la maquina2 a la maquina1 con:
    	ssh-copy-id -i .ssh/id_dsa.pub root@<ip_maquina1>
    3. Accedemos al usuario root de maquina 1
		ssh root@<ip_maquina1>
    4. Ejecutando ordenes en máquina1 desde máquina2
		ssh <ip_maquina1> -l root uname -a
		
![generar clave](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica2/images/generacion-clave.png)
![Añadir clave](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica2/images/add-clave.png)
![Entrar sin clave](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica2/images/entrar-sin-clave.png)

### 3. Tareas crontrab  

    1. Primeramente especificar archivo con formato crontab que contiene la lista de trabajos para cron
		`$crontab <file>`
    2. editar archivo crontab : $crontab -e
	Escribir en el: 00 * * * * /usr/bin/rsync -avz ssh  /var/www/ root@<ip_maquina1>:/var/www/
    3. Al listar con crontab -l veremos la lista actual de trabajos
