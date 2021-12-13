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

laenge_phase = t_gruen + t_rot;


for i=2:iter
    
    %Gruen_Phase
    if mod(i-1,laenge_phase)+1<= t_gruen
        
        %fprintf('Gruen\n');

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

    %Rot_Phase
    else    
        %fprintf('Rot\n');

        % Nächste Spalte initialisieren
        val(:,i) = val(:,i-1);
        ind(:,i) = ind(:,i-1);

        % L ist der Index des Fahrzeugs mit dem minimalen Abstand zur Ampel
        [~,L]= min(mod(laenge + ampel - ind(:,i)' - 1,laenge));
    
        % Beschleunigen
        val(:,i) = min(val(:,i)+1,v_max);
        
        % Bremsen
        val(:,i) = min(val(:,i),mod(laenge+circshift(  ind(:,i),-1) - ind(:,i)- 1  ,laenge));
        val(L,i) = val(L,i-1);
        
        %fprintf('Fahrzeug %d wird Geschwindigkeit %d geändert auf ',L ,val(L,i));
        val(L,i) = min(val(L,i),mod(laenge+ ampel - ind(L,i)- 1  ,laenge));
        %fprintf('Geschwindigkeit %d in Iteration %i \n',val(L,i),i);
    
        %Alternative für Bremsen von L
        %for j=1:sum(s>0)
        %    if j ~= L
        %        val(j,i) = min(val(j,i),mod(laenge+ind(j-1,i) - ind(j,i)- 1  ,laenge));
        %    else 
        %        val(L,i) = min(val(L,i),mod(laenge+ ampel - ind(L,i)- 1  ,laenge));
        %    end
        %end

        % Trödeln
        val(:,i) = max(val(:,i) - trd(:,i),0);
    
        % Bewegen
        ind(:,i) = mod(ind(:,i-1) + val(:,i) - 1,laenge)+1;
    end
end

end %function