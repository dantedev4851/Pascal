Program tp2original;
Uses crt;
Const
     hexa:array[0..9]of string = ('****','***|','**|*','**||','*|**','*|*|','*||*','*|||','|***','|**|');
     Mes:array[1..12]of String = ('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
     Dia:array[0..6]of string =  ('Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado');
Type
     cad=string[10];
     timpar = array[1..4]of integer;
var
   opcion:integer;
procedure juegos;
var
   palabra,auxi,adi:cad;
   letra:char;
   posi,l:integer;



     procedure comienzo(var palabra,auxi,adi:cad;var l:integer);
     var
        i:integer;
     begin
          gotoxy(25,1);
          Textcolor(6);
          textBackground(magenta);
          highvideo;
          writeln('JUEGO DEL AHORCADO');
          normvideo;
          writeln;
          writeln('Escribe la palabra a adivinar: ');
          palabra:='';
          letra:=readkey;
          i:=0;

          repeat
                i:=i+1;
                palabra:=palabra+letra;
                write (palabra[i]);
                letra:=readkey;
                gotoxy (i,4);
                write ('*');

          until (letra='*')or (letra=#13)or (letra=#08) or(letra=#32);

          l:=length(palabra);
          auxi:=palabra;
          adi[0]:=chr(l);
          for i:=1 to l do
              adi[i]:='_';
          clrscr;
     end;

     procedure acierto(auxi:cad;var posi:integer;letra:char);
     var  n:integer;
     begin
          delete(auxi,1,posi);
          n:=posi;
          posi:=pos(letra,auxi);
          if posi<>0 then
          posi:=posi+n;
     end;
     procedure dibujo(p:integer);
     var
        parte:string[7];
        f,c:integer;
     begin
          parte:='O/I\I/\';
          case p of
               1 : begin
                        f:=1; c:=2;
                   end;
               2 : begin
                        f:=2; c:=1;
                   end;
               3 : begin
                        f:=2; c:=2;
                   end;
               4 : begin
                        f:=2; c:=3;
                   end;
               5 : begin
                        f:=3; c:=2;
                   end;
               6 : begin
                        f:=4; c:=1;
                   end;
               7 : begin
                        f:=4; c:=3;
                   end;
          end;
               gotoxy(7+c,18+f);
               write(parte[p]);
     end;

     procedure pregunta(var letra:char;var posi:integer;var adi,auxi:cad;palabra:cad);
     var
        z,p:integer;
     begin
          z:=1;
          p:=1;
               repeat
                     gotoxy(5,2);
                     Textcolor(green);
                     textBackground(black);
                     highvideo;
                     writeln('Dime una letra: ');
                     readln(letra);
                     posi:=pos(letra,palabra);
                     writeln('posicion: ',posi);
                     if posi<>0 then
                     repeat
                           adi[posi]:=letra;
                           gotoxy(10,10);
                           write(adi);
                           acierto(auxi,posi,letra);
                           writeln;
                     until (posi=0)
                     else
                         begin
                              gotoxy(3,14);
                              Textcolor(1);
                              textBackground(black);
                              HighVideo;
                              writeln('LETRAS QUE NO PERTENECEN A LA PALABRA:');
                              gotoxy(5+z,15);
                              Textcolor(white);
                              textBackground(lightblue);
                              HighVideo;
                              write(letra);
                              z:=z+2;
                              Textcolor(red);
                              textBackground(black);
                              HighVideo;;
                              dibujo(p);
                              p:=p+1;
                              normvideo;
                         end;
               until (adi=palabra) or (p=8);
               writeln;
     end;
           begin
                clrscr;
                comienzo(palabra,auxi,adi,l);
                Textcolor(6);
                textBackground(black);
                highvideo;
                write('LA PALABRA A ADIVINAR TIENE: ');
                Textcolor(white);
                textBackground(red);
                highvideo;
                write(l,' LETRAS');
                pregunta(letra,posi,adi,auxi,palabra);
                if palabra=adi then
                    begin
                         gotoxy(20,20);
                         Textcolor(6);
                         textBackground(magenta);
                         HighVideo;
                         writeln('---- HAS GANADO !!!!!');
                         normvideo;
                    end
                else
                    begin
                         writeln;
                         textcolor(cyan);
                         write('Has perdido,la palabra era: ');
                         Textcolor(yellow);
                         textBackground(green);
                         HighVideo;
                         write(palabra);
                         gotoxy(20,20);
                         Textcolor(yellow);
                         textBackground(magenta);
                         HighVideo;
                         writeln('---- AHORCADO !!!!');
                         normvideo;
                    end;
                 readkey;
                 clrscr;
           end;


procedure calculos;
var
   a,b,a1,m,d,d2,m2:integer;
   result,aux:integer;
   letra:char;

Procedure anios;
Begin
     letra:=#164;
     gotoxy(23,1);
     Textcolor(white);
     textBackground(magenta);
     highvideo;
     Writeln('CALENDARIO GREGORIANO');
     normvideo;

     Repeat
           textcolor(6);
           Writeln('Introduzca el a',letra,'o: ');
           Readln(a1);
           writeln;
           Result:=0;
           If(a1>=1600) and (a1<10000)then
               Begin
                    If (a1 mod 4 = 0)or (a1 mod 100 = 0)or (a1 mod 400 = 0) then
                        Begin
                             b:=-1;
                        End
                    Else
                        Begin
                             b:=0;
                        End;
                    If (a1>=1700) and (a1<=1799)then
                        Begin
                             a:=5;
                        End;
                    If (a1>=1800) and (a1<=1899)then
                        Begin
                             a:=3;
                        End;
                    If (a1>=1900) and (a1<=1999)then
                        Begin
                             a:=1;
                        End;
                    If (a1>=2000) and (a1<=2099)then
                        Begin
                             a:=0;
                        End;
                    If (a1>=2100) and (a1<=2199)then
                        Begin
                             a:=-2;
                        End;
                    If (a1>=2200) and (a1<=2299)then
                        Begin
                             a:=-4;
                        End;
               End
           Else
               Begin
                    Textcolor(4);
                    TextBackground(black);
                    Highvideo;
                    Writeln('Ingresaste un numero no valido.');
                    Readkey;
                    Normvideo;
                    clrscr;
               End;
     Until (a1>=1600) and (a1<10000);
End;

Procedure mesesdias;
Begin
     Repeat
           textcolor(2);
           Writeln('Ingrese el mes:');
           Readln(m);
           writeln;
           If (m>0) and (m<13)then
               Begin
                    If (m=3) or (m=5) or (m=7) or (m=8) or (m=10) or (m=12)then
                        Begin
                             b:=0;
                             Repeat
                                   textcolor(3);
                                   Writeln ('Ingrese un dia: ');
                                   Readln(d);
                                   writeln;
                                   If (d>0) and (d<32)then
                                       Begin
                                            d2:=d;
                                       End
                                   Else
                                       Begin
                                            Textcolor(4);
                                            TextBackground(black);
                                            Highvideo;
                                            Writeln ('Ingresaste un numero no valido.');
                                            Readkey;
                                            Normvideo;
                                            Clrscr;
                                       End;
                             Until (d>0) and (d<32);
                        End;
                    If (m=4) or (m=6) or (m=9) or (m=11)then
                        Begin
                             b:=0;
                             Repeat
                                   textcolor(3);
                                   Writeln('Ingrese un dia: ');
                                   Readln(d);
                                   writeln;
                                   If  (d>0) and (d<31)then
                                        Begin
                                             d2:=d;
                                        End
                                   Else
                                        Begin
                                             Textcolor(4);
                                             TextBackground(black);
                                             Highvideo;
                                             Writeln('Ingresaste un numero no valido.');
                                             Readkey;
                                             Normvideo;
                                             Clrscr;
                                        End;
                             Until (d>0) and (d<31);
                        End;
                    If (m=1) then
                        Begin
                             If (b=-1)then
                                 Begin
                                      Repeat
                                            textcolor(3);
                                            Writeln('Ingrese un dia: ');
                                            Readln(d);
                                            writeln;
                                            If (d>0) and (d<32)then
                                                Begin
                                                     d2:=d;
                                                End
                                            Else
                                                Begin
                                                     Textcolor(4);
                                                     TextBackground(black);
                                                     Highvideo;
                                                     Writeln('Ingresaste un numero no valido.');
                                                     Readkey;
                                                     Normvideo;
                                                     Clrscr;
                                                End;
                                      Until (d>0)  and (d<32);
                                 End
                             Else If (b=0)then
                                 Begin
                                      Repeat
                                            textcolor(3);
                                            Writeln('Ingrese un dia: ');
                                            Readln(d);
                                            writeln;
                                            If (d>0) and (d<32)then
                                                Begin
                                                     d2:=d;
                                                End
                                            Else
                                                Begin
                                                     Textcolor(4);
                                                     TextBackground(black);
                                                     Highvideo;
                                                     Writeln('Ingresaste un numero no valido.');
                                                     Readkey;
                                                     Normvideo;
                                                     Clrscr;
                                                End;
                                      Until (d>0)  and (d<32);
                                 End;
                        End
                    Else if (m=2)then
                             Begin
                                  If (b=-1)then
                                      Begin
                                           Repeat
                                                 textcolor(3);
                                                 Writeln('Ingrese un dia: ');
                                                 Readln(d);
                                                 writeln;
                                                 If (d>0) and (d<30)then
                                                     Begin
                                                          d2:=d;
                                                     End
                                                 Else
                                                     Begin
                                                          Textcolor(4);
                                                          TextBackground(black);
                                                          Highvideo;
                                                          Writeln('Ingresaste un numero no valido.');
                                                          Readkey;
                                                          Normvideo;
                                                          Clrscr;
                                                     End;
                                           Until (d>0) and (d<30);
                                      End
                                  Else if(b=0)then
                                          Begin
                                               Repeat
                                                     textcolor(3);
                                                     writeln('Ingrese un dia: ');
                                                     readln(d);
                                                     writeln;
                                                     If (d>0) and (d<29)then
                                                         Begin
                                                              d2:=d;
                                                         End
                                                     Else
                                                         Begin
                                                              Textcolor(4);
                                                              TextBackground(black);
                                                              Highvideo;
                                                              Writeln('Ingresaste un numero no valido.');
                                                              Readkey;
                                                              Normvideo;
                                                              Clrscr;
                                                         End;
                                               Until (d>0) and (d<29);
                                          End;
                    End;
               End
           Else
               Begin
                    Textcolor(4);
                    TextBackground(black);
                    Highvideo;
                    Writeln('Ingresaste un numero no valido.');
                    Readkey;
                    Normvideo;
                    Clrscr;
               End;

     Until (m>0) and (m<13);
End;

Procedure valoresm2;
Begin
     clrscr;
     if (m=1) or (m=10)then
         begin
              m2:=6;
         end;

     if (m=2) or (m=3) or (m=11)then
         begin
              m2:=2;
         end;

     if (m=4) or (m=7)then
         begin
              m2:=5;
         end;

     if (m=5)then
         begin
              m2:=0;
         end;

     if (m=6)then
         begin
              m2:=3;
         end;

     if (m=8)then
         begin
              m2:=1;
         end;

     if (m=9) or (m=12)then
         begin
              m2:=4;
         end;
End;

Procedure calculos2(var result:integer;a1,a,m2,b,d2:integer);
var
   a2,a3:integer;
   result2:integer;
   n2:integer;


   begin
        result2:=0;
        n2:=7;
        a2:= (a1 mod 100);
        a3:= a2+trunc(a2 div 4);
        result2:=a+a3+b+m2+d2;

             If (result2>=0) and (result2<=6) then
                 Begin
                      result:=result2;
                 End
             Else
                 Begin
                      result:=result2-n2;
                 End;

                 while (result<>0) and (result <>1) and (result<>2)and (result <>3)and (result<>4)and (result <>5)and (result<>6) do
                 Begin
                      result:=result-n2;
                 End;
   End;
   Begin
        anios;
        mesesdias;
        valoresm2;
        calculos2(result,a1,a,m2,b,d2);
        aux:=result;

        Textcolor(yellow);
        textBackground(black);
        highvideo;
        write('El ',d2,' de ',mes[m],' de ',a1,' es: ');
        Textcolor(white);
        textBackground(lightblue);
        highvideo;
        write(dia[aux]);
        readln;
        normvideo;
        clrscr;

   End;


   Procedure codigodebarra;
   Var
      aux1,aux3,aux5,aux7:integer;
      aux2,aux4,aux6:integer;
      impar:timpar;
      par:timpar;

      Procedure Empresa;
      Var
         codemp:integer;
      Begin
           gotoxy(23,1);
           Textcolor(yellow);
           textBackground(cyan);
           highvideo;
           Writeln('CODIGO DE BARRAS');
           normvideo;
           writeln;

           Repeat
                 Textcolor(Brown);
                 writeln('Ingrese el codigo de empresa(3 digitos): ');
                 readln(codemp);
                 writeln;

                 If (codemp>0) and (codemp<1000)then
                     Begin
                          aux1:= trunc(codemp div 100);
                          aux2:= (trunc(codemp div 10))mod 10;
                          aux3:= (codemp mod 100) mod 10;
                     End
                 Else
                     Begin
                          Textcolor(4);
                          TextBackground(black);
                          Highvideo;
                          Writeln('Ingresaste un numero no valido.');
                          Readkey;
                          Normvideo;
                          Clrscr;
                     End;

           Until (codemp>0) and (codemp<1000);
      End;

      Procedure Importe;
      Var
         importe:integer;
      Begin
           Repeat
                 textcolor(2);
                 writeln('Ingrese el importe (4 digitos) : ');
                 readln(importe);
                 normvideo;

                 If (importe>=0) and (importe<10000)then
                     Begin
                          aux4:= trunc(importe div 1000);
                          aux5:= trunc(importe div 100)mod 10;
                          aux6:=(trunc(importe div 10))mod 10;
                          aux7:=(importe)mod 10;
                     End
                 Else
                     Begin
                          Textcolor(4);
                          textBackground(black);
                          highvideo;
                          writeln('Ingresaste un numero no valido.');
                          readkey;
                          normvideo;
                          clrscr;
                     End;
           Until (importe>=0) and (importe<10000);
      End;

      Procedure paresimpares;
      Begin
           impar[1]:=aux1; par[1]:=aux2;
           impar[2]:=aux3; par[2]:=aux4;
           impar[3]:=aux5; par[3]:=aux6;
           impar[4]:=aux7;
      End;

      Function Resultado(impar,par:timpar):integer;
      Var
         impares:integer;
         pares:integer;
      Begin
           impares:= impar[1]+impar[2]+impar[3]+impar[4];
           pares:= par[1]+par[2]+par[3];
           resultado:= trunc((abs(pares-impares))div 10);
      End;

      Procedure Codigo(impar,par:timpar);
      Var
         i:integer;
      Begin
           Clrscr;
           i:=0;
           textcolor(green);
           highvideo;
           Write('El codigo de barra es: ');
           textcolor(white);
           textbackground(5);

           While impar[1]<>i do
                 Begin
                      i:=i+1;
                 End;
           If (impar[1]=i)then
              Write(hexa[i]);

           i:=0;
           While par[1]<>i do
                 Begin
                      i:=i+1;
                 End;
           If (par[1]=i)then
              Write(hexa[i]);

           i:=0;
           While impar[2]<>i do
                 Begin
                      i:=i+1;
                 End;
           If (impar[2]=i)then
              Write(hexa[i]);

           i:=0;
           While Par[2]<>i do
                 Begin
                      i:=i+1;
                 End;
           If (par[2]=i)then
              Write(hexa[i]);

           i:=0;
           While impar[3]<>i do
                 Begin
                      i:=i+1;
                 End;
           If (impar[3]=i)then
              Write(hexa[i]);

           i:=0;
           While par[3]<>i do
                 Begin
                      i:=i+1;
                 End;
           If (par[3]=i)then
              Write(hexa[i]);

           i:=0;
           While impar[4]<>i do
                 Begin
                      i:=i+1;
                 End;
           If (impar[4]=i)then
              Write(hexa[i]);

           i:=0;
           While Par[4]<>i do
                 Begin
                      i:=i+1;
                 End;
           If (par[4]=i)then
              Write(hexa[i]);
              Readln;
              Normvideo;
      End;



      Begin
           Empresa;
           Importe;
           Paresimpares;
           par[4]:=resultado(impar,par);
           Codigo(impar,par);
           clrscr;

      End;

Begin
     Repeat
           Gotoxy(23,1);
           Textcolor(15);
           textBackground(green);
           highvideo;
           Writeln('MENU DE OPCIONES');
           Textcolor(4);
           textBackground(black);
           highvideo;
           Writeln('1. Juegos');
           Textcolor(3);
           highvideo;
           textBackground(black);
           Writeln('2. Calculos');
           Textcolor(6);
           textBackground(black);
           highvideo;
           Writeln('3. Codigo de barras');
           Textcolor(1);
           textBackground(black);
           highvideo;
           Writeln('4. Fin');
           normvideo;
           Readln(opcion);
           CLRSCR;

           If(opcion>=1)and (opcion<=4)then

               Case opcion of
                    1: juegos;
                    2: calculos;
                    3: codigodebarra;
                    4: Exit;
               End
           Else
               Begin
                    Textcolor(4);
                    textBackground(black);
                    highvideo;
                    writeln('Ingrese una opcion valida.');
                    readkey;
                    normvideo;
                    clrscr;
               End;
     Until (opcion=4);
End.
