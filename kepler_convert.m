function kepler = kepler_convert(R,V,mu)
    %% Calculate all six orbital elements fromega the initial position and velocity
    %
    % Jeremy Penn
    % 15 October 2017
    %
    % Revision  19/10/17
    %           
    % function kepler = keplerConvert(R,V)
    %
    % Purpose:  This function converts the state vector [R,V] into the six
    %           keplerian orbital elements.
    % 
    % Inputs:   o R - A 1x3 vector of the satellite's initial position
    %           o V - A 1x3 vector of the satellite's initial velocity
    %           o mu - The standard Grav Param [OPTIONAL].
    %
    % Outputs:  o kepler - A 1x6 vector containing the orbital elements.
    %
    
    if nargin == 2
        mu = 398600;
    end
    
    %% Set up the initial conditions
    
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
    
    %% Calculate a
    
    a = (h^2/mu)*(1/(1-e^2));
    
    %% Place results into vector
    
    kepler = [a; e; i; omega; w; theta];
end
