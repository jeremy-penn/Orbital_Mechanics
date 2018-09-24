function [h, e, i, omega, w, theta] = coe_from_rv(R,V,mu)
    %% Calculate all six orbital elements fromega the initial position and velocity
    %
    %
    % Jeremy Penn
    % 15 October 2017
    %
    % Revision: 15/10/17
    %
    %           20/10/17 - Changed notation to conform with "Orbital
    %           Mechanics for Engineering Students" by Howard D. Curtis.
    %           
    % function orbitElements(R,V,mu)
    %
    % Purpose:  This function calculates the classic orbital elements.
    % 
    % Inputs:   o R  - A 1x3 vector describing the initial position of the
    %                  satellite.
    %           o V  - A 1x3 vector describing the initial velocity of the
    %                  satellite.
    %           o mu - Standard gravitationl parameter of the central body
    %                  [OPTIONAL]. Defaults to Earth (398600 [km^3/s^2])
    %
    % Output:   o h     - Specific angular momentum
    %           o e     - eccentricity
    %           o i     - orbital inclination
    %           o omega - right ascension of the ascending node
    %           o w     - argument of perigee
    %           o theta - true anomaly
    %
    
    clear r v vr H h i k N n E e omega w theta; clc;
    
    %% Set up the initial conditions
    if nargin == 2
        mu = 398600;
    end
    
    r = norm(R);
    v = norm(V);
    vr = dot(R,V) / r; % If vr > 0 object is moving away fromega perigee
    
    %% Calculate the specific angular momegaentum
    
    H = cross(R,V);
    h = norm(H);
    
    %% Calculate the inclination
    
    i = acos(H(3) / h) * (180/pi);
    
    %% Calculate node line vector
    
    k = [0, 0, 1];
    N = cross(k,H);
    n = norm(N);
    
    %% Calculate the right ascension of the ascending node
    
    if N(2) >= 0
        omega = acos(N(1) / n) * (180/pi);
    else
        omega = 360 - acos(N(1) / n) * (180/pi);
    end
    
    %% Calculate the eccentricity
    
    E = (1 / mu)*((v^2 - (mu / r))*R - vr*V);
    e = norm(E);
    
    %% Calculate the argument of perigee
    
    if E(3) >= 0
        w = acos(dot(N,E)/(n*e)) * (180/pi);
    else
        w = 360 - acos(dot(N,E)/(n*e)) * (180/pi);
    end
    
    %% Calculate the true anomegaaly
    
    if vr >= 0
        theta = acos(dot(E/e,R/r)) * (180/pi);
    else
        theta = 360 - acos(dot(E/e,R/r)) * (180/pi);
    end
end
