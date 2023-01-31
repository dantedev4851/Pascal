program final_votacion;
uses crt;
type
    regPersona = record
            dni:longint;
            nombre:string[15];
            apellido:string[15];
            lugar:integer;    //1 y 9999
            mesa:integer;  // 1 y 99
            voto:char;  // estado inicial:'N'
        end;
    regVoto = record
            lugar:integer; //1 y 9999
            mesa:integer;  //1 y 99
            partido1:integer;
            partido2:integer;
            partido3:integer;
        end;
var
    FPersonas:file of regPersona;
    persona:regPersona;
    FVotos:file of regVoto;
    voto:regVoto;
procedure asignar();
begin
    assign(FPersonas , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Votacion electronica\personas.dat');
    assign(FVotos , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Votacion electronica\votos.dat');
end;
procedure abrirArchivos();
begin
    {$I-} reset(FPersonas);{$I+} 
    if(ioresult = 2)then // file not found -> archivo no encontrado
        begin
            rewrite(FPersonas);
        end;

    {$I-} reset(FVotos);{$I+} 
    if(ioresult = 2)then // file not found -> archivo no encontrado
        begin
            rewrite(FVotos);
        end;
end;
procedure cerrarArchivos();
begin
    close(FPersonas);
    close(FVotos);
end;
function validarNumero(min:integer;max:integer;valor:char):integer;
begin
    case valor of
        'l':
            begin
                repeat
                    clrscr();
                    write('Lugar de votacion:');
                    readln(validarNumero);
                until ((validarNumero >= min) and (validarNumero <= max));
            end;
        'm':
            begin
                repeat
                    clrscr();
                    write('Mesa de votacion:');
                    readln(validarNumero);
                until ((validarNumero >= min) and (validarNumero <= max));
            end;
        'o':
            begin
                repeat
                    clrscr();
                    writeln('[1] Partido1');
                    writeln('[2] Partido2');
                    writeln('[3] Partido3');
                    writeln('');
                    write('Ingrese una opcion:');
                    readln(validarNumero);
                until ((validarNumero >= min) and (validarNumero <= max));

            end;
    end;
end;
function buscarPersona(dato:longint):integer; // no usamos dicotomica porque deberia estar ordenado xdni
begin
    buscarPersona := -1;
    seek(FPersonas , 0);

    repeat
        read(FPersonas , persona);
    until ((persona.dni = dato) or (eof(FPersonas)));

    if(persona.dni = dato)then
        begin
            buscarPersona := filepos(FPersonas) - 1;	
        end;
end;
function busquedaSecuencial(l:integer;m:integer):integer;
begin
    busquedaSecuencial := -1;
    seek(FVotos , 0);
    repeat
        read(FVotos , voto);
    until (((voto.lugar = l) and (voto.mesa = m)) or eof(FVotos));
    
    if((voto.lugar = l) and (voto.mesa = m))then
        begin
            busquedaSecuencial := filepos(FVotos)-1;
        end;
end;
procedure tomarDatos(dni:longint);
var
    posicion:integer;
begin
    write('nombre:');
    readln(persona.nombre);
    write('apellido:');
    readln(persona.apellido);
    persona.dni := dni;
    persona.lugar := validarNumero(1,9999,'l');
    persona.mesa := validarNumero(1,99,'m');
    persona.voto := 'N';

    seek(FPersonas , filesize(FPersonas));
    write(FPersonas , persona);

    if(filesize(FVotos) = 0)then
        begin
            seek(FVotos , filesize(FVotos));
            voto.lugar := persona.lugar;	
            voto.mesa := persona.mesa;
            voto.partido1 := 0;	
            voto.partido2 := 0;	
            voto.partido3 := 0;	
            write(FVotos , voto);
        end
    else
        begin
            posicion := busquedaSecuencial(persona.lugar,persona.mesa);

            if(posicion = -1)then
                begin
                    seek(FVotos , filesize(FVotos));
                    voto.lugar := persona.lugar;	
                    voto.mesa := persona.mesa;
                    voto.partido1 := 0;	
                    voto.partido2 := 0;	
                    voto.partido3 := 0;	
                    write(FVotos , voto);
                end;
        end;
end;
procedure cargarPadron();
var
    dni:longint;
    posicion:integer;
begin
    clrscr();
    write('Dni:');
    readln(dni);

    while(dni <> 0)do
        begin
            if(filesize(FPersonas) = 0)then // esto se hace la primera vez para que no se crashee el programa.
                begin
                    tomarDatos(dni);
                end
            else
                begin
                    posicion := buscarPersona(dni);
                    if(posicion = -1)then
                        begin
                            tomarDatos(dni);
                        end
                    else
                        begin
                            writeln('Ya se encuentra cargado esta persona en el padron.');
                            readkey();
                        end;
                end;
            clrscr();
            write('Dni(0 para finalizar):');
            readln(dni);
        end;
end;
procedure ordenarPadron(); // por apellido de menor a mayor.
var
    i,j:integer;
    aux,copia:regPersona;
begin
    for i := 0 to filesize(FPersonas)-1 do
        begin
            for j := 0 to filesize(FPersonas)-2 do
                begin
                    seek(FPersonas , j);
                    read(FPersonas , persona);

                    seek(FPersonas , j + 1);
                    read(FPersonas , copia);

                    if(persona.apellido > copia.apellido)then
                        begin
                            aux := 	persona;
                            persona := copia;
                            copia := aux;

                            seek(FPersonas , j);
                            write(FPersonas , persona);

                            seek(FPersonas , j + 1);
                            write(FPersonas , copia);
                        end;
                end;
        end;
end;
procedure mostrarPadron();
begin
    clrscr();
    if(filesize(FPersonas) = 0)then
        begin
            write('No hay personas cargadas en el padron electoral.');
        end
    else
        begin
            writeln('  DNI       NOMBRE       APELLIDO    LUGAR   NRO.MESA  VOTO');
            ordenarPadron();
            seek(FPersonas , 0 );
            while(not eof(FPersonas))do
                begin
                    read(FPersonas , persona);
                    writeln(persona.dni,'     ',persona.nombre,'       ',persona.apellido,'       ',persona.lugar,'       ',persona.mesa,'       ',persona.voto);
                end;
        end;
    readkey();
end;
procedure mostrarDatosVotacion();
begin
    clrscr();
    seek(FVotos , 0);
    writeln('Lugar de votacion   Nro.Mesa  Partido1  Partido2  Partido3');
    while(not eof(FVotos))do
        begin
            read(FVotos , voto);
            writeln('       0',voto.lugar,'              0',voto.mesa,'       0',voto.partido1,'         0',voto.partido2,'        0',voto.partido3);
        end;
    readkey();
end;
procedure cambioEstado(pos:integer);
begin
    persona.voto := 'S';
    seek(FPersonas , pos);
    write(FPersonas , persona);    
end;
procedure registrarVoto();
var
    dni:longint;
    posicion,posicion2:integer;
    opcion:integer;
begin
    repeat
        clrscr();
        write('Dni:');
        readln(dni);
    
        posicion := buscarPersona(dni);

        if(posicion <> -1)then
            begin
                seek(FPersonas , posicion);
                read(FPersonas , persona);
                
                writeln('Nombre:',persona.nombre);
                writeln('Apellido:',persona.apellido);
                writeln('Lugar de votacion:',persona.lugar);
                writeln('Numero de mesa:',persona.mesa);
                readkey();
                if(persona.voto = 'N')then
                    begin
                        opcion := validarNumero(1,3,'o');
                        posicion2 := busquedaSecuencial(persona.lugar,persona.mesa);
                        case opcion of
                            1: inc(voto.partido1);
                            2: inc(voto.partido2);
                            3: inc(voto.partido3);
                        end;
                        seek(FVotos , posicion2);
                        write(FVotos , voto);

                        writeln('Votacion registrada con exito');
                        cambioEstado(posicion);
                    end
                else
                    begin
                        writeln('');
                        writeln('Esta persona ya voto');
                    end;
            end
        else
            begin
                write('No se encontro en el padron');
            end;
        readkey();
    until (dni = 0);
end;
procedure listado();
var
    lugar:integer;
    numeroRegistro:integer;
    c1,c2,c3:integer;
begin
    clrscr();
    lugar := validarNumero(0,9999,'l');
    while(lugar <> 0)do
        begin
            c1 := 0;
            c2 := 0;
            c3 := 0;
            clrscr();
            writeln('Lugar de votacion:',lugar);
            writeln('Nro. de mesa  partido1  partido2  partido3');
            for numeroRegistro := 0 to filesize(FVotos)-1 do
                begin
                    seek(FVotos , numeroRegistro);
                    read(FVotos , voto);

                    if(voto.lugar = lugar)then
                        begin
                            writeln('    ',voto.mesa,'            ',voto.partido1,'          ',voto.partido2,'         ',voto.partido3);
                            c1 := c1 + voto.partido1;
                            c2 := c2 + voto.partido2;
                            c3 := c3 + voto.partido3;
                        end;
                end;
            writeln('--------------------------------------');
            writeln('TOTAL: ',c1,'  ',c2,'  ',c3);
            readkey();
            clrscr();
            lugar := validarNumero(0,9999,'l');
        end;    
end;
procedure menu();
var
    tecla:char;
begin
    repeat
        clrscr();
        writeln('           MENU');
        writeln();
        writeln('1. Registrar voto');
        writeln('2. Listado de recuento de votos');
        writeln('3. Cargar padron electoral');
        writeln('4. Ver padron electoral');
        writeln('5. Ver informacion de lugar de votacion');
        writeln('6. Salir');
        tecla := readkey();

        case tecla of
            '1': registrarVoto();
            '2': listado();
            '3': cargarPadron();
            '4': mostrarPadron();
            '5': mostrarDatosVotacion();
            '6': cerrarArchivos();
        end;
    until (tecla = '6');
end;
begin
    asignar();
    abrirArchivos();
    menu();
end.