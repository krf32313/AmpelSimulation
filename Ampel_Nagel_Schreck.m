function [ind, val] = Ampel_Nagel_Schreck(dichte,laenge,iter,v_max,p_troedel, ampel, t_gruen, t_rot)

%zufällig initialisieren mit zufälligen Geschwindigkeiten
s=-ones(laenge,1);      %A: Vector of -1 (column) Ausmaß von 1 bis länge
while(sum(s>=0)/laenge < dichte)
    s(floor(rand()*laenge)+1,1) = floor((v_max+0.99)*rand());
end

% Umwandeln in Index- und Wert-Array
ind = zeros(sum(s>=0),iter);
val = zeros(sum(s>=0),iter);



x = (1:laenge)';          % Generierung aller Indizes
h = (s(:,1)>=0) .* x;    % Indizes der Fahrzeuge
ind(:,1) = h(s(:,1)>=0);  % Übernahme in Index-Array
val(:,1) = s(s(:,1)>=0);  % Übernahme in Geschwindigkeits-Array

% Array der Trödelfaktoren
trd = rand(sum(s>=0),iter) <= p_troedel;

phase = floor(iter - 1/(t_gruen + t_rot));
rest = mod(iter - 1,(t_gruen + t_rot));

% Berechnungen für die Grünphase (Geschwindigkeit und Lage)
for i=1:t_gruen
    
    % Nächste Spalte initialisieren
    val(:,i) = val(:,i-1);
    ind(:,i) = ind(:,i-1);
    
    % Beschleunigen
    val(:,i) = min(val(:,i)+1,v_max);
    
    % Bremsen
    val(:,i) = min(val(:,i),mod(laenge+circshift(  ind(:,i),-1) - ind(:,i)- 1  ,laenge));
    
    % Trödeln
    val(:,i) = max(val(:,i) - trd(:,i),0);
    
    % Bewegen
    ind(:,i) = mod(ind(:,i-1) + val(:,i) - 1,laenge)+1;
end

% Berechnungen für die Rot_Phase
for i=1:t_rot
    
    L = min(mod(laenge + ampel - ind(:,i) - 1,laenge));
    % Nächste Spalte initialisieren
    val(:,i) = val(:,i-1);
    ind(:,i) = ind(:,i-1);
    
    % Beschleunigen
    val(:,i) = min(val(:,i)+1,v_max);
    
    % Bremsen
    val(:,i) = min(val(:,i),mod(laenge+circshift(  ind(:,i),-1) - ind(:,i)- 1  ,laenge));
    val(L,i) = min(val(:,i),mod(laenge+ ampel - ind(:,i)- 1  ,laenge));
    
    % Trödeln
    val(:,i) = max(val(:,i) - trd(:,i),0);
    
    % Bewegen
    ind(:,i) = mod(ind(:,i-1) + val(:,i) - 1,laenge)+1;
end

end %function