function [a,i,e,omega,w,theta] = Gibbs(R1,R2,R3,mu)
    %% Gibbs method for finding velocities of an orbit
    %
    % Jeremy Penn
    % 20 October 2017
    %
    % Revision  20/10/17
    %           
    % function [h,i,e,omega,w,theta] = Gibbs(R1,R2,R3,mu)
    %
    % Purpose:  This function computes the classical orbital elements by
    %           means of the Gibbs method.
    % 
    % Inputs:   o R1 - A 1x3 vector describing the 1st position of the
    %                  satellite.
    %           o R2 - A 1x3 vector describing the 2nd position of the
    %                  satellite.
    %           o R3 - A 1x3 vector describing the 3rd position of the
    %                  satellite.
    %           o mu - The standard gravitational parameter [OPTIONAL].
    %                  Defaults to Earth.
    % 
    % Output:   o a     - Semi-major axis
    %           o i     - inclination
    %           o e     - eccintricity
    %           o omega - right ascension of the ascending node
    %           o w     - argument of perigee
    %           o theta - true anomaly
    %
    clc;
    if nargin == 3
        mu = 398600;
    end
    tol = 1e4;
    
    %% Calculate magnitudes of r1,r2, and r3
    r1 = norm(R1);
    r2 = norm(R2);
    r3 = norm(R3);
    
    %% Confirm they comprise an orbit
    
    c12 = cross(R1,R2);
    c23 = cross(R2,R3);
    c31 = cross(R3,R1);
    
    ur1 = R1/r1;
    nc23 = norm(c23);
    uc23 = c23/nc23;
    
    if abs(dot(ur1,uc23)) > tol
        error('Error: The given positions do not describe an orbit');
    end
    
    %% Calculate N, D, and S vectors
    
    N = r1*c23 + r2*c31 + r3*c12;
    D = c12 + c23 + c31;
    S = R1*(r2-r3) + R2*(r3-r1) + R3*(r1-r2);
    
    n = norm(N);
    d = norm(D);
    
    %% Compute velocity at r2
    
    dr2 = cross(D,R2);
       
    V2 = sqrt(mu/(n*d))*((dr2/r2) + S);
    
    %% Calculate the orbital elements from r2 and v2
    
    kepler = keplerConvert(R2,V2);
    
    a       = kepler(1);
    e       = kepler(2);
    i       = kepler(3);
    omega   = kepler(4);
    w       = kepler(5);
    theta   = kepler(6);
    
    fprintf('The semimajor axis is %5f [km]\n', a)
    fprintf('The eccentricity is %1.2f [deg]\n', e)
    fprintf('The inclination is %3.2f [deg]\n', i)
    fprintf('The right ascension of the ascending node is %3.2f [deg]\n', omega)
    fprintf('The argument of perigee is %3.2f [deg]\n', w)
    fprintf('The true anomaly is %3.2f [deg]\n', theta)
end

