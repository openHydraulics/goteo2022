# Simulación de distribución de caudal y presión en ramal
clear; % Elimina las variables del espacio de trabajo
close all; % Cierra las ventanas abiertas (gráficos,...)
clc; % Borra la ventana de comandos

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
I0pr=0.0; % Pendiente del portaramal (positivo indica sentido descendente)
h0=10; % Altura de presión en cabeza de la unidad

k=qnominal/(100/9.806665)^x; % Coef. ec. gasto gotero para el caudal nominal

# Distribución aleatoria variación manufactura
varManuf=1+CVm*randn(ng,nr); % Valores aleatorios con distribución normal para simular variación manufactura
varManuf = varManuf.*(varManuf>0); % Se evitan posibles valores de caudal negativos (no tiene sentido físico)

[qU,hU,xU,zU] = unidad(h0, I0r, I0pr, k, x, varManuf, ng, nr, sg, sr, Dr, Dpr, leg, ler); %La función "unidad" devuelve los caudales de los goteros y la distribución de presión

# Resultados
qUv=reshape(qU,[1,ng*nr]);
q_med = mean(qUv)
desv_tip = std(qUv);
CV = desv_tip/q_med

# Representación
[ax,h1,h2]=plotyy(xU,hU,xU,qU);
set (h1, "linestyle", "-", "color", "red"); % Se define el tipo de línea
set (h2, "linestyle", "none", "marker", "*", "color", "blue"); % Se define el tipo de marcador
set (ax, {'ycolor'}, {'r';'b'}); % Se define el color de los ejes de ordenadas
xlabel('x(m)')
ylabel(ax(1),'h(m)', "color", "red")
ylabel(ax(2),'q(L/h)', "color", "blue") 