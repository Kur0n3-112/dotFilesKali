ç#!/bin/bash

read -p '[?]Introduce el programa para ver si esta disponible: ' nombre

apt search $nombre | grep -n $nombre -A 1

echo "\n[?]Introduce si quieres buscar alguna funcion especifica del programa $nombre:"
read -p funcion

echo ("----------------------------------------")

apt search $nombre | grep -n $funcion -B 1

