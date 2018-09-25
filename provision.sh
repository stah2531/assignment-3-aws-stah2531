#!/bin/bash

# assign variables
ACTION=${1:--i}
version=1.0.1

function initialize(){
	yum update -y
	amazon-linux-extras install nginx1.12
	chkconfig nginx on
	aws s3 cp s3://stah2531-assignment-3/index.html /usr/share/nginx/html/index.html
	service nginx start
}

function display_help(){

cat << EOF
Usage: ${0} {-h|--help|-r|--remove|-v|--version}

OPTIONS:
	no arguments	Update instance, install nginx, start nginx with new index.html
	-h | --help	Display the command help
	-r | --remove	Stop nginx, delete document directory, uninstall nginx
	-v | --version	Display script version

Examples:
	Initialize nginx with index.html file:
		$ ${0} 
	Display help:
		$ ${0} -h
	Remove nginx and associated files:
		$ ${0} -r
	Display version:
		$ ${0} -v
	
EOF
}

function remove() {
	service nginx stop
	chkconfig nginx off
	rm /usr/share/nginx/html/*
	yum remove nginx
}

function version(){
	echo $version

}

case "$ACTION" in
	-i)
		initialize
		;;
	-h|--help)
		display_help
		;;
	-r|--remove)
		remove
		;;
	-v|--version)
		version
		;;
	*)
	echo "Usage ${0} {-h|-r|-v}"
	exit 1
esac
 


