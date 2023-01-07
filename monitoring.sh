#!/bin/bash

#arquitectura
arq=$(uname -a)
#uname--> Unix name, comando para imprimir el nombre de la máquina y otra información relevante acerca de la misma.

#Número de núcleos físicos
#/proc/cpuinfo
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
#Número de núcleos virtuales
#/proc/cpuinfo
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)

#Memoria RAM disponible y su porcentaje de uso
#free enseña la memoria --> /proc/meminfo
fram=$(free -m | grep Mem: | awk '{print $2}')
uram=$(free -m | grep Mem: | awk '{print $3}')
#porcentaje actual del uso de tus núcleos o ram
pram=$(free    | grep Mem: | awk '{printf("%.2f"), $3/$2*100}')

#Memoria DISCO y su porcentaje de uso
#df --> report file system disk space usage
fdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
pdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')

#Porcentaje actual del uso de mis núcleos
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

#FECHA Y HORA DEL ULTIMO REINICIO
ureinicio=$(who -b | awk '$1 == "system" {print $3 " " $4}')

#LVM (logical volume manager), admin de discos para el kernel
# 1) buscar si está en uso
lvms=$(lsblk -o TYPE | grep "lvm" | wc -l)
# 2) Expresar si está o no en uso
lvme=$(if [ $lvms -eq 0 ]; then echo no; else echo yes; fi)

#Número de conexiones activas --> TCP
#file --> /proc/net/sockstat ... coger las conexiones TCP
ctcp=$(cat /proc/net/tcp | wc -l | awk '{print $1-1}' | tr '' ' ')

#NUMERO DE USUARIOS CONECTADOS EN EL SERVER
ulogged=$(users | wc -w)

#IP y MACS
dip=$(hostname -I)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')

#NUMERO DE COMANDOS SUDO EJECUTADOS
sudocmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	#Architecture: $arq
	#CPU physical: $ncpu
	#vCPU: $vcpu
	#Memory Usage: $uram/${fram}MB  ($pram%)
	#Disk Usage: $udisk/${fdisk}Gb ($pdisk%)
	#CPU load: $cpul
	#Last reboot: $ureinicio
	#LVM use: $lvme
	#Connexions TCP: $ctcp ESTABLISHED
	#User log: $ulogged
	#Network: IP $dip ($MAC)
	#sudo: $sudocmd cmd"
#WaLl es lo que hace broadcast al resto de ususarios conectados
