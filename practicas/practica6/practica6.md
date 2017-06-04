

## 1.Realizar configuración discos RAID
1.1 Creamos el disco RAID1:

`sudo mdadm -C /dev/md0 --level=raid1 --raid-devices=2 /dev/sdb /dev/sdc`

1.2 Le damos formato

`sudo mkfs /dev/md0`

1.3 creamos el directorio /dat

![crear RAID1 y crear directorio](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica6/imagenes/crear_directorio.png)

1.4 vemos los detalles de md0  

`sudo mdadm --detail /dev/md0`
![detalle md0](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica6/imagenes/detalles_md0.png)

1.5 Vemos el UUID para configurar el dispoitivo raid

  `ls -l /dev/disk/by-uuid/`
![comprobar uuid](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica6/imagenes/uuid.png)

1.6 Editamos fstab añadiendo la línea del dispositivo RAID

1.7 Reiniciamos la máquina

## 2.Simular un fallo en uno de los discos del RAID, comprobar que se puede acceder a la información y comprobar que se reconstruye correctamente.

2.1 Provocamos fallo

`sudo mdadm --manage --set-faulty /dev/md127 /dev/sdb`

![Provocar fallo](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica6/imagenes/establecer_fallo.png)

2.2 Retiramos en caliente

 `sudo mdadm --manage --remove /dev/md0 /dev/sdb`
![Retirar en caliente](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica6/imagenes/quitar_caliente.png)

2.3 Añadimos en caliente un nuevo disco:

`sudo mdadm --manage --add /dev/md0 /dev/sdb`

Detalle md127:
![detalle md127 ](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica6/imagenes/detalle_md127.png)

##  3. Configuracion servidor NFS


3.1 En la máquina donde hemos configurado el RAID instalamos nfs-server:

`sudo apt install nfs-kernel-server`

3.2 Modificamos /etc/exports y añadimos la linea :

`/home *(rw,sync,no_root_squash)`

3.3 Hacemos export del directorio

  `exportfs -a`

![exports_a](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica6/imagenes/exports_a.png)
Con el comando anterior exportaremos home.

3.4 comprobamos que  con showmount -e que está correctamente
exportado.

![showmount](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica6/imagenes/showmount.png)
3.5 Ahora iniciamos el servidor NFS.

`sudo systemctl start nfs-kernel-server.service`

3.6 En la máquina2 cliente :

3.7 Instalar nfs para el cliente.

`sudo apt install nfs-common`

3.8 Montamos el directorio de la maquina 1 en la maquina2
![montar directorio](https://github.com/antoniogmartin/highPerformanceWebServers/blob/master/practicas/practica6/imagenes/montar_directorio.png)


`sudo mount <hostname>/home /home/example`
