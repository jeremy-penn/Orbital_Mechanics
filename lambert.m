function lambert(R1, R2, dt,guess, tolerance, grav)
    %% Stumpff Functions
    %
    % Jeremy Penn
    % 04 November 2017
    %
    % Revision:04/11/17
    %
    % function lambert(R1, R2, dt,guess, tolerance, grav)
    %
    % Purpose:  This function calculates the coe of an object using
    %           Lambert's problem to solve for the velocity.
    % 
    % Inputs:   o R1        - The 1st position vector [km]
    %           o R2        - The position vector after time dt [km]
    %           o dt        - The time interval between R1 and R2 [s]
    %           o guess     - The initial guess for z [OPTIONAL]
    %           o tolerance - The tolderance for the zero of z [OPTIONAL]
    %           o grav      - The standard grav param [km^3/s^2] [OPTIONAL]
    %
    % Required: coe_from_rv.m, stumpff.m
    %
    clc;
    
    %% Constants
    if nargin == 3
        mu = 398600;
        tol = 1e-8;
        z = 0;
    elseif nargin == 4
        mu = 398600;
        tol = 1e-8;
        z = guess;
    elseif nargin == 5
        mu = 398600;
        tol = tolerance;
        z = guess;
    else
        mu = grav;
        tol = tolerance;
        z = guess;
    end
    
    %% Calculate norm of r1 and r2
    r1 = norm(R1);
    r2 = norm(R2);
    r1xr2 = cross(R1,R2);
    
    %% Choose either prograde or retrograde orbit
    orbit = input('Please choose either prograde or retrograde orbit\n', 's');
    
    if strcmp(orbit, 'prograde')
        if r1xr2(3) > 0
            dth = acos( dot(R1,R2)/(r1*r2) );
        else
            dth = 2*pi - acos( dot(R1,R2)/(r1*r2) );
        end
    elseif strcmp(orbit, 'retrograde')
        if r1xr2(3) >= 0
            dth = 2*pi - acos( dot(R1,R2)/(r1*r2) );
        else
            dth = acos( dot(R1,R2)/(r1*r2) );
        end
    else
        error('Error: Please input "prograde" or "retrograde"')
    end
    
    %% Calculate A
    A = sin(dth)*sqrt( r1*r2/(1-cos(dth)) );
    
    %% find zero of z
    ratio = 1;
    
    while abs(ratio) > tol
        ratio = F(z,dt)/dF(z);
        z = z - ratio;
    end
    
    %% f and g functions
    f    = 1 - y(z)/r1;
    g    = A*sqrt(y(z)/mu);
    
    %% Calculate the velocity vector v1
    v1 = 1/g * (R2 - f*R1);
    
    %% Calculate the classical orbital elements
    [h, e, i, W, w, th] = coe_from_rv(R1,v1);
    
    while i > 360
        i = i - 360;
    end
    
    while W > 360
        W = W - 360;
    end
    
    while w > 360
        w = w - 360;
    end
    
    while th > 360
        th = th - 360;
    end
    
    while i < 0
        i = i + 360;
    end
    
    while W < 0
        W = W + 360;
    end
    
    while w < 0
        w = w + 360;
    end
    
    while th < 0
        th = th + 360;
    end
    
    fprintf('The specific angular momentum is %.2f [km^2/s]\n', h)
    fprintf('The eccentricity is %.4f\n', e)
    fprintf('The inclination is %.2f [deg]\n', i)
    fprintf('The right ascension of the ascending node is %.2f [deg]\n', W)
    fprintf('The argument of perigee is %.2f [deg]\n', w)
    fprintf('The true anomaly is %.2f [deg]\n', th)
    
    %% subfunctions
    function out = y(z)
        [Cz, Sz] = stumpff(z);
        out = r1 + r2 + A*(z*Sz-1)/sqrt(Cz);
    end
    
    function out = F(z,t)
        [Cz, Sz] = stumpff(z);
        out = ((y(z)/Cz)^1.5) * Sz + A*sqrt(y(z)) - sqrt(mu)*t;
    end
    
    function out = dF(z)
        [Cz, Sz] = stumpff(z);
        if z == 0
            out = ( sqrt(2)/40 )*y(0)^1.5 + (A/8)*( sqrt(y(0)) + A*sqrt(1/2*y(0)) );
        else
            out = ((y(z)/Cz)^1.5) * (1/2*z)*(Cz - 3*Sz/2*Cz)+(3*Sz^2)/4*Cz + (A/8)*( 3*Sz/Cz * sqrt(y(z))+ A*sqrt(Cz/y(z)) );
        end
    end
end