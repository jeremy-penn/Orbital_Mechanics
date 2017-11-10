function [r , v] = rv_from_coe(h, e, i, omega, w, theta, mu)
    %% Calculate the state vector from classical orbital elements
    %
    % Jeremy Penn
    % 28 October 2017
    %
    % Revision: 28/10/17
    %
    % function [r , v] = rv_from_coe(h, e, i, omega, w, theta, mu)
    %
    % Input:    o h     - Specific angular momentum
    %           o e     - eccentricity
    %           o i     - orbital inclination
    %           o omega - right ascension of the ascending node
    %           o w     - argument of perigee
    %           o theta - true anomaly
    %           o mu    - standard grav param [OPTIONAL]
    %
    % Output:   o r     - The position vector
    %           o v     - The velocity vector
    %
    % Requires: rot1.m, rot3.m
    %
    
    if nargin == 6
        mu = 398600;
    end
    
    %% Confirm angles are between 0 and 360
    i     = mod(i, 360);
    omega = mod(omega, 360);
    w     = mod(w, 360);
    theta = mod(theta, 360);
    
    %% Convert deg to rad
    dtor    = pi/180;
    i       = i * dtor;
    omega   = omega * dtor;
    w       = w * dtor;
    theta   = theta * dtor;
    
    
    %% Calculate the position vector in the perifocal frame
    rp = (h^2/mu) * ( 1/(1+e*cos(theta)) ) * [cos(theta); sin(theta); 0];
    
    %% Calculate the velocity vector in the perifocal frame
    vp = (mu/h) * [-sin(theta); e + cos(theta); 0];
    
    %% Calculate the transform matrix from perifocal to geocentric
    Q  = ( rot3(w)*rot1(i)*rot3(omega) )';
    
    %% Transform from perifocal to geocentric
    r = Q * rp;
    v = Q * vp;
    
end