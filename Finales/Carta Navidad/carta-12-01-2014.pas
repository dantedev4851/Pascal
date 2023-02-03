program final_carta_navidad;
uses crt;
const
    MAXIMO = 3;
type
    regCarta = record
            nombre:string[20];
            mailAdulto:string[45];
            pedido:array[1..3] of string[30];
            codigoJuguete:array[1..3] of integer;
        end;
    regJuguete = record
            codigo:integer;
            nombre:string[25];
            stock:integer;
            precio:real;
        end;
var
    Fcartas:file of regCarta;
    carta:regCarta;
    Fjuguetes:file of regJuguete;
    juguete:regJuguete;
function buscarJuguete(dato:integer):integer;
var
    inf,med,sup:integer;
begin
    buscarJuguete := -1;
    inf := 0;
    sup := filesize(Fjuguetes) - 1;

    repeat
        med := (inf + sup) div 2;
        seek(Fjuguetes , med);
        read(Fjuguetes , juguete);

        if(juguete.codigo = dato)then
            begin
                buscarJuguete := med;
            end
        else if(juguete.codigo > dato)then
            begin
                sup := med - 1;	
            end
        else
            begin
                inf := med + 1;
            end;
    until ((buscarJuguete <> -1) or (inf > sup));
end;
procedure asignar();
begin
    assign(Fcartas, 'C:\DEV\Pascal\2022\Archivos2022\Finales\Carta Navidad\cartas.dat');
    assign(Fjuguetes , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Carta Navidad\juguetes.dat');    
end;
procedure abrirArchivos();
begin
    {$I-}reset(Fcartas);{$I+}
    if(ioresult = 2)then
        begin
            rewrite(Fcartas);	
        end;
    {$I-}reset(Fjuguetes);{$I+}
    if(ioresult = 2)then
        begin
            rewrite(Fjuguetes);	
        end;
end;
procedure cerrarArchivos();
begin
    close(Fcartas);
    close(Fjuguetes);
end;
procedure cargarCartas();
var
    tecla:char;
    i:integer;
begin
    tecla := 'c';

    while((tecla = 'c') and (filesize(Fcartas)<> MAXIMO))do
        begin
            clrscr();
            write('Nombre del ninio:');
            readln(carta.nombre);
            write('Mail del adulto:');
            readln(carta.mailAdulto);
            writeln('Detalles de los juguete:');
            for i := 1 to 3 do
                begin
                    write('Juguete',i,':');
                    readln(carta.pedido[i]);
                end;
            seek(Fcartas , filesize(Fcartas));
            write(Fcartas , carta);

            writeln('Desea finalizar o continuar?');
            tecla := readkey();
        end;    
    
    if(filesize(Fcartas) = MAXIMO)then
        begin
            clrscr();
            write('Se llego al limite maximo de cargas.');
            readkey();
        end;
end;
procedure administrarStock();
var
    i:integer;
begin
    clrscr();
    seek(Fcartas , 0);
    while(not eof(Fcartas))do
        begin
            read(Fcartas , carta);
            for i := 1 to 3 do
                begin
                    write('Codigo del juguete ',i,':');
                    readln(carta.codigoJuguete[i]);
                end;    
            seek(Fcartas , filepos(Fcartas) - 1);
            write(Fcartas , carta);
        end;
end;
procedure disponibilidad();
var
    i:integer;
    posicion:integer;
begin
    clrscr();
    seek(Fcartas , 0);

    while(not eof(Fcartas))do
        begin
            read(Fcartas , carta);
            for i := 1 to 3 do
                begin
                    posicion := buscarJuguete(carta.codigoJuguete[i]);
                    if(posicion <> -1)then
                        begin
                            writeln('Papas de ',carta.nombre,' informamos que:');
                            write('Juguete',i,':',carta.pedido[i]);
                            seek(Fjuguetes , posicion);
                            read(Fjuguetes , juguete);
                            writeln('- se llama ',juguete.nombre,' - hay un stock de ',juguete.stock,' y su valor es:$',juguete.precio:5:2);	
                        end
                end;    
        end;
    readkey();
end;
procedure ordenarJuguetes(); // por codigo ascendente
var
    i,j:integer;
    aux,copia:regJuguete;
begin
    for i := 0 to filesize(Fjuguetes) - 1 do
        begin
            for j := 0 to filesize(Fjuguetes) - 2 do
                begin
                    seek(Fjuguetes , j);
                    read(Fjuguetes , juguete);
                    seek(Fjuguetes , j + 1);
                    read(Fjuguetes , copia);

                    if(juguete.codigo > copia.codigo)then
                        begin
                            aux := juguete;
                            juguete := copia;
                            copia := aux;

                            seek(Fjuguetes , j);
                            write(Fjuguetes , juguete);

                            seek(Fjuguetes , j + 1); 
                            write(Fjuguetes , copia);	
                        end;
                end;
        end;
end;
procedure cargarJuguetes();
var
    tecla:char;
begin
    tecla := 'c';
    while(tecla = 'c')do
        begin
            clrscr();
            write('Nombre del juguete:');
            readln(juguete.nombre);
            write('Codigo:');
            readln(juguete.codigo);
            write('Stock:');
            readln(juguete.stock);
            write('Precio:');
            readln(juguete.precio);

            seek(Fjuguetes , filesize(Fjuguetes));
            write(Fjuguetes , juguete);

            write('Desea continuar o finalizar?');
            tecla := readkey();
        end;
    
    ordenarJuguetes();
end;
procedure menu();
var
    tecla:char;
begin
    repeat
        clrscr();
        writeln('               MENU');
        writeln('');
        writeln('1. Cargar cartas');
        writeln('2. Administrar stock');
        writeln('3. Comunicar disponibilidad');
        writeln('4. Cargar Juguetes');
        writeln('5. Salir');
        tecla := readkey();

        case tecla of
            '1': cargarCartas();
            '2': administrarStock();
            '3': disponibilidad();
            '4': cargarJuguetes();
            '5': cerrarArchivos();
        end;
    until (tecla = '5');
end;
begin
    asignar();
    abrirArchivos();
    menu();
end.