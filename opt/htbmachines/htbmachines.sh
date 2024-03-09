#!/bin/bash

# Utilidad para filtrar maquinas por dificultad, nombre, ip, skills y sistema operativo
# Ultimo en editar: Kur

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c() {
	echo -e "\n\n${redColour}[!]Saliendo...\n${endColour}"
	tput cnorm && exit 1
	exit 1
}

#Ctrl+C
trap ctrl_c INT

#Varibales globales
main_url="https://htbmachines.github.io/bundle.js"
url_page="https://htbmachines.github.io/"

function helpPanel() {
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso: ${endColour}"
	echo -e "\t${purpleColour}u)${endColour} ${grayColour}Descarga o actualiza los archivos necesarios para funcionar${endColour}"
	echo -e "\t${purpleColour}m)${endColour} ${grayColour}Buscar por un nombre de maquina${endColour}"
	echo -e "\t${purpleColour}i)${endColour} ${grayColour}Buscar por direccion IP${endColour}"
	echo -e "\t${purpleColour}d)${endColour} ${grayColour}Buscar por dificultad de la maquina(Fácil, Media, Difícil o Insane)${endColour}"
	echo -e "\t${purpleColour}o)${endColour} ${grayColour}Buscar por sistema operativo${endColour}"
	echo -e "\t${purpleColour}s)${endColour} ${grayColour}Buscar por skill${endColour}"
	echo -e "\t${purpleColour}y)${endColour} ${grayColour}Obtener link de la resolucion de la maquina en Youtube${endColour}"
	echo -e "\t${purpleColour}l)${endColour} ${grayColour}Mostar link de la pagina de las maquinas${endColour}"
	echo -e "\t${purpleColour}h)${endColour} ${grayColour}Mostrar este panel de ayuda\n${endColour}"
}

function updateFiles() {
	if [ ! -f bundle.js ]; then
		tput civis #esconde el cursor
		echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Descargando archivos necesarios...${endColour}"
		curl -s $main_url >bundle.js
		js-beautify bundle.js | sponge bundle.js
		echo -e "\n${greenColour}[+]${endColour} ${grayColour}Todos los archivos se han descargado${endColour}"
		tput cnorm #muestra el cursor
	else
		tput civis
		echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comprobando si hay actualizaciones pendientes..."${endColour}
		curl -s $main_url >bundle_temp.js
		js-beautify bundle_temp.js | sponge bundle_temp.js
		md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
		md5_original_value=$(md5sum bundle.js | awk '{printf $1}')

		if [ "$md5_temp_value" == "$md5_original_value" ]; then
			echo -e "\n${greenColour}[+]${endColour} ${grayColour}No hay actualizaciones lo tienes todo up to date ;3"${endColour}
			rm bundle_temp.js
		else
			echo -e "\n${blueColour}[+]${endColour} ${grayColour}Hay actualizaciones, por lo tanto se va a proceder a actualizar el archivo bundle.js"${endColour}
			sleep 2
			rm bundle.js && mv bundle_temp.js bundle.js
			echo -e "\n${greenColour}[+]${endColour}  ${grayColour}Los archivos se han actualizado de forma correcta"${endColour}
		fi

		tput cnorm
	fi
}

function searchMachine() {
	machineName="$1"

	machineName_checker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d "," | sed 's/^ *//')"

	if [ "$machineName_checker" ]; then
		echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listando las propiedades de la maquina${endColour} ${blueColour}$machineName${endColour}${grayColour}:${endColour}"

		cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d "," | sed 's/^ *//'

	else
		echo -e "\n${redColour}[x] La maquina indicada no existe${endColour}"
	fi

}

function searchIP() {
	ipAddress="$1"

	machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{printf $NF}' | tr -d '"' | tr -d ',')"

	if [ "$machineName" ]; then
		echo -e "\n${greenColour}[+]${endColour} ${grayColour}La maquina correspondiente para la IP $ipAddress es $machineName${endColour}"
	else
		echo -e "\n${redColour}[x]La IP no existe${endColour}"
	fi
	#searchMachine $machineName
}

function getYoutubeLink() {
	machineName="$1"

	getYoutubeLink="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF{print $NF}')"

	if [ "$getYoutubeLink" ]; then
		echo -e "\n${greenColour}[+]${endColour} ${grayColour}El link de youtube de la maquina $machineName es $getYoutubeLink${endColour}"
	else
		echo -e "\n${redColour}[x] No existe tutorial de youtube para esta maquina${endColour}"
	fi
}

function searhDificultMachines() {
	dificultyName="$1"

	getDificultyMachine="$(cat bundle.js | grep "dificultad: \"$dificultyName\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

	if [ "$getDificultyMachine" ]; then
		echo -e "\n${greenColour}[x]${endColour} ${grayColour}Estas son las maquinas encontradas con la dificultad $dificultyName:${endColour}\n$getDificultyMachine"
	else
		echo -e "\n${redColour}[x]${endColour} ${grayColour}No existe dicha dificultad${endColour}"
	fi
}

function searchOSMachines() {
	os="$1"

	getOSMachines="$(cat bundle.js | grep "so: \"$os\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

	if [ "$getOSMachines" ]; then
		echo -e "\n${greenColour}[x]${endColour} ${grayColour}Estas son las maquinas con el sistema operativo $os: ${endColour}\n$getOSMachines"
	else
		echo -e "\n${redColour}[x]${endColour} ${grayColour}No existe dicho sistema operativo o alguna maquina con este${endColour}"
	fi
}

function getOSDifficultyMachines() {
	difficulty="$1"
	os="$2"

	sortOSandDifficultyMachines="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

	if [ "$sortOSandDifficultyMachines" ]; then
		echo -e "\n${greenColour}[+]${endColour} ${grayColour}Las maquinas con sistema operativo $os y dificultad $difficulty son las siguientes:${endColour}\n$sortOSandDifficultyMachines"
	else
		echo -e "\n${redColour}[+]${endColour} ${grayColour}No existen maquinas con los filtros seleccionados${endColour} $os $difficulty"
	fi
}

function searchSkill() {
	skillName="$1"

	sortSkill="$(cat bundle.js | grep "skills:" -B 6 | grep $skillName -i -B 6 | grep name | awk 'NF{print $NF}' | tr -d '""' | tr -d ',' | column)"

	if [ "$sortSkill" ]; then
		echo -e "\n${greenColour}[+]${endColour} ${grayColour}Estas son las maquinas con la skill $skillName:${endColour}\n $sortSkill"
	else
		echo -e "\n${redColour}[+]${endColour} ${grayColour}No existe esa skill${endColour}"
	fi
}

function showLink() {
	echo -e "\n${purpleColour}Este es el link de la pagina de las maquinas de S4vitar${endColour}$url_page"
}

# Indicadores
declare -i parameter_counter=0

#Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0

while getopts "m:ui:y:d:o:s:l:h" arg; do
	case $arg in
	m)
		machineName="$OPTARG"
		let parameter_counter+=1
		;;
	u)
		let parameter_counter+=2
		;;
	i)
		ipAddress="$OPTARG"
		let parameter_counter+=3
		;;
	y)
		machineName="$OPTARG"
		let parameter_counter+=4
		;;
	d)
		dificultyName="$OPTARG"
		chivato_difficulty=1
		let parameter_counter+=5
		;;
	o)
		os="$OPTARG"
		chivato_os=1
		let parameter_counter+=6
		;;
	s)
		skillName="$OPTARG"
		let parameter_counter+=7
		;;
	l)
		showLink
		;;
	h) ;;
	esac
done

if [ $parameter_counter -eq 1 ]; then
	searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
	updateFiles
elif [ $parameter_counter -eq 3 ]; then
	searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then
	getYoutubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
	searhDificultMachines $dificultyName
elif [ $parameter_counter -eq 6 ]; then
	searchOSMachines $os
elif [ $parameter_counter -eq 7 ]; then
	searchSkill "$skillName"
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
	getOSDifficultyMachines $dificultyName $os
else
	helpPanel
fi
