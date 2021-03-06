clearvars;clc;
%OBS: ESTE ARQUIVO CONTÉM A TABELA E OS GRÁFICOS. VISÃO DE DESENVOLVEDOR.
%% Dados
e_tubo=0.55;
L=2.2; %m
d_e= 5.1; %cm
h= 20; %kcal/h-m².°C
Ts= 600; %°C
T_amb= 35; %°C
K= 35; %kcal/h-m°C
esp= 5; %mm
N= 10; %número de aletas
C= 4.88e-8; %constante Stefan-Boltzmann (kcal/h.m².K^4) 
d_a= 10.2; %cm
e_pint= 0.83;

%% Tratamento de dados:
esp_m= esp/1000;
p= 0:0.001:esp_m;
r_ext= (d_e/100)/2; %m
r_alet= (d_a/100)/2; %m
Ts_K= Ts + 273.15; %Ts em Kelvin
Tamb_K= T_amb + 273.15; %Tamb em 
deltaT= Ts-T_amb; %°C
for i=1:length(p)
       %Coeficiente da aleta:
        m(i)= sqrt((2*h)/(K*(p(i))));
        ml(i)= m(i)*(r_alet-r_ext); 
        tangh(i)= tanh(ml(i));
%         tangh(i)= (exp(1)^(ml(i))-exp(1)^(-ml(i)))/(exp(1)^(ml(i))+exp(1)^(-ml(i)));
        n(i)= tangh(i)/ml(i); %eficiência
        n_p(i)= n(i)*100; %porcentagem da eficiência
        As= 2*pi*r_ext*L; %m²
        Ar(i)= As - N*2*pi*r_ext*p(i); %m²
        Aa(i)= N*(2*pi*(r_alet^2 - r_ext^2)); %m²
        %Fluxo de calor por convecção (superfície aleatada) 
        qconv_al(i)= h*(Ar(i)+ n(i)*Aa(i))*deltaT;
        %Fluxo de calor por radiação (superfície aletada)
        qrad_al(i)= C*(Ar(i)+Aa(i))*e_tubo*(Ts_K^4 -Tamb_K^4);
        %Fluxo de calor por radiação (tubo pintado)
        qrad_pint(i)= C*As*e_pint*(Ts_K^4 -Tamb_K^4);
        %Fluxo de calor por convecção (tubo pintado)
        qconv_pint(i)= h*As*deltaT;
        %Fluxo total para cada caso
        qt_alet(i)= qconv_al(i) + qrad_al(i);
        qt_pint(i)= qconv_pint(i) + qrad_pint(i);
end
%% Gerador de tabela
P=[p]';
ML=[ml]';
EF=[n_p]';
AR=[Ar]';
AA=[Aa]';
QCONV_al=[qconv_al]';
QCONV_pint=[qconv_pint]';
QRAD_al=[qrad_al]';
QRAD_pin=[qrad_pint]';
QT_ALET=[qt_alet]';
QT_PINT=[qt_pint]';
x= table(P,ML,EF,AR,AA,QCONV_al,QCONV_pint,QRAD_al,QRAD_pin,QT_ALET,QT_PINT, 'VariableNames',{'Espessura(m)','Coeficiente da aleta','Eficiência da aleta(%)','Área não aletada(m²)','Área das aletas(m²)','q_conv-aletado (kcal/h)','q_conv-pintura (kcal/h)','q_rad-aletado (kcal/h)','q_rad-pintura (kcal/h)','qtotal- aletado (kcal/h)','qtotal-pintura (kcal/h)'})
%% Gráficos
figure (1)
plot(p,qconv_al,'LineWidth',2.5)
xlabel('Espessura (m)');
ylabel('Fluxo de calor por convecção- aletado (kcal/h)');
title('Gráfico espessura versus fluxo de calor por convecção');

figure (2)
plot(p,qconv_pint,'LineWidth',2.5);
xlabel('Espessura (m)');
ylabel('Fluxo de calor por convecção-pintura especial (kcal/h)');
title('Gráfico espessura versus fluxo de calor por convecção');

figure (3)
plot(p,qrad_al,'LineWidth',2.5);
xlabel('Espessura (m)');
ylabel('Fluxo de calor por radiação- aletado (kcal/h)');
title('Gráfico espessura versus fluxo de calor por radiação');

figure (4)
plot(p,qrad_pint,'LineWidth',2.5);
xlabel('Espessura (m)');
ylabel('Fluxo de calor por radiação - pintura especial (kcal/h)');
title('Gráfico espessura versus fluxo de calor por radiação');

figure (5)
plot(p,qt_alet,'LineWidth',2.5);
xlabel('Espessura (m)');
ylabel('Fluxo de calor total do sistema aletado (kcal/h)');
title('Gráfico espessura versus fluxo de calor total - aletas');

figure (6)
plot(p,qt_pint,'LineWidth',2.5);
xlabel('Espessura (m)');
ylabel('Fluxo de calor total da opção com pintura (kcal/h)');
title('Gráfico espessura versus fluxo de calor total da pintura especial');
