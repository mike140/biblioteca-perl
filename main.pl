#!/usr/bin/perl

use strict;
use warnings;
use Switch;

#esto es para importar las funciones que estan en otro archivo
use Database qw(getRegister writeFile getKeys getNextId fetchArray modif columReg);

our $user; 
my ($exit, $op) = (0); 

do{
    print "\tBIBLIOTECA\n\n";
    $op = menu( {1 => "Ingresar", 2 => "Buscar Libro", 3 => "About", 4 => "Salir"} );

    switch($op){
        case 1 {
            my $userName = readData("Ingrese nombre de usuario: ");
            my $pass = readData("Ingrese password: ");
            $user = fetchArray("login.txt", "([^,]+,){2}$userName,$pass,[^,]+,"); 

            if($user && $user->{STATUS} eq "1"){
                pause("Bienvenido $user->{nombre}!");
            }
            else{
                pause("Error, usuario o password incorrecto");
            }
        }
        
        case 2{
            #ID,name,author,year,genero,editorial,cantidad,status,sinopsis
            my $op = menu( {1 => "Por id", 2 => "Por status", 3 => "Por nombre", 4 => "genero", 5 => "Libre"} );
        }

        case 3 { pause("Informacion del sistema"); }
        
        case 4 { 
            my $ans = readData("Seguro que deseas salir? y/n\nR: ");
            $exit = 1 if ($ans eq "y");
        }
    }
    system("cls");
}while(!$exit);

sub readData{ #imprime un mensaje (shift) , pide un dato al usuario, le quita el \n y lo devuelve
	print shift; 
	chomp(my $value = <STDIN>); 
	return $value; 
}

sub pause{ #imprime un mensaje y una pausa
    print $_[0], "\n";
    system "pause";
}

sub menu{ #recibe un mapa para imprimir un menu, verifica la opcion que este bien y la devuelve
    my ($map, $message, $validInput, $op) = (shift, "", 0, 0);
    my @options = ();

    foreach (sort { $a <=> $b } keys %{$map}){
        $message .= $_ . ". " . $map->{$_} . "\n";
        push @options, $_;
    } 
    $message .= "\n\nR: ";

    do{
       print $message;
       chomp ($op = <STDIN>);

       $validInput = grep(/^$op$/, @options);
       if(!$validInput){
            pause("Porfavor, escoga una opcion del menu");
            system "cls";
       }
    }while(!$validInput);

    system "cls";
    return $op;
}

sub getTime{ #obtiene tiempo y fecha y lo devuelve como un mapa
    gmtime() =~ /(\S+) (\S+) (\S+) (\d\d:\d\d)\S+ (\S+)/;
    #Sat Feb 16 13:50:45 2013
    return ( day => $1, month => $2, daynumber => $3, hour => $4, year => $5);
}

sub printMap{ #recorre un mapa y lo imprime
    my $map = shift;

    foreach (sort keys %{$map}){
        print $_, ". ", $map->{$_}, "\n";
    }
}









