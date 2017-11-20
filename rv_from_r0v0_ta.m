function [r,v] = rv_from_r0v0_ta(r0, v0, dt, mu)
    %%  This function computes the state vector (r,v) from the
    %    initial state vector (r0,v0) and the change in true anomaly.
    %
    % Jeremy Penn
    % 19/11/2017
    %
    % function [r,v] = rv_from_r0v0_ta(r0, v0, dt, mu)
    %
    % Inputs:   o mu - gravitational parameter (km^3/s^2)
    %           o r0 - initial position vector (km)
    %           o v0 - initial velocity vector (km/s)
    %           o dt - change in true anomaly (degrees)
    %           o r  - final position vector (km)
    %           o v  - final velocity vector (km/s)
    %
    % Output:   o r  - new position vector (km)
    %           o v  - new velocity vector (km/s)
    %
    % Required: f_and_g_ta, fDot_and_gDot_ta
    %
    
    %...Compute the f and g functions and their derivatives:
    [f, g]       =       f_and_g_ta(r0, v0, dt, mu);
    [fdot, gdot] = fDot_and_gDot_ta(r0, v0, dt, mu);
    
    %...Compute the final position and velocity vectors:
    r =    f*r0 +    g*v0;
    v = fdot*r0 + gdot*v0;
    
end