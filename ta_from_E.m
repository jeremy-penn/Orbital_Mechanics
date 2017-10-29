function th = ta_from_E(E, e)
   
    th = 2*atan( sqrt( (1+e)/(1-e) )*tan(E/2) );
    
    th = th * (180/pi);
end