function [fdot, gdot] = fDot_and_gDot_ta(r0, v0, dt, mu)
    %% This function calculates the Lagrange fdot and gdot coefficients from the
    %   change in true anomaly since time t0
    %
    % Jeremy Penn
    % 19/11/2017
    %
    % function [fdot, gdot] = fDot_and_gDot_ta(r0, v0, dt, mu)
    %
    % Inputs:   o mu   - gravitational parameter (km^3/s^2)
    %           o dt   - change in true anomaly (degrees)
    %           o r0   - position vector at time t0 (km)
    %           o v0   - velocity vector at time t0 (km/s)
    %
    % Outputs:  o fdot - the Lagrange f coefficient (dimensionless)
    %           o gdot - the Lagrange g coefficient (s)
    %
    
    h   = norm(cross(r0,v0));
    vr0 = dot(v0,r0)/norm(r0);
    r0  = norm(r0);
    c   = cosd(dt);
    s   = sind(dt);
    
    %...Equations 2.158c & d:
    fdot = mu/h*(vr0/h*(1 - c) - s/r0);
    gdot = 1 - mu*r0/h^2*(1 - c);
    
end