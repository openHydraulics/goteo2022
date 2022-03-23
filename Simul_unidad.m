# Simulación de distribución de caudal y presión en ramal
clear; % Elimina las variables del espacio de trabajo
close all; % Cierra las ventanas abiertas (gráficos,...)
clc; % Borra la ventana de comandos

# Se establece el valor semilla de la funcion de generacion de numeros pseudoaleatorios randn(), para que sea aleatoria.
randn('state',sum(100*clock));

addpath('src') % Ruta en la que se ubicarán los archivos con funciones

# Parámetros de la unidad (unidades en el SI, salvo indicación)
qnominal=4; % Caudal nominal en L/h
x=0.52; % Exponente ec. gasto gotero
CVm=0.05; % Coeficiente de variación de manufactura (y uso)
ng=100; % Número goteros
nr=25; % Número ramales
sg=0.5; % Separación goteros
sr=1; % Separación ramales
Dr=13.5; % Diámetro interior ramal en mm
Dpr=50; % Diámetro interior portaramal en mm
leg=0.25; % Longitud equivalente en la inserción de los goteros
ler=0.75; % Longitud equivalente en la inserción de los ramales
I0r=0.02; % Pendiente del ramal (positivo indica sentido descendente)
I0pr=0.00; % Pendiente del portaramal (positivo indica sentido descendente)
% h0=10; % Altura de presión en cabeza de la unidad

%Se calcula la distribución de presión hpR en la tubería portarramal

# Vectores para almacenar los datos de las simulaciones
h0resum=[];
CVqresum=[];
CVqhresum=[];
qreqresum=[];
qbrutresum=[];
qnetresum=[];
qdefresum=[];

tic; % Para calcular el tiempo transcurrido en la ejecución desde aquí hasta la orden toc (buscar más adelante)
info=["h0(m)","\t", "toc(s)"];
disp(info)

for h0=1:0.1:20

  k=qnominal/(100/9.806665)^x; % Coef. ec. gasto gotero para el caudal nominal

  # Distribución aleatoria variación manufactura
  varManuf=1+CVm*randn(ng,nr); % Valores aleatorios con distribución normal para simular variación manufactura
  varManuf = varManuf.*(varManuf>0); % Se evitan posibles valores de caudal negativos (no tiene sentido físico)

  [qU,hU,xU,zU] = unidad(h0, I0r, I0pr, k, x, varManuf, ng, nr, sg, sr, Dr, Dpr, leg, ler); %La función "unidad" devuelve los caudales de los goteros y la distribución de presión

  %{
  # Resultados
  qUv=reshape(qU,[1,ng*nr]);
  q_med = mean(qUv)
  desv_tip = std(qUv);
  CV = desv_tip/q_med
  %}
  
  info=[h0 toc];

  disp(info)

  qh=(k.*hU.^x);

  # Resultados
  qUv=reshape(qU,[1,ng*nr]);
  qhv=reshape(qh,[1,ng*nr]);
  CVq=std(qUv)/mean(qUv);
  CVqh=std(qhv)/mean(qhv);
  CVqm=sqrt(CVq^2-CVqh^2);

  h0resum=[h0resum h0];
  CVqresum=[CVqresum CVq];
  CVqhresum=[CVqhresum CVqh];

  qreq=prctile(qUv,25/2);
  qbrut=mean(qUv);
  qnet=mean((qUv>qreq).*qreq+(qUv<=qreq).*qUv);
  qdef=mean((qUv<qreq).*(qreq-qUv));

  qreqresum=[qreqresum qreq];
  qbrutresum=[qbrutresum qbrut];
  qnetresum=[qnetresum qnet];
  qdefresum=[qdefresum qdef];

  Ra=qnetresum./qbrutresum;
  Cd=qdefresum./qreqresum;
  relHbHreq=(1-Cd)./Ra;
  
end

CVqest=sqrt(CVqhresum.^2+CVm^2);

subplot(2,2,1)
%Se representa el coeficiente de variación del caudal CVq y el coeficiente de variación del caudal debido a la variación de presión CVqh en función de la presión en cabeza de la unidad h0
plot(h0resum,CVqresum,"+;CVq;")
grid on
hold on
xlabel('h0')
ylabel('CVq')
plot(h0resum,CVqest,"-;CVq;")
plot(h0resum,CVqhresum,"-;CVqh;")
hold off

%Se muestra en pantalla el valor de la presión en cabeza de la unidad que hace mínimo el coefciente de variación del caudal
disp("La altura de presión h0(m) que minimiza la variación del caudal debido a la presión es:")
disp(h0resum(find(CVqhresum==min(CVqhresum))))

subplot(2,2,2)
%Se representa el rendimiento de aplicación para una lámina requerida definida por la media del cuarto menor
plot(h0resum,Ra,"-;Ra;")
grid on
hold on
xlabel('h0')
ylabel('Ra, Cd')
plot(h0resum,Cd,"-;Cd;")
plot(h0resum,relHbHreq,"-;Hb/Hreq=(1-Cd)/Ra;")
hold off

subplot(2,2,3)
%Se representan los caudales neto y bruto
plot(h0resum,qreqresum,"-;qreq;")
grid on
hold on
xlabel('h0')
ylabel('qreq, qbrut')
plot(h0resum,qbrutresum,"-;qbrut;")
plot(h0resum,(qbrutresum./qreqresum),"-;qbrut/qreq;")
hold off
