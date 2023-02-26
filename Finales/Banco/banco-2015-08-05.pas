program final_banco;
uses crt;
type
    regCliente = record
            dni:string[16];
            nya:string[40];
            cbu:integer;
        end;
    regSaldo = record
            cbu:integer;
            clave:string[16];
            saldoActual:real;
        end;
var
    fclientes:file of regCliente;
    cliente:regCliente;

    fsaldos:file of regSaldo;
    saldo:regSaldo;
    
    identificado:boolean;
    posicionID:integer;
function validarRequisitos(valor1:char; valor2:char;password:string):boolean;
var
    i:integer;
begin
    validarRequisitos := false;
    i := 0;
    repeat
        inc(i);
        if((password[i] >= valor1) and (password[i] <= valor2))then
                validarRequisitos := true;
    until ((validarRequisitos = true) or (length(password) = i));
end;
function verificarClave(password:string):boolean;
begin
    verificarClave := false;
    if((length(password) >= 4) and (length(password) <= 16))then
        if(validarRequisitos('A','Z',password))then
            if(validarRequisitos('a','z',password))then
                if(validarRequisitos('0','9',password))then
                    verificarClave := true;
end;
function buscarDni(dato:string):integer;
var
    inf,sup,med:integer;
begin
    buscarDni := -1;
    inf := 0;
    sup := filesize(fclientes) - 1 ;

    repeat
        med := (inf + sup) div 2;
        seek(fclientes , med);
        read(fclientes , cliente);

        if(cliente.dni = dato)then
            buscarDni := med
        else if(cliente.dni > dato)then
            sup := med - 1
        else
            inf := med + 1;
    until ((buscarDni <> -1) or (inf > sup));
end;
function buscarCbu(dato:integer):integer;
var
    inf,sup,med:integer;
begin
    buscarCbu := -1;
    inf := 0;
    sup := filesize(fsaldos) - 1 ;

    repeat
        med := (inf + sup) div 2;
        seek(fsaldos , med);
        read(fsaldos , saldo);

        if(saldo.cbu = dato)then
            buscarCbu := med
        else if(saldo.cbu > dato)then
            sup := med - 1
        else
            inf := med + 1;
    until ((buscarCbu <> -1) or (inf > sup));
end;
function verificarDatos(numero:integer;password:string):integer;
var
    inf,sup,med:integer;
begin
    verificarDatos := -1;
    inf := 0; 
    sup := filesize(fsaldos) - 1; 

    repeat
        med := (inf + sup) div 2;
        seek(fsaldos , med);
        read(fsaldos , saldo);

        if((saldo.cbu = numero) and (saldo.clave = password))then
            verificarDatos := med
        else if(saldo.cbu > numero)then
            sup := med - 1
        else
            inf := med + 1; 
    until ((verificarDatos <> -1) or (inf > sup));  
end;
procedure asignar();
begin
    assign(fclientes , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Banco\clientes.dat');
    assign(fsaldos , 'C:\DEV\Pascal\2022\Archivos2022\Finales\Banco\saldos.dat');
end;
procedure abrirArchivos();
begin
    {$I-} reset(fclientes);{$I+}
    if(ioresult = 2)then
        rewrite(fclientes);
    {$I-} reset(fsaldos);{$I+}
    if(ioresult = 2)then
        rewrite(fsaldos);
end;
procedure cerrarArchivos();
begin
    close(fclientes);
    close(fsaldos);
end;
procedure ordenarClientes();
var
    i,j:integer;
    aux,copia:regCliente;
begin
    for i := 0 to filesize(fclientes) - 1 do
            for j := 0 to filesize(fclientes) - 2 do
                begin
                    seek(fclientes , j);
                    read(fclientes , cliente);

                    seek(fclientes , j + 1);
                    read(fclientes , copia);

                    if(cliente.dni > copia.dni)then
                        begin
                            aux := cliente;
                            cliente := copia;
                            copia := aux;

                            seek(fclientes , j);
                            write(fclientes , cliente);	
                            seek(fclientes , j + 1);
                            write(fclientes , copia);	
                        end;
                end;
end;
procedure ordenarSaldos();
var
    i,j:integer;
    aux,copia:regSaldo;
begin
    for i := 0 to filesize(fsaldos) - 1 do
            for j := 0 to filesize(fsaldos) - 2 do
                begin
                    seek(fsaldos , j);
                    read(fsaldos , saldo);

                    seek(fsaldos , j + 1);
                    read(fsaldos , copia);

                    if(saldo.cbu > copia.cbu)then
                        begin
                            aux := saldo;
                            saldo := copia;
                            copia := aux;

                            seek(fsaldos , j);
                            write(fsaldos , saldo);	
                            seek(fsaldos , j + 1);
                            write(fsaldos , copia);	
                        end;
                end;
end;
procedure cargarDatos();
var
    tecla:char;
    clave:string[16];
    intentos:integer;
begin
    tecla := 'c';
    intentos := 0;
    while(tecla = 'c')do
        begin
            clrscr();
            write('Dni:');
            readln(cliente.dni);
            write('Nombre y apellido:');
            readln(cliente.nya);
            write('CBU:');
            readln(cliente.cbu);
            
            saldo.cbu := cliente.cbu;
            
            repeat
                clrscr();
                writeln('La clave tiene que tener al menos una letra Mayuscula, una letra minuscula y un digito:');
                write('Clave:');
                readln(clave);
                inc(intentos);

                if(verificarClave(clave) = true)then
                    begin
                        saldo.clave := clave;
                        saldo.saldoActual := 0;

                        seek(fclientes , filesize(fclientes));
                        write(fclientes , cliente);
                        seek(fsaldos , filesize(fsaldos));
                        write(fsaldos , saldo);
                        clrscr();
                        writeln('!!Datos cargados con exito!!');
                        readkey();
                    end
                else
                    begin
                        clrscr();
                        writeln('Ingresaste una clave no permitida');
                        writeln('Los datos no han sido cargados.');
                        writeln('Intentos ',intentos,' de 3.');
                        readkey();
                    end;
            until ((verificarClave(clave) = true) or (intentos = 3));
            writeln('Desea continuar o finalizar?');
            
            tecla := readkey();
        end;
    ordenarClientes();
    ordenarSaldos();
end;
procedure identificarse();
var
    dni:string[8];
    clave:string[16];
    intentos:integer;
begin
    clrscr();
    intentos := 0;
    if(not(identificado))then
        begin
            write('Dni:');
            readln(dni);

            posicionID := buscarDni(dni);

            if(posicionID <> -1)then
                begin
                    seek(fclientes , posicionID);
                    read(fclientes , cliente);

                    repeat
                        write('Clave:');
                        readln(clave);
                        inc(intentos);

                        if(verificarClave(clave))then
                            begin
                                if(verificarDatos(cliente.cbu , clave) <> -1)then
                                    begin
                                        clrscr();
                                        identificado := true;
                                        writeln('!!Se ha dentificado con exito!!');
                                        readkey();
                                    end
                                else
                                    begin
                                        clrscr();
                                        writeln('No coinciden los datos');
                                        readkey();
                                    end;
                            end
                        else
                            begin
                                clrscr();
                                writeln('Ingresaste una clave no permitida');
                                writeln('Intentos ',intentos,' de 3.');
                                readkey();
                            end;
                    until ((identificado = true) or (intentos = 3));
                end
            else
                begin
                    clrscr();
                    write('No se encontro el dni ingresado');
                    readkey();
                end;
        end
    else
        begin
            writeln('Ya se encuentra identificado.');
            readkey();
        end;
end;
procedure depositar();
var
    dni:string[8];
    monto:real;
    posicion:integer;
begin
    clrscr(); 
    write('Dni:');   
    readln(dni);
    posicion := buscarDni(dni);

    if(posicion <> -1)then
        begin
            seek(fclientes , posicion);
            read(fclientes , cliente);

            writeln('Nombre y apellido:',cliente.nya);
            writeln('');
            writeln('Ingrese monto a depositar:');
            readln(monto);

            posicion := buscarCbu(cliente.cbu);

            seek(fsaldos , posicion);
            read(fsaldos , saldo);

            saldo.saldoActual := saldo.saldoActual + monto;

            seek(fsaldos , posicion);
            write(fsaldos , saldo);

            writeln('Operacion realizada con exito!!');
        end
    else
        begin
            clrscr();
            writeln('Ingresaste un dni no existente.');
        end;
    readkey();
end;
procedure extraer();
var
    monto:real;
    clave:string[16];
    intentos:integer;
begin
    intentos := 0;
    clrscr();
    if(not(identificado))then
        begin
            writeln('Para realizar esta operacion debe identificarse');
            readkey();
            identificarse();
        end;
    
    write('Monto a retirar:');
    readln(monto);

    seek(fclientes , posicionID );
    read(fclientes , cliente);

    repeat
        inc(intentos);
        write('Ingrese clave para confirmar:');
        readln(clave);
    
        if(verificarClave(clave))then
            if(verificarDatos(cliente.cbu , clave)<> -1)then
                begin
                    clrscr();
                    seek(fsaldos , verificarDatos(cliente.cbu , clave));
                    read(fsaldos , saldo);
                    
                    if(saldo.saldoActual < monto)then
                        begin
                            writeln('No posee dinero suficiente para realizar esta operacion');
                            writeln('Saldo actual:$',saldo.saldoActual:5:2);
                        end
                    else
                        begin
                            saldo.saldoActual := saldo.saldoActual - monto;
                            seek(fsaldos , verificarDatos(cliente.cbu , clave));
                            write(fsaldos , saldo);
                            writeln('Operacion realizada con exito!!');
                        end;
                end
        else
            begin
                clrscr();
                writeln('Ingresaste una clave no permitida');
                writeln('Intentos ',intentos,' de 3.');
            end;
        readkey();
    until ((verificarDatos(cliente.cbu , clave) <> -1) or (intentos = 3));

    if(intentos = 3)then
        begin
            clrscr();
            writeln('Superaste los intentos permitidos');
            writeln('por lo tanto , no se pudo realizar la extraccion');
            identificado := false;
            readkey();
        end;
end;
procedure movimientos();
var
    tecla:char;
begin
    repeat
        clrscr();
        writeln('A - Deposito');
        writeln('B - Extraccion');
        writeln('C - Salir');
        tecla := readkey();

        case tecla of
            'A': depositar();
            'B': extraer();
            'C': identificado := false;
        end;
    until (tecla = 'C');
end;
procedure consultarSaldo();
begin
    clrscr();
    if(not(identificado))then
        begin
            writeln('Para realizar esta operacion debe identificarse');
            readkey();
            identificarse();
        end
    else
        begin
            seek(fclientes , posicionID);
            read(fclientes , cliente);

            if(buscarCbu(cliente.cbu) <> -1)then
                begin
                    seek(fsaldos , buscarCbu(cliente.cbu));
                    read(fsaldos ,saldo);
                    writeln('Saldo actual:$',saldo.saldoActual:5:2);
                    readkey();
                end;            
        end;
end;
procedure menu();
var
    tecla:char;
begin
    repeat
        clrscr();
        writeln('           MENU');
        writeln('');
        writeln('1. Identificarse');
        writeln('2. Consultar saldo');
        writeln('3. Movimientos');
        writeln('4. Cargar cliente y saldos');
        writeln('5. Salir');
        tecla := readkey();

        case tecla of
            '1': identificarse();
            '2': consultarSaldo();
            '3': movimientos();
            '4': cargarDatos();
            '5': cerrarArchivos();
        end;
    until (tecla = '5');
end;
begin // ppal
    identificado := false;
    asignar();
    abrirArchivos();
    menu();
end.