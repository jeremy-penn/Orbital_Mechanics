function E = ecc_anomaly_from_ta(th,e)
    %% Calculates the eccentric anomaly [deg] from the true anomaly [deg]
    
    while th > 360
        th = th - 360;
    end
    
    while th < 0
        th = 360 + th;
    end
    
    th = th * pi/180;
   
    E = 2*atan( sqrt( ((1-e)/(1+e)) )*tan(th/2) );
    
    E = E * (180/pi);
    
    while E > 360
        E = E - 360;
    end
    
    while E < 0
        E = E + 360;
    end
end