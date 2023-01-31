program final_aves;
uses crt;
type  
   regAvistaje = record
        fecha:string[30];
        ave:integer;
        socio:integer;
        lugar:string[30];
   end;
   regAve = record
        ave:integer;
        desc:string[30];
   end;
   regSocio = record
        socio:integer;
        nombre:string[30];
        cantidad:integer;
   end;
var
  FAvistajes: file of regAvistaje;
  FAves: file of regAve;
  FSocios: file of regSocio;
  avistaje:regAvistaje;
  ave:regAve;
  socio:regSocio;
function buscarAve(dato:integer):integer;
begin
    buscarAve := -1;
    seek(FAves , 0);
    repeat
        read(FAves , ave);
    until ((ave.ave = dato) or (eof(FAves)));

    if(ave.ave = dato)then
        begin
            buscarAve := filepos(FAves)-1;	
        end;
end;
function buscarSocio(dato:integer):integer;
begin
    buscarSocio := -1;
    seek(FSocios , 0);
    repeat
        read(FSocios , socio);
    until ((socio.socio = dato) or (eof(FSocios)));

    if(socio.socio = dato)then
        begin
            buscarSocio := filepos(FSocios) - 1;	
        end;
end;
procedure asignar();
begin
    assign(FAvistajes , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Aves\avistajes.dat');
    assign(FAves , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Aves\aves.dat');
    assign(FSocios , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Aves\socios.dat');
end;
procedure abrirArchivos();
begin
    {$I-}reset(FAvistajes){$I+};
    if(ioresult <> 0)then
        begin
            rewrite(FAvistajes);
        end;
    {$I-}reset(FAves){$I+};
    if(ioresult <> 0)then
        begin
            rewrite(FAves);
        end;
    {$I-}reset(FSocios){$I+};
    if(ioresult <> 0)then
        begin
            rewrite(FSocios);
        end;
end;
procedure cargarAve();
var
    tecla:char;
begin
    tecla := 'c';
    while(tecla = 'c')do
        begin
            clrscr();
            write('Codigo de ave:');
            readln(ave.ave);
            write('Nombre:');
            readln(ave.desc);

            seek(FAves , filesize(FAves));
            write(FAves , ave);

            write('Desea continuar o finalizar?');
            tecla := readkey();
        end;
end;
procedure cargarSocio();
var
    tecla:char;
begin
    tecla := 'c';
    while(tecla = 'c')do
        begin
            clrscr();
            write('Numero de socio:');
            readln(socio.socio);
            write('Nombre:');
            readln(socio.nombre);
            write('Cantidad de observaciones:');
            readln(socio.cantidad);

            seek(FSocios , filesize(FSocios));
            write(FSocios , socio);

            writeln('Desea continuar o finalizar?');
            tecla := readkey();
        end;
end;
procedure cerrarArchivos();
begin
    close(FAvistajes);
    close(FAves);
    close(FSocios);
end;
procedure registrarAvistaje(f:string;s:integer;a:integer;l:string);
var
    posicion1,posicion2:integer;
begin
    clrscr();
    posicion1 := buscarAve(a);
    if(posicion1 <> -1)then
        begin
            posicion2 := buscarSocio(s);

            if(posicion2 <> -1)then
                begin
                    seek(FAvistajes , filesize(FAvistajes));
                    avistaje.fecha := f;
                    avistaje.socio := s;
                    avistaje.ave := a;
                    avistaje.lugar := l;
                    write(FAvistajes , avistaje);

                    seek(FSocios , posicion2);
                    inc(socio.cantidad);
                    write(FSocios , socio);
                end
            else
                begin
                    writeln('No se encontro el socio');
                    readkey();
                end;
        end
    else
        begin
            writeln('No se encontro el ave');
            readkey();
        end;    
end;
procedure listadoHistoria();
var
    posicion:integer;
    codigoAve:integer;
    numeroRegistro:integer;
begin
    clrscr();   
    writeln('Codigo de ave:'); 
    readln(codigoAve);
    posicion := buscarAve(codigoAve);

    if(posicion <> -1)then
        begin
            clrscr();
            seek(FAves , posicion);
            read(FAves , ave);

            writeln('Nombre del ave:',ave.desc);
            writeln('Codigo:',ave.ave);
            writeln('');
            writeln('Informacion');
            writeln('   ');
            for numeroRegistro := 0 to filesize(FAvistajes)-1 do
                begin
                    seek(FAvistajes , numeroRegistro);
                    read(FAvistajes , avistaje);

                    if(avistaje.ave = codigoAve)then
                        begin
                            writeln('Fecha:',avistaje.fecha);
                            writeln('Lugar donde fue visto:',avistaje.lugar);	
                        end;
                end;	
        end
    else
        begin
            clrscr();
            writeln('No se encontro el ave.');
        end;
    readkey();
end;
procedure ordenarSocios();
var
    i,j:integer;
    aux,copia:regSocio;
begin
    for i := 0 to filesize(FSocios)-1 do //indica ciclo
        begin
            for j := 0 to filesize(FSocios)-2 do  // para recorrer entre indices.
                begin
                    seek(FSocios , j);
                    read(FSocios , socio);
                    seek(FSocios , j + 1);
                    read(Fsocios , copia);

                    if(socio.cantidad < copia.cantidad)then
                        begin
                            aux := socio;
                            socio := copia;
                            copia := aux;

                            seek(FSocios , j);
                            write(FSocios , socio);
                            seek(FSocios , j + 1);
                            write(FSocios , copia);
                        end;
                end;
        end;
    
end;
procedure listadoObservaciones();
var
    numeroRegistro:integer;
begin
    clrscr();
    ordenarSocios();
    writeln('SOCIO    NOMBRE      CANTIDAD DE OBSERVACIONES');
    for numeroRegistro := 0 to 2 do
        begin
            seek(FSocios , numeroRegistro);
            read(Fsocios , socio);
            writeln(socio.socio,'       ',socio.nombre,'       ',socio.cantidad);
        end;
    readkey();
end;
procedure menu();
var
    tecla:char;
    fecha:string[30];
    socio:integer;
    ave:integer;
    lugar:string[30];
begin
    repeat
        clrscr();
        writeln('               MENU');
        writeln();
        writeln('1. Registro de un avistaje');
        writeln('2. Listado de la historia migratoria de un ave');
        writeln('3. Listado de cantidad de Observaciones por un socio');
        writeln('4. Cargar ave');
        writeln('5. Cargar socio');
        writeln('6. Salir');
        tecla := readkey();

        case tecla of
            '1': begin
                    clrscr();
                    write('Fecha:');
                    readln(fecha);
                    write('Numero de socio:');
                    readln(socio);
                    write('Codigo de ave:');
                    readln(ave);
                    write('Lugar donde fue visto:');
                    readln(lugar);

                    registrarAvistaje(fecha,socio,ave,lugar);
                 end;
            '2': listadoHistoria();
            '3': listadoObservaciones();
            '4': cargarAve();
            '5': cargarSocio();
            '6': cerrarArchivos();
        end;
    until (tecla = '6');    
end;
begin //PPAL
    asignar();
    abrirArchivos();
    menu();
end.