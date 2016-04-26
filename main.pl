#!/usr/bin/perl

sub readData; # se avisa al programa que mas adelante se declara esta función

use strict;
use warnings;

open LOGIN, "< login.txt" or die "No pudo realizarse la conexion con la Base de Datos: $!\n";
#se abre el archivo con los nombres de usuario y contraseñas

our %user; # hash que contendra todos los datos importantes del usuario
my $registrado; #boleano para saber si el nombre de usuario esta registrado
my $acceso; #boleano para ver si puede acceder, osea si la contraseña es correcta
my @users = <LOGIN>; #se leen todas las lineas del archivo de usuarios y se guardan en un arreglo

do{
    $registrado = 0; #como se van a pedir los datos registrado es falso
	$user{name}= readData("\n\n\tBIBLIOTECA\nIngrese nombre de Usuario: ");
	$user{pass} = readData("\nIngrese password: ");
	system("cls"); 

	for (@users){ #se recorre el arreglo de lineas del archivo buscando el nombre del usuario
		if(/(.*),$user{name},(.*)/){ #expr regular que busca el nombre de usuario $1 = tipo,  $2 = password
			$registrado = 1; 
			$acceso = $user{pass} eq $2; #se compara la contraseña dada por el usuario con la que está en el archivo ($2)
			$user{type} = $1; #el tipo del usuario se guarda en $1
			print( ("Pass incorrecto", "Bienvenido al sistema", )[$acceso] );
			last; #se sale del for
		}
	}

	if(!$registrado){
		print "El usuario proporcionado no esta registrado";
	}
}while(!$acceso);

system "cls";
print "\nBienvenido!\nEl tipo de usuario es $user{type}";

sub readData{
	print $_[0]; #imprime el argumento dado a la función
	my $value = <STDIN>;  #lee una linea del usuario
	chomp $value; #le quita el \n
	return $value; 
}







