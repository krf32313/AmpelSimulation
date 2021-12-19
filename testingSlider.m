% Beispiel eines Slider aus der Matlab Dokumentation

clc;
close;
clear;

zeta = .5;                           % Damping Ratio
wn = 2;                              % Natural Frequency
sys = berechneZeta(zeta, wn); 

f = figure;
ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);
h = stepplot(ax,sys);
setoptions(h,'XLim',[0,10],'YLim',[0,2]);


slider = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],'value',zeta, 'min',0, 'max',1);
bgcolor = f.Color;
sliderl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],'String','0','BackgroundColor',bgcolor);
sliderl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],'String','1','BackgroundColor',bgcolor);
sliderl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],'String','Damping Ratio','BackgroundColor',bgcolor);
  

slider.Callback = @(es,ed) updateSystem(h,berechneZeta(es.Value, wn)); 

function [sys] = berechneZeta(es, wn)
    sys = tf(wn^2,[1,2*es*wn,wn^2]);
end 