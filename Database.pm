#!/usr/bin/perl

package Database;

use warnings;
use strict;
use Exporter qw(import);
 
our @EXPORT_OK = qw(getRegister writeFile getKeys getNextId fetchArray modif columReg);

sub getRegister{ # void gerRegister(string nombreTabla) pide los datos de un registro y los agrega al final del archivo
	my $tableName = shift;
	my %map;

	for ( getKeys($tableName) ){
		next if (/ID|STATUS/);
		print $_, ": ";
		chomp ($map{$_} = <STDIN>);
	}

	$map{ID} = getNextId($tableName);
	$map{STATUS} = 1; 
	writeFile(\%map, $tableName);
}

sub getNextId{ #int getNextId(string nombreTabla) devuelve el siguiente ID para el proximo registro
	open FH, "< " . shift or return 0;
	<FH>;

	my $count = 0;
	while(<FH>){
		$count++;
	}
	close FH;
	return $count;
}

sub writeFile{ #int writeFile(%map, string filename) escribe un registro al final de un archivo (filename)
	my ($map, $filename) = (shift, shift);
	open FH, ">> " . $filename or return 0;

	for (sort keys %{$map}){
		print FH $map->{$_}, ",";
	}
	print FH "\n";
	close FH;
	return 1;
}

sub getKeys{ #@arreglo getKeys(string tablename) devuelve los nombres de las columnas de una tabla
	open FH, "< " . shift or return undef;
	chomp (my $line = <FH>);
	close FH;

	my @values = $line =~ /([^,]+),/g;
}

sub fetchArray{ #@arreglo o %mapa fetchArray(tableName, expresionRegular) devuelve todos los registros que concuerdan
	#con una expresion regular, si se iguala a un escalar, devuelve solo la primer coincidencia como un mapa
	my (@matches, %hash) = ();
	my ($tableName, $regex) = (shift, shift);
	my @keys = getKeys($tableName);
	open FH, "< " . $tableName or return undef;

	<FH>;
	while(<FH>){
		next if $_ !~ /$regex/;
		@hash{@keys} = /([^,]+),/g;
		push @matches, { %hash };
	}

	close FH; 
	if (wantarray){
		return @matches;
	}
	return $matches[0];
}

sub modif{ #int modif(nombreTAbla, mapaModificado)  retorna exito o fracaso
#void modif(tableName, mapaCambiado) hace modificaciones, reemplaza el registro que tiene el mismo id con el mapa
	my ($tableName, $hash) = (shift, shift);
	open FH, "< " . $tableName or return 0;
	open COPY, "> temp.txt" or return 0;

	while(<FH>){
		if(/^$hash->{ID}/){
			foreach my $key (sort keys %{$hash}){
				print COPY $hash->{$key}, ","; 
			}
			print COPY "\n";
		}
		else{
			print COPY $_;
		}
	}

	close FH;
	close COPY;
	unlink $tableName;
	rename "temp.txt", $tableName;
	return 1;	
}

sub columReg{ #string columReg(tabla, columna, valor)
#devuelve un string con una expresion regular para obtener un registro con un determinado valor en una columna
	my ($tableName, $colum, $value, $reg) = (shift, shift, shift, "");

	foreach ( getKeys($tableName) ){
		if (/$colum/){
			$reg .= "$value,.*";
			last;
		}
		else{
			$reg .= "[^,]+,";
		}
	}
	return $reg;
}



