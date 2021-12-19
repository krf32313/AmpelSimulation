% Test Durchschnitt Geschwindigkeit/Fluss Diagramm an einer Ringstraße

clc;
close;
clear;

dichte = 0:0.1:1;
laenge =3000;
iter = 2000;
v_max = 5;
p_troedel = 0.2;
ampel = 1500;
t_gruen = 120;
t_rot = 120;

% Messintervall
x_min=1450;
x_max=1550;

r_lokal=[];
v_lokal=[];
f_lokal=[];

for r = dichte
    [ind2,val2] = Ampel_Nagel_Schreck(r, laenge, iter, v_max, p_troedel, ampel, t_gruen, t_rot);
    
    % Messintervall in Daten kennzeichnen
    intervall = ind2>=x_min & ind2<x_max;
    
    % lokale Dichte und Geschwindigkeiten filtern
    r_lokal = [r_lokal sum(intervall)/ (x_max-x_min)];
    v_lokal = [v_lokal sum(intervall .* val2) / (x_max-x_min)];
    
    % Fluss über x_min Grenze bestimmen
    f_lokal = [f_lokal sum(ind2>=x_min & circshift(ind2,1,2)<x_min)];
    
end

% Mittelwerte über lokale Dichten
A=table(r_lokal',v_lokal',f_lokal');
B=varfun(@mean,A,'GroupingVariables','Var1');

% und plotten
figure
plot(B.Var1,B.mean_Var2)
ylabel("Geschwindigkeit")
xlabel("Dichte")

figure
plot(B.Var1,B.mean_Var3)
ylabel("Fluss")
xlabel("Dichte")