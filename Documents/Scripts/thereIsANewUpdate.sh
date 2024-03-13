#!/bin/bash

# Lista los paquetes actualizables
updates=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l)

# Imprime el número de actualizaciones disponibles
echo " %{F#ffffff}$updates"
