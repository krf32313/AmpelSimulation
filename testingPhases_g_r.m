
iter = 523;
t_gruen = 30;
t_rot = 20;

laenge_phase = t_gruen+t_rot;



for i=2:iter

    %Gruen_Phase
    if mod(i-1,laenge_phase)+1<= t_gruen
    fprintf("%d will be gruen phase\n",i )
       

    %Rot_Phase
    else    
    fprintf("%d will be rot phase\n",i )   
       
    end
end

