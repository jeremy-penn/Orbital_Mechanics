function [fdot,gdot] = fdot_and_gdot(x, R0, r, a, mu)
    %% f and g functions
    %
    % Jeremy Penn
    % 25 October 2017
    %
    % Revision 25/10/17
    %
    % function [fdot,gdot] = fdot_and_gdot(x, R0, r, a, mu)
    %
    % Purpose:  This function calculates the f and g functions from the
    %           universal anomaly.
    % 
    % Inputs:   o x  - The universal anomaly [km^0.5].
    %           o R0 - The position vector at time dt [km].
    %           o r  - The magnitude of the new position [km].
    %           o a  - The reciprical of the semi-major axis [km^-1].
    %           o mu - The Standard Grav Para [km^3/s^2] [OPTIONAL].
    %
    % Outputs:  o fdot - The fdot function.
    %           o gdot - The gdot function.
    %
    % Requires: stumpff.m
    %
    if nargin == 4
        mu = 398600;
    end
    
    r0 = norm(R0);
    z  = a*x^2;
    [Cz,Sz] = stumpff(z);
    
    fdot = (sqrt(mu)/(r*r0)) * ( a*x^3*Sz - x );
    gdot = 1 - (x^2/r) *Cz;
end