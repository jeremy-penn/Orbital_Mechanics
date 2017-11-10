function E = ecc_anomaly_from_ta(th,e)
    %% Calculates the eccentric anomaly [deg] from the true anomaly [deg]
    th = mod(th, 360);
    
    th = th * pi/180;
   
    E = 2*atan( sqrt( ((1-e)/(1+e)) )*tan(th/2) );
    
    E = E * (180/pi);
    
    E = mod(E, 360);
end