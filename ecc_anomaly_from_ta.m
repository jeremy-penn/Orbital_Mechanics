function E = ecc_anomaly_from_ta(th,e)
    %% Calculates the eccentric anomaly [rad] from the true anomaly [deg]
    th1 = mod(th, 360);
    
    th2 = th1 * pi/180;
   
    E = 2*atan( sqrt( ((1-e)/(1+e)) )*tan(th2/2) );
end