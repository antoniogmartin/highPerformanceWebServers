## 1 Crear una BD con al menos una tabla y algunos datos.
1.1 Crear la BD y usarla:

	create database contactos;
	use contactos;

1.2 Crear tabla

`create listado_telefonico(id int(6) AUTO_INCREMENT PRIMARY KEY, NOMBRE VARCHAR(100),TLF INT);`
	
![crear tabla](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica%205/imagenes/crear_tabla.png)

1.3 Añadir datos

`insert into datos(nombre,tlf) values ("juan cipres",699875678);`

1.4 Hacer consulta

`select * from listado_telefonico`

![select tabla](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica%205/imagenes/select_tabla.png)
1.5 Describe datos

`describe listado_telefonico`
![mostrar datos](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica%205/imagenes/describe_tabla.png)

## 2 Realizar la copia de seguridad de la BD completa usando mysqldump.


2.1 Pra realizar la copia de seguridad vamos a mysql y ejecutamos:
`
mysql> FLUSH TABLES WITH READ LOCK;`

2.2 Salimos de mysql y ejecutamos:
`mysqldump <bd_ejemplo> root -p > /tmp/<bd_ejemplo>.sql`

2.3 Copiar datos BD de la maquina1 a la 2.

![copia bd](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica%205/imagenes/%20copiar_bd.png)

`scp maquina1:/tmp/<bd_ejemplo>sql /tmp/`

## 3 Restaurar dicha copia en la segunda máquina (clonado manual de la BD).


3.1 Crear en la maquina 2 la bd que vamos a restaurar
`mysql>create database contactos;`

3.2 Salir de mysql y restaurar
`mysql -u root -p ejemplodb < /tmp/ejemplodb.sql`
![restaurar copia en m2](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica%205/imagenes/restaurar_copia_m2.png)

## 4  Realizar la configuración maestro-esclavo de los servidores MySQL para que la replicación de datos se realice automáticamente.

4.1 Modificamos el documento

`/etc/mysql/mysql.conf.d/mysqld.cnf`

4.1.1 Comentamos  
	`#bind-address 127.0.0.1`

4.1.2 Añadimos las lineas

```
server-id = 1
log_error = /var/log/mysql/error.log
```

4.1.3 Descomentar : `log_bin = /var/log/mysql/bin.log`
4.1.4 Reiniciamos el servicio `/etc/init.d/mysql restart`

4.2 Realizamos en la maquina2 los pasos 4.1 al 4.1.4

4.3 En la maquina1 accedemos a mysql y  creamos un nuevo usuario
`CREATE USER esclavo IDENTIFIED BY 'esclavo';`


4.4 Le otorgamos  permiso de REPLICATION.
```
mysql> GRANT REPLICATION SLAVE ON *.* TO 'esclavo'@'%' IDENTIFIED BY 'esclavo';
mysql> FLUSH PRIVILEGES;
mysql> FLUSH TABLES;
mysql> FLUSH TABLES WITH READ LOCK;
```
4.5 Accedemos de nuevo a la maquina 2 y ejecutamos:

```
mysql> CHANGE MASTER TO MASTER_HOST='<ip_maquina1>',
MASTER_USER='esclavo', MASTER_PASSWORD='esclavo',
MASTER_LOG_FILE='<datos_bd_maquina1-bin.00000n>',
MASTER_LOG_POS=<POSITION>, MASTER_PORT=3306;
```
4.6 Iniciamos el slave:
`mysql>START SLAVE;`

4.7 Comprobamos que Seconds_Behind_Master=0
![Seconds_Behind_Master](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica%205/imagenes/seconds_slave.png)

4.8 Dado que mi maquina2 es un clon de maquina1 he tenido que eliminar el archivo **/var/lib/mysql/auto.cnf** y con touch volverlo a crear.


4.9 Al iniciar mysql de nuevo me rellena este archivo con uuid distinta y funciona correctamente la replicación

## 5 Opcional :Realizar la configuración maestro-maestro entre las dos máquinas de bases de datos.

En la maquina2:


5.1 Aprovechando el usuario que hemos creado en  4.3 maquina 1, creamos este mismo usuario en maquina2.

5.2 Le damos permisos.
`create user 'esclavo'@'%' identified by 'esclavo';`

5.3 Ejecutamos:
```
stop slave;
mysql> CHANGE MASTER TO MASTER_HOST='<ip_maquina1>',
MASTER_USER='esclavo', MASTER_PASSWORD='esclavo',
MASTER_LOG_FILE='<datos_bd_maquina1-bin.00000n>',
MASTER_LOG_POS=<POSITION>, MASTER_PORT=3306;
```
5.3 escribimos : `mysql>show master status`
![estado master](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica%205/imagenes/master_bd_data.png)
En la máquina1

5.4 `MYSQL> stop slave;`

5.5 Ejecutamos
```
mysql> CHANGE MASTER TO MASTER_HOST='<ip_maquina1>',
MASTER_USER='esclavo', MASTER_PASSWORD='esclavo',
MASTER_LOG_FILE='<datos_bd_maquina1-bin.00000n>',
MASTER_LOG_POS=<POSITION>, MASTER_PORT=3306;
```
![de master a master](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica%205/imagenes/mater_to_master.png)
Ya tenemos una relación master - master.
