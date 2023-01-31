program final_multas;
uses crt;
type
    regMulta = record
            codigo:string[6];
            patente:string[6];
            dni:string[9];
            tipoMulta:integer;
            lugarInfraccion:string[30];
            fechaVencimiento:string[8];
            fechaPagada:string[8];
            grua:char; // S/N
        end;
    regTipo = record
        tipoMulta:integer;
        valorAbonar:real;
    end;

var
    Fmultas:file of regMulta;
    multa:regMulta;
    Ftipos:file of regTipo;
    tipo:regTipo;
function validarNumero(min:integer; max:integer):integer;
begin
    repeat
        write('Ingrese una opcion:');
        readln(validarNumero);
        clrscr();
    until((validarNumero >= min) and (validarNumero <= max))    
end;
function validarTecla(valor1:char; valor2:char):char;
begin
    repeat
        clrscr();
        write('acarrea con grua (S/N):');
        validarTecla := readkey();
    until((validarTecla = valor1) or (validarTecla = valor2))    
end;
function calculo(tipoMulta:integer;grua:char):real;
begin
    seek(Ftipos , tipoMulta - 1); // tipomulta:1 esta guardado en reg 0, y asi sucesivamente.
    read(Ftipos , tipo);

    calculo := tipo.valorAbonar;

    if(grua = 'S')then
        begin
            calculo := calculo + (tipo.valorAbonar * 0.10);
        end;
end;
function buscarVehiculo(dato:string;numero:integer):boolean;
begin
    buscarVehiculo := false;
    seek(Fmultas , 0);

    case numero of
        1:begin
            repeat
                read(Fmultas , multa);
            until((multa.patente = dato) or eof(Fmultas));

            if(multa.patente = dato)then
                begin
                    buscarVehiculo := true;	
                end;
          end;
        2:begin
            repeat
                read(Fmultas , multa);
            until((multa.dni = dato) or eof(Fmultas));

            if(multa.dni = dato)then
                begin
                    buscarVehiculo := true;	
                end;
          end;
    end;
end;
function buscarTipo(dato:integer):boolean;
begin
    buscarTipo := false;
    seek(Ftipos , 0);
    repeat
        read(Ftipos , tipo);
    until((tipo.tipoMulta = dato) or (eof(Ftipos)));

    if(tipo.tipoMulta = dato)then
        begin
            buscarTipo := true;	
        end;    
end;
function existeMulta(dato:string):integer;
var
    inf,med,sup:integer;
begin
    existeMulta := -1;
    inf := 0;
    sup := filesize(Fmultas) - 1;

    repeat
        med := (inf + sup) div 2;
        seek(Fmultas , med);
        read(Fmultas , multa);

        if(multa.codigo = dato)then
            begin
                existeMulta := med;	
            end
        else if(multa.codigo > dato)then
            begin
                sup := med - 1;	
            end
        else
            begin
                inf := med + 1;
            end;
    until ((existeMulta <> -1) or (inf>sup));
end;
procedure asignar();
begin
    assign(Fmultas , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Multas\multas.dat');
    assign(Ftipos , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Multas\tipos.dat');
end;
procedure abrirArchivos();
begin
    {$I-}reset(Fmultas);{$I+}  
    if(ioresult = 2)then  // file not found
        begin
            rewrite(Fmultas);	
        end;
    {$I-}reset(Ftipos);{$I+}  
    if(ioresult = 2)then  // file not found
        begin
            rewrite(Ftipos);	
        end;
end;
procedure cerrarArchivos();
begin
    close(Fmultas);
    close(Ftipos);
end;
procedure consultarMultas(dato:string;numero:integer);
begin  
    clrscr();
    seek(Fmultas , 0);

    while(not eof(Fmultas))do
        begin
            read(Fmultas , multa);

            case numero of
                1:begin
                      if((multa.patente = dato) and (multa.fechaPagada = '-'))then
                        begin
                            writeln('Codigo:',multa.codigo);
                            writeln('Patente:',multa.patente);
                            writeln('Dni:',multa.dni);
                            writeln('Tipo de multa:',multa.tipoMulta);
                            writeln('Lugar de infraccion:',multa.lugarInfraccion);
                            writeln('Fecha de vencimiento:',multa.fechaVencimiento);
                            write('Acarrea con grua:',multa.grua);
                            writeln('');
                            write('Monto a abonar:$',calculo(multa.tipoMulta,multa.grua):5:2);
                        end;
                  end;
                2:begin
                      if((multa.dni = dato) and (multa.fechaPagada = '-'))then
                        begin
                            writeln('Codigo:',multa.codigo);
                            writeln('Patente:',multa.patente);
                            writeln('Dni:',multa.dni);
                            writeln('Tipo de multa:',multa.tipoMulta);
                            writeln('Lugar de infraccion:',multa.lugarInfraccion);
                            writeln('Fecha de vencimiento:',multa.fechaVencimiento);
                            write('Acarrea con grua:',multa.grua);
                            writeln('');
                            write('Monto a abonar:$',calculo(multa.tipoMulta,multa.grua):5:2);
                        end;
                  end
            end;
        end;
    readkey();
end;
procedure consultar();
var
  opcion:integer;
  patente:string[6];
  dni:string[9];
begin
    clrscr();
    writeln('       CONSULTAS DE MULTAS');
    writeln('');
    writeln('1. Por patente');
    writeln('2. Por dni');
    writeln('3. Salir');

    opcion := validarNumero(1,3);
    clrscr();
    case opcion of
        1:begin
            write('Patente del vehiculo:');
            readln(patente);
            if(buscarVehiculo(patente , 1))then
                begin
                    consultarMultas(patente , 1);
                end
            else
                begin
                    clrscr();
                    write('No se encontro la patente solicitada');
                    readkey();
                end;
          end;
        2:begin
            clrscr();
            write('Dni:');
            readln(dni);

            if(buscarVehiculo(dni , 2))then
                begin
                    consultarMultas(dni , 2);
                end
            else
                begin
                    clrscr();
                    write('No se encontro el dni solicitado.');
                    readkey();
                end;
          end;
    end;
end;

procedure ordenarDatos(); // por codigo;
var
    i,j:integer;
    aux,copia:regMulta;
begin
    for i := 0 to filesize(Fmultas) - 1 do
        begin
            for j := 0 to filesize(Fmultas) - 2 do
                begin
                    seek(Fmultas , j);
                    read(Fmultas , multa);
                    seek(Fmultas , j + 1);
                    read(Fmultas , copia);

                    if(multa.codigo > copia.codigo)then
                        begin
                            aux := multa;
                            multa := copia;
                            copia := aux;

                            seek(Fmultas , j);
                            write(Fmultas , multa);

                            seek(Fmultas , j + 1);	
                            write(Fmultas , copia);
                        end;
                end;
        end;
end;
procedure cargarMultas();
var
    tecla:char;
begin
    tecla := 'c';
    while(tecla = 'c')do
        begin
            clrscr();
            write('Codigo:');
            readln(multa.Codigo);
            write('Patente:');
            readln(multa.patente);
            write('Dni:');
            readln(multa.dni);
            write('Tipo de multa:');
            readln(multa.tipoMulta);
            write('Lugar de infraccion:');
            readln(multa.lugarInfraccion);
            write('Fecha de vencimiento:');
            readln(multa.fechaVencimiento);
            multa.grua := validarTecla('S','N');
            multa.fechaPagada := '-';

            seek(Fmultas , filesize(Fmultas));
            write(Fmultas , multa);

            if(filesize(Ftipos) = 0)then
                begin
                    clrscr();
                    tipo.tipoMulta := multa.tipoMulta;
                    write('Valor a abonar:');
                    readln(tipo.valorAbonar);

                    seek(Ftipos , filesize(Ftipos));
                    write(Ftipos , tipo);
                end
            else if(buscarTipo(multa.tipoMulta) = false)then
                begin
                    tipo.tipoMulta := multa.tipoMulta;
                    write('Valor a abonar:');
                    readln(tipo.valorAbonar);

                    seek(Ftipos , filesize(Ftipos));
                    write(Ftipos , tipo);
                end;
            writeln('Desea continuar o finalizar (C-F)?');
            tecla := readkey();
        end;
    
    ordenarDatos();
    
end;
procedure registrarPago();
var
    codigo:string[6];
    posicion:integer;
begin
    clrscr();
    write('Codigo:');
    readln(codigo);

    posicion := existeMulta(codigo);

    if(posicion <> -1)then
        begin
            seek(Fmultas , posicion);
            read(Fmultas , multa);

            if(multa.fechaPagada = '-')then
                begin
                    clrscr();
                    writeln('Monto a abonar:$',calculo(multa.tipoMulta,multa.grua):5:2);
                    
                    write('Fecha actual:');
                    readln(multa.fechaPagada);

                    seek(Fmultas , posicion);
                    write(Fmultas , multa);
                end
            else
                begin
                    clrscr();
                    write('Esta multa ya ha sido pagada.');
                end;
        end
    else
        begin
            clrscr();
            write('No se encontro el codigo solicitado');
        end;

    readkey();
end;
procedure listado();
var
    tipoMulta:integer;
    sumatoria:real;
begin
    clrscr();
    sumatoria := 0;
    write('Tipo de multa:');
    readln(tipoMulta);

    seek(Fmultas , 0);
    while(not eof(Fmultas))do
        begin
            read(Fmultas , multa);

            if((multa.tipoMulta = tipoMulta) and (multa.fechaPagada = '-'))then
                begin
                    writeln('Codigo:',multa.codigo);
                    writeln('Patente:',multa.patente);
                    writeln('Dni:',multa.dni);
                    writeln('Tipo de multa:',multa.tipoMulta);
                    writeln('Lugar de infraccion:',multa.lugarInfraccion);
                    writeln('Fecha de vencimiento:',multa.fechaVencimiento);
                    writeln('Acarreo con grua:',multa.grua);
                    sumatoria := sumatoria + calculo(multa.tipoMulta , multa.grua);
                end;
        end;
    writeln('');
    writeln('Total final a abonar:$',sumatoria:5:2);
    readkey();
end;
procedure mostrarMultas();
var
    codigo:string[6];
    posicion:integer;
begin
    clrscr();
    write('Codigo:');
    readln(codigo);

    posicion := existeMulta(codigo);
    clrscr();
    if(posicion <> -1)then
        begin
            seek(Fmultas , posicion);
            read(Fmultas , multa);

            writeln('Codigo:',multa.codigo);
            writeln('Patente:',multa.patente);
            writeln('Dni:',multa.dni);
            writeln('Tipo de multa:',multa.tipoMulta);
            writeln('Lugar de infraccion:',multa.lugarInfraccion);
            writeln('Fecha de vencimiento:',multa.fechaVencimiento);
            writeln('Fecha que abono:',multa.fechaPagada);
            if(multa.fechapagada = '-')then
                begin
                    writeln('Monto que tiene que abonar:$',calculo(multa.tipoMulta,multa.grua):5:2);
                end
            else
                begin
                    writeln('Monto pagado:$',calculo(multa.tipoMulta,multa.grua):5:2);
                end;
            writeln('Acarreo con grua:',multa.grua);
        end
    else
        begin
            writeln('No se encontro el codigo solicitado.');
        end;
    readkey();
end;
procedure menu();
var
    tecla:char;
begin
    repeat
        clrscr();
        write('         MENU');
        writeln('');
        writeln('1. Consultar multas');
        writeln('2. Registrar pago de multa');
        writeln('3. Listado');
        writeln('4. Cargar multas');
        writeln('5. Ver multas');
        writeln('6. Salir');
        tecla := readkey();

        case tecla of
            '1': consultar();
            '2': registrarPago();
            '3': listado();
            '4': cargarMultas();
            '5': mostrarMultas();
            '6': cerrarArchivos();
        end;
    until (tecla = '6');
end;
begin
    asignar();
    abrirArchivos();
    menu();
end.