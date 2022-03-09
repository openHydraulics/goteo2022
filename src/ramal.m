%Función que calcula la distribución de caudales de los emisores de un ramal

function [q, h, xR, zR] = ramal(h0, I0, k, x, varManuf, n, s, D, le)
  vectorUnos=ones(n,1);
  matrizAcum=triu(ones(n),0);

  %Distancia al origen y cota de cada emisor
  xR=transpose(matrizAcum)*(s.*vectorUnos);
  zR=-I0.*xR;
  
  %Distribución de presión inicial para comenzar el cálculo
  h=h0.*vectorUnos;
  hant=0.*vectorUnos;
  
  while abs(h(end)-hant(end))>1e-3;
    hant=h;
    q=k.*h.^x.*varManuf;
    
    %Las pérdidas de carga se calculan con Blasius, viscosidad a 20ºC y longitud equivalente en las inserciones de ramal
    h=h0.*vectorUnos-zR-transpose(matrizAcum)*(0.465.*(matrizAcum*q).^1.75.*D.^-4.75.*(le+s));
  end
endfunction