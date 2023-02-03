program final_loteos;
uses crt;
type
    regLote = record
            numeroLote:string[6];
            m2:real;
            precioXm2:real;
            pagoContado:real; //porcentaje de descuento
            anticipoXCuotas:real; //porcentaje de anticipo
            vendido:char;  // S/N
        end;
    regCliente = record
        numeroLote:string[6];
        nombre:string[30];
        formaPago:char;
        montoPagado:real;
    end;
var
    Flotes:file of regLote;
    lote:regLote;
    Fclientes:file of regCliente;
    cliente:regCliente;
function valor(cantidadm2:real;precio:real):real;
begin
    valor := precio * cantidadm2;    
end;
function buscarLote(dato:string):integer;
var
    inf,med,sup:integer;
begin
    buscarLote := -1;
    inf := 0;
    sup := filesize(Flotes) - 1;

    repeat
        med := (inf + sup) div 2;
        seek(Flotes , med);
        read(Flotes , lote);

        if(lote.numeroLote = dato)then
            begin
                buscarLote := med;
            end
        else if(lote.numeroLote > dato)then
            begin
                sup := med - 1;
            end
        else
            begin
                inf := med + 1;
            end;
    until ((inf > sup) or (buscarLote <> -1));    
end;
function validarTecla(valor1:char;valor2:char):char;
begin
    repeat
        clrscr();
        write('Forma de pago (C/A):');
        readln(validarTecla);
    until ((validarTecla = valor1) or (validarTecla = valor2));
end;
procedure asignar();
begin
    assign(Flotes, 'C:\DEV\Pascal\2022\Archivos2022\Finales\Loteos\lotes.dat');
    assign(Fclientes , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Loteos\clientes.dat');
end;
procedure abrirArchivos();
begin
    {$I-}reset(Flotes);{$I+}
    if(ioresult = 2)then
        begin
            rewrite(Flotes);	
        end;
    {$I-}reset(Fclientes);{$I+}
    if(ioresult = 2)then
        begin
            rewrite(Fclientes);	
        end;
end;
procedure cerrarArchivos();
begin
    close(Flotes);    
    close(Fclientes);    
end;
procedure ordenarDatos(); // ordenado ascendente por nro de lote.
var
    i,j:integer;
    aux,copia:regLote;
begin
    for i := 0 to filesize(Flotes) - 1 do
        begin
            for j := 0 to filesize(Flotes) - 2 do
                begin
                    seek(Flotes , j);
                    read(Flotes , lote);

                    seek(Flotes , j + 1);
                    read(Flotes , copia);

                    if(lote.numeroLote > copia.numeroLote)then
                        begin
                            aux := lote;
                            lote := copia;
                            copia := aux;

                            seek(Flotes , j);
                            write(Flotes , lote);

                            seek(Flotes , j + 1);
                            write(Flotes , copia);	
                        end;
                end;
        end;
end;
procedure cargarLote();
var
    tecla:char;
    montoMaximo:real;
begin
    tecla := 'c';

    while(tecla = 'c')do
        begin  
            clrscr();
            write('Numero de lote:');
            readln(lote.numeroLote);

            write('Metros cuadrados:');
            readln(lote.m2);

            write('Precio por metro cuadrado:');
            readln(lote.precioXm2);

            write('% Pago contado:');
            readln(lote.pagoContado);

            lote.pagoContado := lote.pagoContado * 0.01;

            write('% Anticipo por pago en cuotas:');
            readln(lote.anticipoXCuotas);

            lote.anticipoXCuotas := lote.anticipoXCuotas * 0.01;

            lote.vendido := 'N';

            seek(Flotes , filesize(Flotes));
            write(Flotes , lote);

            write('Desea continuar o finalizar?');
            tecla := readkey();
        end;
    ordenarDatos();
end;
procedure consultarLotes();
var
    montoMaximo:real;
begin
    clrscr();
    write('Monto maximo:');
    readln(montoMaximo);

    seek(Flotes , 0);
    while(not eof(Flotes))do
        begin
            read(Flotes , lote);

            if((lote.vendido = 'N') and (valor(lote.m2 , lote.precioXm2) <= montoMaximo))then
                begin
                    writeln('Numero de lote:',lote.numeroLote);
                    writeln('Metros cuadrados:',lote.m2:5:2);
                    writeln('Precio por metro cuadrado:',lote.precioXm2:5:2);
                    writeln('% pago contado:',lote.pagoContado:5:2);
                    writeln('% anticipo por pago en cuotas:',lote.anticipoXCuotas:5:2);
                end;
        end; 
    readkey();   
end;
procedure venderLote();
var
    posicion:integer;
begin
    clrscr();
    write('Numero de lote:');
    readln(cliente.numeroLote);

    posicion := buscarLote(cliente.numeroLote);
    clrscr();
    if(posicion <> -1)then
        begin
            seek(Flotes , posicion);
            read(Flotes , lote);

            if(lote.vendido = 'N')then
                begin
                   write('Nombre:');
                   readln(cliente.nombre);

                   cliente.formaPago := validarTecla('C','A');

                   case cliente.formaPago of
                        'C': begin
                                cliente.montoPagado := valor(lote.m2 , lote.precioXm2) * lote.pagoContado;   
                             end;
                        'A': begin
                                cliente.montoPagado := valor(lote.m2 , lote.precioXm2) * lote.anticipoXCuotas;   
                             end;
                   end;

                    lote.vendido := 'S';

                    seek(Flotes , posicion);
                    write(Flotes , lote);

                    seek(Fclientes , filesize(fclientes));
                    write(Fclientes , cliente);
                end
            else
                begin
                    writeln('Este lote ya ha sido vendido.');
                end;
        end
    else
        begin
            writeln('No se encontro el numero de lote solicitado.');
        end;
    readkey();
end;
procedure listado();
var
    totalRecaudado:real;
begin
    clrscr();
    totalRecaudado := 0;
    seek(Fclientes , 0);

    while(not eof(Fclientes))do
        begin
            read(Fclientes , cliente);
            writeln('Numero de lote:',cliente.numeroLote);
            writeln('Nombre del cliente:',cliente.nombre);
            writeln('Forma de pago:',cliente.formaPago);
            writeln('Monto pagado:',cliente.montoPagado:5:2);
            totalRecaudado := totalRecaudado + cliente.montoPagado;  
            writeln('');  
        end;
    
    writeln('');
    writeln('Total recaudado:$',totalRecaudado:5:2);
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
        writeln('1. Consultar lotes');
        writeln('2. Vender lote');
        writeln('3. Listado de clientes');
        writeln('4. Cargar lote');
        writeln('5. Salir');
        tecla := readkey();

        case tecla of
            '1': consultarLotes();
            '2': venderLote();
            '3': listado();
            '4': cargarLote();
            '5': cerrarArchivos();
        end;
    until (tecla = '5');    
end;
begin
    asignar();
    abrirArchivos();    
    menu();
end.