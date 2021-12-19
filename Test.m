% Test Scatter Plot einer Ringstraße

clc;
close;
clear;

dichte = 0.15; 
laenge =3000;
iter = 2000;
v_max = 5;
p_troedel = 0.2;
ampel = 1500;
t_gruen = 20;
t_rot = 10;

% Nagel Schreckenberg berechnen
% Neue Parameter: dichte,laenge,iter,v_max,p_troedel, ampel, t_gruen, t_rot
[ind,val] = Ampel_Nagel_Schreck(dichte, laenge, iter, v_max, p_troedel, ampel, t_gruen, t_rot);

% Zeiten werden für y-Achse gebraucht
tim = ones(size(ind,1),1) * (1:iter);
disp("done");

% mögliche Farbskalen
gry_scale = (0:v_max)' * ones(1,3) / (v_max+1);
red_scale = gry_scale; red_scale(:,1)=ones((v_max+1),1);
blu_scale = gry_scale; blu_scale(:,3)=ones((v_max+1),1);
grn_prp_scale = gry_scale; grn_prp_scale(:,[1 3])=(v_max:-1:0)'/v_max * ones(1,2);
trq_red_scale = gry_scale; trq_red_scale(:,1)=(v_max:-1:0)'/v_max;
ylw_blu_scale = gry_scale; ylw_blu_scale(:,3)=(v_max:-1:0)'/v_max;

% und plotten
figure
colormap(ylw_blu_scale)
scatter(ind(:),-tim(:),[],val(:)+1,'.');
%plot(tim(:),ind(:),'+r');
