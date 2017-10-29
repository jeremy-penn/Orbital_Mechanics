function E = ecc_anomaly_from_ta(th,e)
    
    while th > 360
        th = th - 360;
    end
    
    while th < 0
        th = 360 + th;
    end
    
    th = th * pi/180;
   
    E = 2*atan( sqrt( ((1-e)/(1+e)) )*tan(th/2) );
end