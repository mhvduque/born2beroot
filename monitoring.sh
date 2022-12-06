#!/bin/bash

#arquitectura
arq=$(uname -a)
#uname--> Unix name, comando para imprimir el nombre de la máquina y otra información relevante acerca de la misma.

#Número de núcleos físicos
#/proc/cpuinfo
ncpu=$(grep physical /proc/cpuinfo |sort | uniq | wc -l)
#Número de núcleos virtuales
#/proc/cpuinfo
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)

#Memoria RAM disponible y su porcentaje de uso
#free enseña la memoria --> /proc/meminfo
fram=$(free -m | awk 'NR == 2{print $4"Mb"}')
uram=$(free -m | awk 'NR == 2{print $3}')
#porcentaje actual del uso de tus núcleos o ram
pram=$(free -m | awk 'NR == 2{printf("%.2f"), $3/$4*100}')

#Memoria DISCO y su porcentaje de uso
#df --> report file system disk space usage
fdisk=$(df -Bg | awk '/^\/dev/{fd+=$4}END{print fd"G"}')
udisk=$(df -Bg | awk '/^\/dev/{ud+=$3}END{print ud"G"}')
pdisk=$(df -Bg | awk '/^\/dev/{fd+=$4}{ud+=$3}END{printf("%dG"), ud/fd*100}')

#Porcentaje actual del uso de mis núcleos
cpul=$(top -bn1 | grep '^%Cpu' | cut -d: -f2 | xargs | awk '{printf("%.1f%%"), $1 + $3}')

#FECHA Y HORA DEL ULTIMO REINICIO
ureinicio=$(who -b | awk '{print $4 " " $5}')

#LVM (logical volume manager), admin de discos para el kernel
# 1) buscar si está en uso
lvms=$(lbslk | grep lvm | wc -l)
# 2) Expresar si está o no en uso
lvme=$(if [ "$lvms" = 0 ]; then echo YES; else echo NO; fi)

#Número de conexiones activas --> TCP
#file --> /proc/net/sockstat ... coger las conexiones TCP
ctcp=$(cat /proc/net/sockstat | awk '/TCP:/{print $3}')

#NUMERO DE USUARIOS CONECTADOS EN EL SERVER
ulogged=$(users | wc -c)

#IP y MACS
dip=$(hostname -I)
MAC=$(ip link show | awk '/link\/ether/{print $2}')

#NUMERO DE COMANDOS SUDO EJECUTADOS
sudocmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	#Arquitectura: $arq
	#Nucleos físicos CPU: $ncpu
	#Nucleos lógicos CPU: $vcpu
	#RAM: $uram/$fram  ($pram%)
	#MEMORIA DISCO: $udisk/$fdisk ($pdisk%)
	#USO DE NUCLEOS: $cpul
	#Último reinicio: $ureinicio
	#Uso de LVM: $lvme
	#Conexiones establecidas: $ctcp
	#Usuarios conectados: $ulogged
	#Network: IP $dip ($MAC)
	#CMD SUDO: $sudocmd"
#WaLl es lo que hace broadcast al resto de ususarios conectados