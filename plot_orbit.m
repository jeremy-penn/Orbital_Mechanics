function plot_orbit(h, e, i, omega, w, th, mu)
    %% Plot the orbits of small mass orbiting a large central body
    %
    % Jeremy Penn
    % 29 October 2017
    %
    % Revision: 29/10/17
    %           
    % function plot_orbit(h, e, i, omega, w, th, mu)
    %
    % Purpose:  This function plots the orbital path of an object orbiting
    %           a central body.
    % 
    % Input:    o h     - Specific angular momentum
    %           o e     - eccentricity
    %           o i     - orbital inclination
    %           o omega - right ascension of the ascending node
    %           o w     - argument of perigee
    %           o th    - true anomaly
    %           o mu    - standard grav param [OPTIONAL]
    %
   
    clc;
    
    if nargin == 6
        mu = 398600;
    end
    
    %% Find r & v
    [r0, v0] = rv_from_coe(h, e, i, omega, w, th);
    
    r      = norm(r0);
    T0     = 2*pi/sqrt(mu)*(r)^(1.5); %[s] period of the orbit
    
    %% Set up initial conditions
    y0 = [r0, v0];
    t0 = [0 T0];
    
    %% Numerically solve for the orbit
    [t,y] = ode45('orbit', t0, y0); 
    
    %% Plot Orbit 
    for i = 1:length(t)    
        plot3(y(1:i,1), y(1:i,2), y(1:i,3))    
        drawnow
    end 
end