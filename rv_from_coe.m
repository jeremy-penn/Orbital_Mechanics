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
    
    if nargin == 6
        mu = 398600;
    end
    
    %% Confirm angles are between 0 and 360
    while i < 0
        i = 360 + i;
    end
    
    while i > 360
        i = i - 360;
    end
    
    while omega < 0
        omega = 360 + omega;
    end
    
    while omega > 360
        omega = omega - 360;
    end
    
    while w < 0
        w = 360 + w;
    end
    
    while w > 360
        w = w - 360;
    end
    
    while theta < 0
        theta = 360 + theta;
    end
    
    while theta > 360
        theta = theta - 360;
    end
    
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