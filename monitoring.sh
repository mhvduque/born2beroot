#!/bin/bash

arq=$(uname -a)
ncpu=$(grep physical /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

fram=$(free -m | awk 'NR == 2{print $4"Mb"}')
uram=$(free -m | awk 'NR == 2{print $3}')
pram=$(free -m | awk 'NR == 2{printf("%.2f"), $3/$4*100}')

fdisk=$(df -Bg | awk '/^\/dev/{fd+=$4}END{print fd"G"}')
udisk=$(df -Bg | awk '/^\/dev/{ud+=$3}END{print ud"G"}')
pdisk=$(df -Bg | awk '/^\/dev/{fd+=$4}{ud+=$3}END{printf("%dG"), ud/fd*100}')

cpul=$(top -bn1 | grep '^%Cpu' | cut -d: -f2 | xargs | awk '{printf("%.1f%%"), $1 + $3}')
ureinicio=$(who -b | awk '{print $4 " " $5}')

lvms=$(lsblk | grep lvm | wc -l | tr -d '\n')
lvme=$(if [ "$lvms" -ne "0" ]; then echo YES ; else echo NO; fi)

ctcp=$(cat /proc/net/sockstat | awk '/TCP:/{print $3}')
ulogged=$(users | wc -l)

dip=$(hostname -I)
MAC=$(ifconfig | grep ether | awk '{print $2}')
sudocdm=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	#Arquitectura: $arq
	#Nucleos físicos CPU: $ncpu
	#Nucleos lógicos CPU: $vcpu
	#RAM: $uram/$fram	($pram%)
	#Memoria disco: $udisk/$fdisk	($pdisk%)
	#Uso de nucleos: $cpul
	#Último reinicio: $ureinicio
	#Uso de LVM: $lvme
	#Conexiones establecidas: $ctcp
	#Usuarios contectados: $ulogged
	#Network: IP $dip     ($MAC)
	#CMD sudo: $sudocdm "