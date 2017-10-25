function [f,g] = f_and_g(x, R0, dt, a, mu)
    %% f and g functions
    %
    % Jeremy Penn
    % 25 October 2017
    %
    % Revision 25/10/17
    %
    % function [f,g] = f_and_g(x, R0, dt, a, mu)
    %
    % Purpose:  This function calculates the f and g functions from the
    %           universal anomaly.
    % 
    % Inputs:   o x  - The universal anomaly [km^0.5].
    %           o R0 - The position vector at time dt [km].
    %           o dt - The change in time since perigee [s].
    %           o a  - The reciprical of the semi-major axis [km^-1].
    %           o mu - The Standard Grav Para [km^3/s^2] [OPTIONAL].
    %
    % Outputs:  o f - The f function.
    %           o g - The g function.
    %
    
    if nargin == 4
        mu = 398600;
    end
    
    r0 = norm(R0);
    z  = a*x^2;
    [Cz,Sz] = Stumpff(z);
    
    f  = 1 - x^2/r0 * Cz;
    g  = dt - ( 1/sqrt(mu) )* x^3 * Sz;
    
end