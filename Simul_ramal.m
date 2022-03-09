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
s=0.5; % Separación goteros
D=13.5; % Diámetro interior ramal en mm
le=0.25; % Longitud equivalente en la inserción de los ramales
I0=0.02; % Pendiente del ramal (positivo indica sentido descendente)
h0=10; % Altura de presión en cabeza del ramal

k=qnominal/(100/9.806665)^x; % Coef. ec. gasto gotero para el caudal nominal

# Distribución aleatoria variación manufactura
varManuf=1+CVm*randn(ng,1); % Valores aleatorios con distribución normal para simular variación manufactura
varManuf = varManuf.*(varManuf>0); % Se evitan posibles valores de caudal negativos (no tiene sentido físico)

[q,h,xR,zR] = ramal(h0, I0, k, x, varManuf, ng, s, D, le); %La función "ramal" devuelve los caudales de los goteros y la distribución de presión

# Resultados
q_med = mean(q)
desv_tip = std(q);
CV = desv_tip/q_med

# Representación
[ax,h1,h2]=plotyy(xR,h,xR,q);
set (h1, "linestyle", "-", "color", "red"); % Se define el tipo de línea
set (h2, "linestyle", "none", "marker", "*", "color", "blue"); % Se define el tipo de marcador
set (ax, {'ycolor'}, {'r';'b'}); % Se define el color de los ejes de ordenadas
xlabel('x(m)')
ylabel(ax(1),'h(m)', "color", "red")
ylabel(ax(2),'q(L/h)', "color", "blue") 