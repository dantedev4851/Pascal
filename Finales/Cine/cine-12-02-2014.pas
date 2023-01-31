program final_cine;
uses crt;
const
    MAXIMO = 3;
    MAXIMO_FILAS = 'C';
    MAXIMO_COLUMNAS = 5;
type
    regSala = record
            nroSala:integer;
            pelicula:string[30];
            lugares:array ['A'..MAXIMO_FILAS,1..MAXIMO_COLUMNAS,1..5] of char;
        end;
var
    FCine:file of regSala;
    sala:regSala;
function buscarPelicula(dato:string):integer;
begin
    buscarPelicula := -1;
    seek(Fcine , 0);

    repeat
        read(Fcine , sala);
    until ((sala.pelicula = dato) or (eof(FCine)));    

    if(sala.pelicula = dato)then
        begin
            buscarPelicula := filepos(FCine) - 1;
        end;
end;
function validarNumero(min:integer;max:integer;numero:integer):integer;
begin
    case numero of
        1: begin
                repeat
                    clrscr();
                    write('Turno:');
                    readln(validarNumero);
                until((validarNumero >= min) and (validarNumero <= max));    
        end;
        2: begin
                repeat
                    clrscr();
                    write('Butaca numero:');
                    readln(validarNumero);
                until((validarNumero >= min) and (validarNumero <= max)); 
        end;
    end;
end;
function validarTecla(valor1:char;valor2:char):char;
begin
    repeat
        clrscr();
        write('Fila:');
        readln(validarTecla);
    until ((validarTecla >= valor1) or (validarTecla <= valor2));
end;
function entradasDisponibles(pos:integer;cantidad:integer;t:integer):boolean;
var
    fila:char;
    columna:integer;
    lugaresLibres:integer;
begin
    seek(FCine , pos);
    read(FCine , sala);

    entradasDisponibles := true;
    lugaresLibres := 0;
    
    for fila := 'A' to MAXIMO_FILAS do
        begin
            for columna := 1 to MAXIMO_COLUMNAS do
                begin
                    if(sala.lugares[fila,columna,t] = 'L')then
                        begin
                            inc(lugaresLibres);
                        end;
                end;
        end;

    if(lugaresLibres < cantidad)then
        begin
            entradasDisponibles := false;
        end
end;
procedure asignar();
begin
    assign(FCine , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Cine\cine.dat');
end;
procedure abrirArchivo();
begin
    {$I-} reset(FCine); {$I+}    
    if(ioresult = 2)then  // file not found -> archivo no encontrado
        begin
            rewrite(FCine);
        end;
end;
procedure cerrarArchivo();
begin
    close(FCine);
end;
procedure cargarPelicula();
var
    posicion:integer;
    tecla:char;
    pelicula:string[30];
begin
    tecla := 'c';

    while((tecla = 'c') and (filesize(FCine) <> MAXIMO))do
        begin
            clrscr();

            write('Nombre de pelicula:');
            readln(pelicula);
            
            if(filesize(FCine) = 0)then
                begin
                    sala.nroSala := filesize(FCine) + 1;
                    sala.pelicula := pelicula;

                    seek(Fcine , filesize(FCine));
                    write(FCine , sala);
                end
            else
                begin
                    posicion := buscarPelicula(pelicula);
                    clrscr();
                    if(posicion = -1)then
                        begin
                            sala.nroSala := filesize(FCine) + 1;
                            sala.pelicula := pelicula;

                            seek(Fcine , filesize(FCine));
                            write(FCine , sala);
                        end
                    else
                        begin
                            write('Ya se encuentra cargada esta pelicula');
                            readkey();
                            clrscr();
                        end;
                end;
            
            write('Desea continuar o finalizar (c-f):');
            tecla := readkey();
        end;
    
    if(filesize(FCine) = MAXIMO)then
        begin
            clrscr();
            write('Se llego al limite maximo de peliculas.');
            readkey();
        end;
end;
procedure blanquearUbicaciones();
var
    numeroSala:integer;
    fila:char;
    columna:integer;
    turno:integer;
begin
    clrscr();
    for numeroSala := 0 to filesize(FCine) - 1 do
        begin
            seek(FCine , numeroSala);
            read(FCine , sala);
            for fila := 'A'  to MAXIMO_FILAS do
                begin
                    for columna := 1 to MAXIMO_COLUMNAS do
                        begin
                            for turno := 1 to 5 do
                                begin
                                    sala.lugares[fila,columna,turno] := 'L';
                                end;
                        end;
                end;
            seek(FCine , numeroSala);
            write(FCine , sala);
        end;
end;
procedure localidades(numeroSala:integer; t:integer);
var
    fila:char;
    columna:integer;
begin
    seek(FCine , numeroSala - 1); // recordar que esta corrido en 1.
    read(FCine , sala);

    for fila := 'A' to MAXIMO_FILAS do
        begin
            for columna := 1 to MAXIMO_COLUMNAS do
                begin
                    write(sala.lugares[fila,columna,t],' ');
                end;
            writeln(''); 
        end;    
end;
procedure venderEntradas();
var
    pelicula:string[30];
    fila:char;
    columna:integer;
    turno:integer;
    cantidadEntradas:integer;
    contador:integer;
    posicion:integer;
begin
    clrscr();

    write('Nombre de pelicula:');
    readln(pelicula);
    
    turno := validarNumero(1,5,1);

    write('Cantidad de entradas:');
    readln(cantidadEntradas);

    posicion := buscarPelicula(pelicula);

    if(entradasDisponibles(posicion,cantidadEntradas,turno))then
        begin
            for contador := 1 to cantidadEntradas do
                begin
                    seek(FCine , posicion);
                    read(FCine , sala);
                    clrscr();
                    writeln('Nombre de la pelicula:',pelicula);
                    localidades(sala.nroSala , turno);
                    readkey();
                    writeln('');
                    fila := validarTecla('A',MAXIMO_FILAS);
                    columna := validarNumero(1,MAXIMO_COLUMNAS,2);

                    sala.lugares[fila,columna,turno] := 'X';

                    seek(FCine , posicion);
                    write(FCine , sala);            
                end;
        end
    else
        begin
            clrscr();
            write('No hay suficientes entradas.');
        end;
    readkey();
end;
procedure cantidadEspectadores();
var
    numeroSala:integer;
    cantidadPersonas:integer;
    fila:char;
    columna:integer;
    turno:integer;
begin
    clrscr();
    for numeroSala := 0 to filesize(FCine) - 1 do
        begin
            cantidadPersonas := 0;

            seek(FCine , numeroSala);
            read(FCine , sala);

            for fila := 'A' to MAXIMO_FILAS do
                begin
                    for columna := 1 to MAXIMO_COLUMNAS do
                        begin
                            for turno := 1 to 5 do
                                begin
                                    if(sala.lugares[fila,columna,turno] = 'X')then
                                        begin
                                            inc(cantidadPersonas);
                                        end;
                                end;
                        end;
                end;
            
            writeln('Sala:',numeroSala + 1,'  Cantidad espectadores:',cantidadPersonas);
        end;
    readkey();
end;
procedure mostrarCartelera();
begin
    clrscr();
    seek(FCine , 0);
    writeln('Numero de sala     Nombre de pelicula');
    while(not eof(FCine))do
        begin
            read(FCine , sala);
            writeln('      0',sala.nroSala,'                 ',sala.pelicula);
        end;
    readkey();
end;
procedure mostrarSala();
var
    numeroSala:integer;
    fila:char;
    columna:integer;
    turno:integer;
begin
    clrscr();
    write('Numero de sala:');
    readln(numeroSala);
    write('Turno:');
    readln(turno);
    clrscr();
    
    seek(FCine , numeroSala - 1);
    read(FCine , sala);

            for fila := 'A'  to MAXIMO_FILAS do
                begin
                    for columna := 1 to MAXIMO_COLUMNAS do
                        begin
                            write(sala.lugares[fila,columna,turno],' ');
                        end;
                    writeln('');
                end;
    readkey();
end;
procedure menu();
var
    tecla:char;
begin
    repeat
        clrscr();
        writeln('               MENU');
        writeln('');
        writeln('1. Cargar Pelicula');
        writeln('2. Venta de entradas');
        writeln('3. Blanquear ubicaciones');
        writeln('4. Cantidad de espectadores por sala');
        writeln('5. Ver cartelera');
        writeln('6. Ver lugares disponibles');
        writeln('7. Salir');
        tecla := readkey();
        
        case tecla of
            '1': cargarPelicula();
            '2': venderEntradas();
            '3': blanquearUbicaciones(); 
            '4': cantidadEspectadores();
            '5': mostrarCartelera(); 
            '6': mostrarSala(); 
            '7': cerrarArchivo(); 
        end;
    until (tecla = '7');
end;
begin //Principal
    asignar();
    abrirArchivo();
    menu();
end.
