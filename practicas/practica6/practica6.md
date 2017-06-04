

## 1.Realizar configuración discos RAID
1.1 Creamos el disco RAID1:

`sudo mdadm -C /dev/md0 --level=raid1 --raid-devices=2 /dev/sdb /dev/sdc`

1.2 Le damos formato

`sudo mkfs /dev/md0`

1.3 creamos el directorio /dat

1.4 vemos los detalles de md0  

`sudo mdadm --detail /dev/md0`

1.5 Vemos el UUID para configurar el dispoitivo raid

  `ls -l /dev/disk/by-uuid/`

1.6 Editamos fstab añadiendo la línea del dispositivo RAID

1.7 Reiniciamos la máquina

## 2.Simular un fallo en uno de los discos del RAID, comprobar que se puede
acceder a la información y comprobar que se reconstruye correctamente.

2.1 Provocamos fallo

`sudo mdadm --manage --set-faulty /dev/md127 /dev/sdb`

2.2 Retiramos en caliente

 `sudo mdadm --manage --remove /dev/md0 /dev/sdb`

2.3 Añadimos en caliente un nuevo disco:

`sudo mdadm --manage --add /dev/md0 /dev/sdb`

##  3. Configuracion servidor NFS


3.1 En la máquina donde hemos configurado el RAID instalamos nfs-server:

`sudo apt install nfs-kernel-server`

3.2 Modificamos /etc/exports y añadimos la linea :

`/home *(rw,sync,no_root_squash)`

3.3 Hacemos export del directorio

  `exportfs -a`

Con el comando anterior exportaremos home.

3.4 comprobamos que  con showmount -e que está correctamente
exportado.

3.5 Ahora iniciamos el servidor NFS.

`sudo systemctl start nfs-kernel-server.service`

3.6 En la máquina2 cliente :

3.7 Instalar nfs para el cliente.

`sudo apt install nfs-common`

3.7 Montamos el directorio de la maquina 1 en la maquina2

`sudo mount <hostname>/home /home/example`
