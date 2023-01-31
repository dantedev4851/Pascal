program final_veterinaria;
uses crt;
type
    regMascota = record
            codigo:integer;
            nombre:string[20];
            dueno:string[35];
            mail:string[40];
        end;

    regHistoria = record
            codigo:integer;
            diaVisita:string[8];
            atencion:char;  // p ,v
            corte:char; //s,n
            bano:char; //s,n
            vacuna:string[25];
            medicamento:string[40];
            proxControl:string[6];
        end;

var
    FMascotas:file of regMascota;
    mascota:regMascota;

    FHistorias:file of regHistoria;
    historia:regHistoria;
function buscarMascota(dato:integer):integer;
var
    inf,med,sup:integer;
begin
    buscarMascota := -1;
    inf := 0;
    sup := filesize(FMascotas) - 1;

    repeat
        med := (inf + sup) div 2;
        seek(FMascotas , med);
        read(FMascotas , mascota);

        if(mascota.codigo = dato)then
            begin
                buscarMascota := med;
            end
        else if(mascota.codigo > dato)then
            begin
                sup := med - 1;	
            end
        else
            begin
                inf := med + 1;
            end;
    until ((buscarMascota <> -1) or (inf > sup));
end;
function validarTecla(valor1:char;valor2:char;numero:integer):char;
begin
    case numero of
        1:begin
            repeat
                clrscr();
                write('Corte <S/N>:');
                validarTecla := readkey();
            until((validarTecla = valor1) or (validarTecla = valor2));
          end;
        2:begin
            repeat
                clrscr();
                write('Bano <S/N>:');
                validarTecla := readkey();
            until((validarTecla = valor1) or (validarTecla = valor2));
          end;
    end;
    
end;
procedure asignar();
begin
    assign(FMascotas , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Veterinaria\mascotas.dat');
    assign(FHistorias , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Veterinaria\historias.dat');
end;
procedure abrirArchivos();
begin
    {$I-}reset(FMascotas);{$I+}
    if(ioresult = 2)then    // file not found -> archivo no encontrado
        begin
            rewrite(FMascotas);
        end;    
    {$I-}reset(FHistorias);{$I+}
    if(ioresult = 2)then    // file not found -> archivo no encontrado
        begin
            rewrite(FHistorias);
        end;    
end;
procedure cerrarArchivos();
begin
    close(FMascotas);    
    close(FHistorias);    
end;
procedure ordenarMascotas();
var
    i,j:integer;
    aux,copia:regMascota;
begin
    for i := 0 to filesize(FMascotas)-1 do
        begin
            for j := 0 to filesize(FMascotas)-2 do
                begin
                    seek(FMascotas , j);
                    read(FMascotas , mascota);

                    seek(FMascotas , j + 1);   
                    read(FMascotas , copia);

                    if(mascota.codigo > copia.codigo)then
                        begin
                            aux := mascota;
                            mascota := copia;
                            copia := aux;

                            seek(FMascotas , j);
                            write(FMascotas , mascota);	

                            seek(FMascotas , j + 1);
                            write(FMascotas , copia);	
                        end;
                end;
        end;
end;
procedure grabarDatos(cod:integer);
begin
    mascota.codigo := cod;
    write('Nombre:');
    readln(mascota.nombre);
    write('Dueno:');
    readln(mascota.dueno);
    write('Mail:');
    readln(mascota.mail);
    seek(FMascotas , filesize(FMascotas));
    write(FMascotas , mascota);
    ordenarMascotas();
end;
procedure cargarMascota();
var
    codigo:integer;
    posicion:integer;
begin
    repeat
        clrscr();
        write('Codigo <0 para finalizar>:');
        readln(codigo);

        if(not(codigo = 0))then
            begin
                if(filesize(FMascotas) = 0)then
                    begin
                        grabarDatos(codigo);
                    end
                else
                    begin
                        posicion := buscarMascota(codigo);

                        if(posicion = -1)then
                            begin
                                clrscr();
                                grabarDatos(codigo);
                            end
                        else
                            begin
                                write('Ya fue cargada esta mascota');
                                readkey();
                            end;
                    end;        
            end;
    until (codigo = 0);    
end;
procedure listadoMascotas();
begin
    clrscr();
    seek(FMascotas , 0);

    writeln('CODIGO  NOMBRE   DUENIO     MAIL');
    while(not eof(FMascotas))do
        begin
            read(FMascotas , mascota);
            
            writeln(mascota.codigo,'       ',mascota.nombre,'     ',mascota.dueno,'   ',mascota.mail);
        end;
    readkey();
end;
procedure peluqueria();
var
    codigo:integer;
    posicion:integer;
begin
    clrscr();
    write('Codigo:');
    readln(codigo);

    posicion := buscarMascota(codigo);

    if(posicion <> -1)then
        begin
            write('Fecha:');
            readln(historia.diaVisita);
            historia.codigo := codigo;
            historia.atencion := 'P';
            historia.corte := validarTecla('S','N',1);
            historia.bano := validarTecla('S','N',2);
            
            seek(FHistorias , filesize(FHistorias));
            write(FHistorias , historia);
            writeln('');
            writeln('Registrado con exito.');
        end
    else
        begin
            clrscr();
            write('No se encontro la mascota');
        end;
    readkey();
end;
procedure veterinaria();
var
    codigo:integer;
    posicion:integer;
    numeroRegistro:integer;
begin
    clrscr();
    writeln('Codigo:');
    readln(codigo);

    posicion := buscarMascota(codigo);
    clrscr();

    if(posicion <> -1)then
        begin
            for numeroRegistro := 0 to filesize(FHistorias)-1 do
                begin
                    seek(FHistorias , numeroRegistro);
                    read(Fhistorias , historia);


                    if((historia.codigo = codigo) and (historia.atencion = 'V'))then
                        begin
                            writeln('Codigo:',historia.codigo);
                            writeln('Dia de visita:',historia.diaVisita);
                            writeln('Vacuna:',historia.vacuna);
                            write('Medicamento:',historia.medicamento);
                        end;
                end;
            writeln('');
            write('Fecha:');
            readln(historia.diaVisita);

            write('Vacuna:');
            readln(historia.vacuna);

            write('Medicamento <presione ENTER si no tiene que tomar>:');
            readln(historia.medicamento);

            write('Fecha proximo control <presione ENTER si no tiene que volver>:');
            readln(historia.proxControl);
            seek(FHistorias , filesize(FHistorias));
            write(FHistorias , historia);
        end
    else
        begin
            write('No se encontro la mascota');
        end;
end;
procedure listadoHistorias();
var
    codigo:integer;
    posicion:integer;
    numeroRegistro:integer;
begin
    clrscr();    
    write('Codigo:');
    readln(codigo);

    posicion := buscarMascota(codigo);
    clrscr();
    if(posicion <> -1)then
        begin
            write('Codigo:',codigo);
            for numeroRegistro := 0 to filesize(FHistorias)-1 do
                begin
                    seek(FHistorias , numeroRegistro);
                    read(FHistorias , historia);

                    if(historia.codigo = codigo)then
                        begin
                            writeln('Dia de visita:',historia.diaVisita);
                            writeln('Vacuna:',historia.vacuna);
                            writeln('Medicamento:',historia.medicamento);
                            writeln('Proximo control:',historia.proxControl);
                            writeln('---------------------------------------');
                        end;
                end;
        end
    else
        begin
            write('No se encontro la mascota');
        end;
    readkey();
end;
procedure avisos();
var
    fecha:string[6];
    posicion:integer;
begin
    clrscr();
    write('Fecha:');
    readln(fecha);

    seek(FHistorias , 0);
    
    while(not eof(FHistorias))do
        begin
            read(FHistorias , historia);

            if(historia.proxControl = fecha)then
                begin
                    posicion := buscarMascota(historia.codigo);

                    if(posicion <> -1)then
                        begin
                            seek(FMascotas , posicion);
                            read(FMascotas , mascota);

                            writeln('Codigo:',mascota.codigo);
                            writeln('Nombre:',mascota.nombre);
                            writeln('Dueno:',mascota.dueno);
                            writeln('Mail:',mascota.mail);
                        end;
                end;       
        end;

    readkey();
end;
procedure menu();
var
    tecla:char;
begin
    repeat
        clrscr();
        write('                 MENU');
        writeln('');
        writeln('1. Cargar mascota');
        writeln('2. Peluqueria');
        writeln('3. Veterinaria');
        writeln('4. Avisos de proximos controles');
        writeln('5. Ver mascotas');
        writeln('6. Ver historias de una mascota');
        writeln('7. Salir');
        tecla := readkey();

        case tecla of
            '1': cargarMascota();
            '2': peluqueria();
            '3': veterinaria();
            '4': avisos();
            '5': listadoMascotas();
            '6': listadoHistorias();
            '7': cerrarArchivos();
        end;
    until (tecla = '7');    
end;
begin // ppal
    asignar();
    abrirArchivos();
    menu();
end.