function [v1, v2] = lambert(R1, R2, dt, tolerance, grav)
    %% Stumpff Functions
    %
    % Jeremy Penn
    % 04 November 2017
    %
    % Revision: 04/11/17
    %           11/11/2017  - added outputs for both velocities
    %                       - added functionality to find a good guess for
    %                       z
    %
    % function [v1, v2] = lambert(R1, R2, dt,guess, tolerance, grav)
    %
    % Purpose:  This function calculates the coe of an object using
    %           Lambert's problem to solve for the velocity.
    %
    % Inputs:   o R1        - The 1st position vector [km]
    %           o R2        - The position vector after time dt [km]
    %           o dt        - The time interval between R1 and R2 [s]
    %           o tolerance - The tolderance for the zero of z [OPTIONAL]
    %           o grav      - The standard grav param [km^3/s^2] [OPTIONAL]
    %
    % Outputs:  o v1        - The velocity vector at R1
    %           o v2        - The velocity vector at R2
    %
    % Required: coe_from_rv.m, stumpff.m
    %
    clc;
    
    %% Constants
    if nargin == 3
        mu = 398600;
        tol = 1e-8;
    elseif nargin == 4
        mu = 398600;
        tol = tolerance;
    else
        mu = grav;
        tol = tolerance;
    end
    
    %% Calculate norm of r1 and r2
    r1 = norm(R1);
    r2 = norm(R2);
    r1xr2 = cross(R1,R2);
    
    %% Choose either prograde or retrograde orbit
    orbit = input('Please choose either prograde or retrograde orbit\n', 's');
    orbit = lower(orbit);
    
    if strcmp(orbit, 'prograde') || strcmp(orbit,'pro')
        if r1xr2(3) > 0
            dth = acos( dot(R1,R2)/(r1*r2) );
        else
            dth = 2*pi - acos( dot(R1,R2)/(r1*r2) );
        end
    elseif strcmp(orbit, 'retrograde') || strcmp(orbit,'retro')
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
    
    % Determine a good guess by checking where the sign of F changes
    z = 0;
    while F(z,dt) < 0
        z = z + .01;
    end
    
    while abs(ratio) > tol
        ratio = F(z,dt)/dF(z);
        z = z - ratio;
    end
    
    %% f and g functions
    f    = 1 - y(z)/r1;
    g    = A*sqrt(y(z)/mu);
    gdot = 1 - y(z)/r2;
    
    %% Calculate the velocity vector v1
    v1 = 1/g * (R2 - f*R1);
    
    %% calculate the velocity vector v2
    v2 = 1/g * (gdot*R2 - R1);
    
    %% subfunctions
    function out = y(z)
        [Cz, Sz] = stumpff(z);
        out = r1 + r2 + A*(z*Sz-1)/sqrt(Cz);
    end %y
    
    function out = F(z,t)
        [Cz, Sz] = stumpff(z);
        out = (y(z)/Cz)^1.5 * Sz + A*sqrt(y(z)) - sqrt(mu)*t;
    end %F
    
    function out = dF(z)
        [Cz, Sz] = stumpff(z);
        if z == 0
            out = ( sqrt(2)/40 )*y(0)^1.5 + (A/8)*( sqrt(y(0)) + A*sqrt(1/2*y(0)) );
        else
            out = ((y(z)/Cz)^1.5) * (1/2*z)*(Cz - 3*Sz/2*Cz)+(3*Sz^2)/4*Cz + (A/8)*( 3*Sz/Cz * sqrt(y(z))+ A*sqrt(Cz/y(z)) );
        end
    end %dF
end