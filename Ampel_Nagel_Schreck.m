function [ind, val] = Ampel_Nagel_Schreck(start_phase, dichte, laenge, iter, v_max, p_troedel, ampel, t_gruen, t_rot)

% Zufälliges Initialisieren mit zufälligen Geschwindigkeiten
s=-ones(laenge,1);      % Vektor mit -1 (Spalte), Ausmaß von 1 bis laenge
while(sum(s>=0)/laenge < dichte)
    s(floor(rand()*laenge)+1,1) = floor((v_max+0.99)*rand());
end

% Umwandeln in Index- und Wert-Array
ind = zeros(sum(s>=0),iter);
val = zeros(sum(s>=0),iter);

x = (1:laenge)';          % Generierung aller Indizes
h = (s(:,1)>=0) .* x;     % Indizes der Fahrzeuge
ind(:,1) = h(s(:,1)>=0);  % Übernahme in Index-Array
val(:,1) = s(s(:,1)>=0);  % Übernahme in Geschwindigkeits-Array

% Array der Trödelfaktoren
trd = rand(sum(s>=0),iter) <= p_troedel;

laenge_phase = t_gruen + t_rot;

if start_phase == "g"

    for i=2:iter
    
        %Gruen_Phase
        if mod(i-1,laenge_phase)+1<= t_gruen
        
            [val, ind] = Gruene_Phase(val, ind, laenge, v_max, trd, i);

        %Rot_Phase
        else    
            
            [val, ind] = Rote_Phase(val, ind, laenge, v_max, ampel, trd, i);

        end
    end

elseif start_phase == "r"

    for i=2:iter
    
        %Rot_Phase
        if mod(i-1,laenge_phase)+1<= t_rot
        
            [val, ind] = Rote_Phase(val, ind, laenge, v_max, ampel, trd, i);

        %Gruen_Phase
        else    
         
            [val, ind] = Gruene_Phase(val, ind, laenge, v_max, trd, i);

        end
    end
    
else
    disp("Ungültige Angabe der ersten Phase")

end

end %function