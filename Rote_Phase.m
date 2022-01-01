function [val, ind] = Rote_Phase(val, ind, laenge, v_max, ampel, trd, i)

        % Nächste Spalte initialisieren
        val(:,i) = val(:,i-1);
        ind(:,i) = ind(:,i-1);

        % L ist der Index des Fahrzeugs mit dem minimalen Abstand zur Ampel
        [~,L]= min(mod(laenge + ampel - ind(:,i)' - 1, laenge));
    
        % Beschleunigen
        val(:,i) = min(val(:,i)+1, v_max);
        
        % Bremsen
        val(:,i) = min(val(:,i),mod(laenge+circshift(ind(:,i),-1) - ind(:,i)- 1, laenge));
        val(L,i) = val(L,i-1);
        
        %fprintf('Fahrzeug %d wird Geschwindigkeit %d geändert auf ',L ,val(L,i));
        val(L,i) = min(val(L,i),mod(laenge + ampel - ind(L,i)- 1, laenge));
        %fprintf('Geschwindigkeit %d in Iteration %i \n',val(L,i),i);

        % Trödeln
        val(:,i) = max(val(:,i) - trd(:,i), 0);
    
        % Bewegen
        ind(:,i) = mod(ind(:,i-1) + val(:,i) - 1, laenge)+1;


end