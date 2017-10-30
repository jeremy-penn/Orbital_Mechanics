function [r,v] = rv_from_obs(rho, A, a, drho, dA, da, H, th, phi)
    %% Coverts from topocentric to geocentric coordinates
    %
    % Jeremy Penn
    % 22/10/2017
    %
    % Revision: 22/10/2017
    %
    % function [r,v] = rv_from_obs(rho, A, a, drho, dA, da, H, th, phi)
    %
    % Input:    o rho   - The range from observation [km]
    %           o A     - The azimuth angle of the target [deg]
    %           o a     - The angular elevation of the object [deg]
    %           o drho  - The time rate of change of rho [km]
    %           o dA    - The time rate of change of A [deg]
    %           o da    - The time rate of change of a [deg]
    %           o H     - The height of the observation location [km]
    %           o th    - The local sidereal time [deg]
    %           o phi   - The latitude of the observer [deg]
    %
    % Output:   o r     - The geocentric position vector
    %           o v     - The geocentric velocity vector
    %
    % Requires: kepler_convert.m
    %
    
    %% Convert angles from degrees to radians
    A   = A * pi/180;
    a   = a * pi/180;
    dA  = dA * pi/180;
    da  = da * pi/180;
    th  = th * pi/180;
    phi = phi * pi/180;
    
    %% Earth constants
    f     = .003353;
    Re    = 6378;
    Omega = [0, 0, 72.92e-06]; %[rad/s] Earth's rotational velcoity
    
    %% Calculate the geocentric position vector of the observer
    R = [((Re / sqrt(1 - (2*f - f^2)*sin(phi).^2)) + H)*cos(phi)*cos(th),((Re / sqrt(1 - (2*f - f^2)*sin(phi).^2)) + H)*cos(phi)*sin(th), ((Re*(1 - f)^2 / sqrt(1 - (2*f - f^2)*sin(phi).^2)) + H)*sin(phi)];
    
    %% Calculate the topocentric RA and dec
    del = asin(cos(phi) * cos(A) * cos(a) + sin(phi)*sin(a));
    
    if A > 0 && A < pi
        h = 2*pi - acos((cos(phi) * sin(a) - sin(phi) * cos(A) * cos(a)) / cos(del));
    else
        h = acos((cos(phi) * sin(a) - sin(phi) * cos(A) * cos(a)) / cos(del));
    end
    
    alpha = th - h;
        
    %% Calculate the direction cosine vector
    rhohat = [cos(del)*cos(alpha), cos(del)*sin(alpha), sin(del)];
    
    %% Calculate the geocentric position vector
    r = R + rho*rhohat;
    
    %% Calculate the inertial velocity of the observer
    Rdot = cross(Omega, R);
    
    %% Calculate the declination rate
    deldot = (1/cos(del)) * (-dA*cos(phi)*sin(A)*cos(a) + da*(sin(phi)*cos(a)-cos(phi)*cos(A)*sin(a)));
    
    %% Calculate the right ascension rate
    hdot  = ( (dA*cos(A)*cos(a)) - (da*sin(A)*sin(a)) + (deldot*sin(A)*cos(a)*tan(del)) ) / (cos(phi)*sin(a) - sin(phi)*cos(A)*cos(a));
    
    aldot = Omega(3) + hdot;
    
    %% Calculate the direction cosin rate vector
    rhohatdot = [(-aldot*sin(alpha)*cos(del) - deldot*cos(alpha)*sin(del)), (aldot*cos(alpha)*cos(del) - deldot*sin(alpha)*sin(del)), deldot*cos(del)];
    
    v = Rdot + drho*rhohat + rho*rhohatdot;
    
    %% Calculate the orbital elements
    kepler = kepler_convert(r,v);
    
    a       = kepler(1);
    e       = kepler(2);
    i       = kepler(3);
    omega   = kepler(4);
    w       = kepler(5);
    th      = kepler(6);
    
    fprintf('The semi-major axis is %6.2f [km]\n', a);
    fprintf('The eccentricity is %6.2f \n', e);
    fprintf('The inclination is %6.2f [deg]\n', i);
    fprintf('The right ascension of the ascending node is %6.2f [deg]\n', omega);
    fprintf('The argument of perigee is %6.2f [deg]\n', w);
    fprintf('The true anomaly is %6.2f [deg]\n', th);
end