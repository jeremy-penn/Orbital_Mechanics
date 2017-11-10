function th = ta_from_E(E, e)
    %% Calculates the true anomaly [deg] from the eccentric anomaly [deg]
    
    E = mod(E, 360);
    
    E = E * (pi/180);
   
    theta = 2*atan( sqrt( (1+e)/(1-e) )*tan(E/2) );
    
    theta = theta * (180/pi);
    
    theta = mod(theta, 360);
    
    th = theta;
end