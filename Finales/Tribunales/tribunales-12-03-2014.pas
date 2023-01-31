program final_tribunales;
uses crt;
type
    regJuicio = record
            nroJuicio:integer;
            id:integer;
            juzgado:integer;
            anio:integer;
            caratula:string[30];
            nroCliente:integer;
            cliente:string[30];
            estado:string[30]; // activo o cerrado
        end;
    
    regActuacion = record
            id:integer;
            descripcion:string[30];
            hrsTrabajadas:real;
            gastos:real;
        end;
var
    Fjuicios:file of regJuicio;
    juicio:regJuicio;
    Factuaciones:file of regActuacion;
    actuacion:regActuacion;
function primeraVez():boolean;
begin
    primeraVez := false;

    if(filesize(Fjuicios) = 0)then
        begin
            primeraVez := true;
        end;    
end;
function validarTexto(palabra1:string;palabra2:string):string;
begin
    repeat
        clrscr();
        write('Estado(activo/cerrado):');
        readln(validarTexto);
    until ((validarTexto = palabra1) or (validarTexto = palabra2));
end;
function buscarJuicio(dato:integer):integer;
var
    inf,med,sup:integer;
begin
    buscarJuicio := -1;
    inf := 0;
    sup := filesize(Fjuicios) - 1;

    repeat
        med := (inf + sup) div 2;
        seek(Fjuicios , med);
        read(Fjuicios , juicio);

        if(juicio.nroCliente = dato)then
            begin
                buscarJuicio := med;	
            end
        else if(juicio.nroCliente > dato)then
            begin
                sup := med - 1;	
            end
        else
            begin
                inf := med + 1;
            end;
    until ((buscarJuicio <> -1) or (inf > sup));
end;
function existeID(dato:integer):boolean;
begin
    existeID := false;
    seek(Fjuicios , 0);

    repeat
        read(Fjuicios , juicio);
    until ((juicio.id = dato)) or (eof(Fjuicios));

    if(juicio.id = dato)then
        begin
            existeID := true;
        end;
end;
procedure asignar();
begin
   assign(Fjuicios , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Tribunales\Juicios.dat'); 
   assign(Factuaciones , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Tribunales\Actuaciones.dat'); 
end;
procedure abrirArchivos();
begin
    {$I-}reset(Fjuicios);{$I+}    
    if(ioresult = 2)then
        begin
            rewrite(Fjuicios);	
        end;
    {$I-}reset(Factuaciones);{$I+}    
    if(ioresult = 2)then
        begin
            rewrite(Factuaciones);	
        end;
end;
procedure closeArchivos();
begin
    close(Fjuicios);
    close(Factuaciones);
end;
procedure tomarDatos();
begin
    write('Numero de juicio:');
    readln(juicio.nroJuicio);
    write('Juzgado:');
    readln(juicio.juzgado);
    write('Anio:');
    readln(juicio.anio);
    write('Caratula:');
    readln(juicio.caratula);
    write('Id:');
    readln(juicio.id);
    write('Cliente:');
    readln(juicio.cliente);
    juicio.estado := validarTexto('activo','cerrado');
end;
procedure ordenarDatos(); // ordenado por nro de cliente.
var
    i,j:integer;
    aux,copia:regJuicio;
begin
    for i := 0 to filesize(Fjuicios) - 1 do
        begin
            for j := 0 to filesize(Fjuicios) - 2 do
                begin
                    seek(Fjuicios , j);
                    read(Fjuicios , juicio);

                    seek(Fjuicios , j + 1);
                    read(Fjuicios , copia);

                    if(juicio.nroCliente > copia.nroCliente)then
                        begin
                            aux := juicio;
                            juicio := copia;
                            copia := aux;

                            seek(Fjuicios , j);
                            write(Fjuicios , juicio);

                            seek(Fjuicios , j + 1);
                            write(Fjuicios , copia);	
                        end;
                end;
        end;
end;
procedure cargarJuicio();
var
    tecla:char;
    posicion:integer;
begin
    tecla := 'c';

    while(tecla = 'c')do
        begin
            clrscr();
            write('Nro. de cliente:');
            readln(juicio.nroCliente);

            if(primeraVez)then
                begin
                    tomarDatos();
                    seek(Fjuicios , filesize(Fjuicios));
                    write(Fjuicios , juicio);
                end
            else
                begin
                    posicion := buscarJuicio(juicio.nroCliente);
                                
                    if(posicion = -1)then
                        begin
                            tomarDatos();
                            seek(Fjuicios , filesize(Fjuicios));
                            write(Fjuicios , juicio);
                        end
                    else
                        begin
                            writeln('Ya hay un juicio cargado con este id.');
                        end;
                end;
            
            ordenarDatos();
            write('Desea continuar o finalizar?');
            tecla := readkey();
        end;
end;
procedure cargarActuaciones();
var
    tecla:char;
begin
    tecla := 'c';

    while(tecla = 'c')do
        begin
            clrscr();
            write('Id:');
            readln(actuacion.id);   
            
            if(existeID(actuacion.id))then
                begin
                    write('Descripcion:');
                    readln(actuacion.descripcion);
                    write('Cantidad de horas trabajadas:');
                    readln(actuacion.hrsTrabajadas);
                    write('Gastos:');
                    readln(actuacion.gastos);

                    seek(Factuaciones , filesize(Factuaciones));
                    write(Factuaciones , actuacion);
                end
            else
                begin
                    clrscr();
                    writeln('No se encontro el id solicitado.');
                end;
            writeln('Desea continuar o finalizar?');
            tecla := readkey();
        end;    
end;
function promedioGastos():real;
var
    totalHrs:real;
    totalGastos:real;
begin
    totalHrs := 0;
    totalGastos := 0;
    seek(Factuaciones , 0);
    while(not eof(Factuaciones))do
        begin
            read(Factuaciones , actuacion);

            totalHrs := totalHrs + actuacion.hrsTrabajadas;
            totalGastos := totalGastos + actuacion.gastos;
        end;
    promedioGastos := (totalGastos / totalHrs);
end;
procedure gastos();
begin
    clrscr();
    write('Gastos totales:',promedioGastos():5:2);
    readkey(); 
end;
procedure listado();
var
    nroJuicio:integer;
    posicion:integer;
begin
    clrscr();
    write('Numero de juicio:');
    readln(nroJuicio);
    
    clrscr();
    posicion := buscarJuicio(nroJuicio);
    if(posicion <> -1)then
        begin
            seek(Fjuicios , posicion);	
            read(Fjuicios , juicio);
            
            writeln('Nro. de juicio:',juicio.nroJuicio);
            writeln('Id:',juicio.id);
            writeln('Juzgado:',juicio.juzgado);
            writeln('Anio:',juicio.anio);
            writeln('Caratula:',juicio.caratula);
            writeln('Nro. de cliente:',juicio.nroCliente);
            writeln('Cliente:',juicio.cliente);
            writeln('Estado:',juicio.estado);

            seek(Factuaciones , 0);
            repeat
                read(Factuaciones , actuacion);

                if(actuacion.id = juicio.id)then
                    begin
                        writeln('Descripcion:',actuacion.descripcion);
                        writeln('Cantidad de horas trabajadas:',actuacion.hrsTrabajadas:5:2);
                        writeln('Gastos:',actuacion.gastos:5:2);
                    end;
            until (eof(Factuaciones));
        end
    else
        begin
            writeln('No se encontro el nro solicitado.');
        end;
    readkey();
end;
procedure modificarEstado();
var
    nroCliente:integer;
    posicion:integer;
begin
    clrscr();
    write('Nro. de cliente:');
    readln(nroCliente);

    posicion := buscarJuicio(nroCliente);

    if(posicion <> -1)then
        begin
            seek(Fjuicios , posicion);
            read(Fjuicios , juicio);

            if(juicio.estado = 'activo')then
                begin
                    juicio.estado := 'cerrado';
                end
            else
                begin
                    juicio.estado := 'activo';
                end;
            seek(Fjuicios , posicion);
            write(Fjuicios , juicio);

            writeln('Se ha actualizado el estado con exito.');
        end
    else
        begin
            writeln('No se encontro el nro de cliente.');
        end;

    readkey();
end;    
procedure menu();
var
    tecla:char;
begin
    repeat
        clrscr();
        writeln('           MENU');
        writeln('');
        writeln('1. Listado de un juicio');
        writeln('2. Gastos totales');
        writeln('3. Modificar estado');
        writeln('4. Cargar juicio');
        writeln('5. Cargar actuaciones');
        writeln('6. Salir');
        tecla := readkey();
        
        case tecla of
            '1': listado();
            '2': gastos();
            '4': cargarJuicio(); 
            '3': modificarEstado();
            '5': cargarActuaciones(); 
            '6': closeArchivos();
        end;
    until (tecla = '6');
end;
begin // principal
    asignar();
    abrirArchivos();
    menu();
end.