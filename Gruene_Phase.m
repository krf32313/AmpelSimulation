function [val, ind] = Gruene_Phase(val, ind, laenge, v_max, trd, i)

        % Nächste Spalte initialisieren
        val(:,i) = val(:,i-1);
        ind(:,i) = ind(:,i-1);
    
        % Beschleunigen
        val(:,i) = min(val(:,i)+1, v_max);
    
        % Bremsen
        val(:,i) = min(val(:,i),mod(laenge+circshift(ind(:,i),-1) - ind(:,i)- 1, laenge));
    
        % Trödeln
        val(:,i) = max(val(:,i) - trd(:,i), 0);
    
        % Bewegen
        ind(:,i) = mod(ind(:,i-1) + val(:,i) - 1, laenge)+1;

end