# Función que calcula los caudales de los emisores de una unidad

function [qU,hU,xU,zU]=unidad(h0, I0r, I0pr, k, x, varManuf, ng, nr, sg, sr, Dr, Dpr, leg, ler)
  
  vectorUnos=ones(1,nr);
  matrizAcum=triu(ones(nr),0);

  xpr=(sr.*vectorUnos)*matrizAcum;
  zpr=-I0pr.*xpr;

  hpr=h0.*vectorUnos;
  hprant=0.*vectorUnos;

  %Se calcula iterativamente la distribución de presión en el portarramal 
  while max(abs(hpr-hprant))>1e-3;
    hprant=hpr;
    
    %Se llama a la función ramal.m para, dado una presión en cabeza de un ramal, calcular la distribución de presiones
    for j=nr:-1:1
      %Presiones y caudales en los goteros del ramal j
      [qr,hr,xr,zr]=ramal(hprant(j),I0r,k,x,varManuf(:,j),ng,sg,Dr,leg);
      hU(:,nr+1-j)=hr;%Matriz de presiones en los goteros de la unidad
      qU(:,nr+1-j)=qr;%Matriz de caudales de los goteros de la unidad
      xU(:,nr+1-j)=xr;
      zU(:,nr+1-j)=zr;
    endfor

    %Caudal en los tramos de la tubeŕia portarramal
    Qpr=(ones(1,ng)*qU)*transpose(matrizAcum);
    hpr=h0.*vectorUnos-zpr-(0.465.*Qpr.^1.75.*Dpr.^-4.75.*(ler+sr))*matrizAcum;
    
  endwhile
    
endfunction
