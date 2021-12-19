% Animation einer Ringstraße

clc; clear; close all;

% Initialisierungswerte
dichte = 0.15; 
laenge =200;
iter = 100;
v_max = 5;
p_troedel = 0.2;
ampel = 100;
t_gruen = 30;
t_rot = 20;

% Nagel Schreckenberg berechnen
% Neue Parameter: dichte,laenge,iter,v_max,p_troedel, ampel, t_gruen, t_rot
[ind,val] = Ampel_Nagel_Schreck(dichte, laenge, iter, v_max, p_troedel, ampel, t_gruen, t_rot);

% Bewegungsdaten festlegen
x = ind; % Position der Autos

% Initialisierungsbild malen
% Figure Größe ganzer Bildschirm
figure('units','normalized','outerposition',[0 0 1 1])
% Zwei Linien für die Straße plotten
s = [0:0.1:laenge]; % x Werte für Straße
m = size(s,2);
y1 = ones(m,1).*(laenge/2+5); % y Wert obere Straßenlinie
y2 = ones(m,1).*(laenge/2-5); % y Wert untere Straßenlinie
plot(s,y1, 'k')
hold on
plot(s,y2, 'k')
hold on
% Ampel plotten
plot(ampel,laenge/2, '+', 'MarkerSize' ,22, 'MarkerFaceColor', 'r','LineWidth',4)

% Startpositionen der Autos plotten
NumberCars = size(x,1);
yWerte = ones(NumberCars,1)*(laenge/2);
h = plot(x(:,1), yWerte, 'o', 'MarkerSize' ,10, 'MarkerFaceColor', 'c');

% Achsen festlegen
%axis off
xlim([0, laenge])
ylim([0, laenge]);

% Animationsschleife, die pro Iteration die neuen Positionen der Autos
% plottet
for i = 1:size(x,2)
        set(h, 'XData', x(:,i));
        drawnow;
end



