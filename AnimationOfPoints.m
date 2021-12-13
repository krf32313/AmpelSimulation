% animation_point.m

clc; clear; close all;

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

% Create motion data -- (1)
x = ind; % Position data

% Draw initial figure -- (2)
figure(1);
s = [0:0.1:laenge];
m = size(s,2);
y = ones(m,1).*(laenge/2);
plot(s,y)
hold on
plot(ampel,laenge/2, 'o', 'MarkerSize' ,10, 'MarkerFaceColor', 'r')
NumberCars = size(x,1);

yWerte = ones(NumberCars,1)*(laenge/2);
h = plot(x(:,1), yWerte, 'o', 'MarkerSize' ,5, 'MarkerFaceColor', 'b');
xlim([0, laenge]);
ylim([0, laenge]);

% Animation loop -- (3)
for i = 1:size(x,2)
        set(h, 'XData', x(:,i));
        drawnow;
end



