function th = ta_from_E(E, e)
    %% Calculates the true anomaly [rad] from the eccentric anomaly [rad]

    th = 2*atan( sqrt( (1+e)/(1-e) )*tan(E/2) );
end