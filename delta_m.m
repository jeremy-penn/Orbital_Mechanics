function delta_m(m, isp, g0, v)
    clc;
    
    %% calculating the mass of propellant burned for a maneuver
    dm = m * ( 1 - exp( - v/(isp*g0) ) );
    
    %% print the results
    fprintf('The final mass of the spacecraft is %.2f [kg]\n',m - dm)
end