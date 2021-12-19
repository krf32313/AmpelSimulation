clc;
close;
clear;

dichte = 0:0.1:1;
laenge1 =3000;
laenge2 =3000;
iter = 2000;
v_max1 = 5;
v_max2 = 5;
p_troedel1 = 0.2;
p_troedel2 = 0.2;
ampel1 = 1500;
ampel2 = 1500;
t_gruen_Ampel1 = 120;
t_gruen_Ampel2 = 20;

% Messintervall
%TODO: Messintervall?
x_min1=1450;
x_max1=1550;
x_min2=1450;
x_max2=1550;

% berechne Daten (Geschwindigkeit bzw. Fluss über Dichte in einem Messintervall) 
[B1,B2] = berechneStrasse(dichte, x_min1, x_min2, x_max1, x_max2, laenge1, laenge2, iter, v_max1, v_max2, p_troedel1, p_troedel2, ampel1, ampel2, t_gruen_Ampel1, t_gruen_Ampel2);

f_max = max(max(B1.mean_Var3), max(B2.mean_Var3));
v_max = max(v_max1, v_max2);

% Slider

%f = figure;
%f.Position = [50 50 700 700];
%ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);
%sys = berechneStrasse(dichte, x_min1, x_min2, x_max1, x_max2, laenge1, laenge2, iter, v_max1, v_max2, p_troedel1, p_troedel2, ampel1, ampel2, t_gruen_Ampel1, t_gruen_Ampel2); 
%h = stepplot(sys);

%slider1 = uicontrol('Parent',f,'Style','slider','Position',[110,320,200,25],'value',t_gruen_Ampel1, 'min',20, 'max',120);

%slider2 = uicontrol('Parent',f,'Style','slider','Position',[420,320,200,25],'value',t_gruen_Ampel2, 'min',20, 'max',120);

%slider1.Callback = @(gruen1, gruen2) updateSystem(h,berechneStrasse(dichte, x_min1, x_min2, x_max1, x_max2, laenge1, laenge2, iter, v_max1, v_max2, p_troedel1, p_troedel2, ampel1, ampel2, gruen1.Value, gruen2.Value)); 
%slider2.Callback = @(gruen1, gruen2) updateSystem(h,berechneStrasse(dichte, x_min1, x_min2, x_max1, x_max2, laenge1, laenge2, iter, v_max1, v_max2, p_troedel1, p_troedel2, ampel1, ampel2, gruen1.Value, gruen2.Value)); 

% und plotten
subplot(2,2,1);
plot(B1.Var1,B1.mean_Var2)
title('Straße 1: ')
subtitle({['Starte in Grünphase' ] 
    ['Länge = ' num2str(laenge1) ] 
    ['t(Grün) = ' num2str(t_gruen_Ampel1) '   t(Rot) = ' num2str(t_gruen_Ampel2)  ]
    });
ylabel("Geschwindigkeit")
xlabel("Dichte")
ylim([0,v_max]);

subplot(2,2,3); 
plot(B1.Var1,B1.mean_Var3)
ylabel("Fluss")
xlabel("Dichte")
ylim([0,f_max])
 
subplot(2,2,2);
plot(B2.Var1,B2.mean_Var2)
title('Straße 2: ')
subtitle({['Starte in Rotphase' ] 
    ['Länge = ' num2str(laenge2) ] 
    ['t(Grün) = ' num2str(t_gruen_Ampel2) '   t(Rot) = ' num2str(t_gruen_Ampel1)  ]
    });
ylabel("Geschwindigkeit")
xlabel("Dichte")
ylim([0,v_max]);

subplot(2,2,4); 
plot(B2.Var1,B2.mean_Var3)
ylabel("Fluss")
xlabel("Dichte")
ylim([0,f_max])

function [B1, B2] = berechneStrasse(dichte, x_min1, x_min2, x_max1, x_max2, laenge1, laenge2, iter, v_max1, v_max2, p_troedel1, p_troedel2, ampel1, ampel2, t_gruen_Ampel1, t_gruen_Ampel2)
t_rot_Ampel1 = t_gruen_Ampel2;
t_rot_Ampel2 = t_gruen_Ampel1;

r_lokal1=[];
v_lokal1=[];
f_lokal1=[];

r_lokal2=[];
v_lokal2=[];
f_lokal2=[];

for r = dichte
    %Ringstraße 1
    [ind1,val1] = Ampel_Nagel_Schreck(r, laenge1, iter, v_max1, p_troedel1, ampel1, t_gruen_Ampel1, t_rot_Ampel1);
    
    % Messintervall in Daten kennzeichnen
    intervall1 = ind1>=x_min1 & ind1<x_max1;
    
    % lokale Dichte und Geschwindigkeiten filtern
    r_lokal1 = [r_lokal1 sum(intervall1)/ (x_max1-x_min1)];
    v_lokal1 = [v_lokal1 sum(intervall1 .* val1) / (x_max1-x_min1)];
    
    % Fluss über x_min Grenze bestimmen
    f_lokal1 = [f_lokal1 sum(ind1>=x_min1 & circshift(ind1,1,2)<x_min1)];

    %Ringstraße 2
    [ind2,val2] = Starte_rote_Ampel_Nagel_Schreck(r, laenge2, iter, v_max2, p_troedel2, ampel2, t_gruen_Ampel2, t_rot_Ampel2);
    
    % Messintervall in Daten kennzeichnen
    intervall2 = ind2>=x_min2 & ind2<x_max2;
    
    % lokale Dichte und Geschwindigkeiten filtern
    r_lokal2 = [r_lokal2 sum(intervall2)/ (x_max2-x_min2)];
    v_lokal2 = [v_lokal2 sum(intervall2 .* val2) / (x_max2-x_min2)];
    
    % Fluss über x_min Grenze bestimmen
    f_lokal2 = [f_lokal2 sum(ind2>=x_min2 & circshift(ind2,1,2)<x_min2)];
    
end

% Mittelwerte über lokale Dichten
A1=table(r_lokal1',v_lokal1',f_lokal1');
B1=varfun(@mean,A1,'GroupingVariables','Var1');

% Mittelwerte über lokale Dichten
A2=table(r_lokal2',v_lokal2',f_lokal2');
B2=varfun(@mean,A2,'GroupingVariables','Var1');
end %function