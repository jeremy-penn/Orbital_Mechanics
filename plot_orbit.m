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
    % Requires: rv_from_coe.m
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
    [t,y] = ode45(@orbit, t0, y0);
    
    %% Plot Orbit
    S = load('topo.mat');
    
    grs80 = referenceEllipsoid('grs80','km');
    
    figure('Renderer','opengl')
    ax = axesm('globe','Geoid',grs80,'Grid','off', ...
        'GLineWidth',1,'GLineStyle','-',...
        'Gcolor',[0.9 0.9 0.1],'Galtitude',100);
    ax.Position = [0 0 1 1];
    axis equal off
    view(0,23.5)
    
    geoshow(S.topo,S.topolegend,'DisplayType','texturemap')
    demcmap(S.topo)
    land = shaperead('landareas','UseGeoCoords',true);
    plotm([land.Lat],[land.Lon],'Color','black')
    rivers = shaperead('worldrivers','UseGeoCoords',true);
    plotm([rivers.Lat],[rivers.Lon],'Color','blue')
    hold on
    
    for i = 1:length(t)
        plot3(y(1:i,1), y(1:i,2), y(1:i,3),'color','red')
        drawnow
    end
    
    function [accel] = orbit(t, y)
        %% Calculates the changing conditions vector for numerical simulation
        %
        % Jeremy Penn
        % 29 October 2017
        %
        % Revision: 29/10/2017
        %
        % function [accel] = orbit(t, y)
        %
        % Purpose: To continuously calculate the new conditions vector for use
        %          with ode45.
        %
        
        mu = 398600; %Gravitational parameter of Earth (km^3/s^2)
        
        %% Set initial position and velocity
        
        rx = y(1); %km
        ry = y(2); %km
        rz = y(3); %km
        vx = y(4); %km/s
        vy = y(5); %km/s
        vz = y(6); %km/s
        
        %% Calculate accelerations
        
        R  = norm([rx, ry, rz]);
        ax = -mu*rx/R^3; %km/s^2
        ay = -mu*ry/R^3; %km/s^2
        az = -mu*rz/R^3; %km/s^2
        
        %% Set up new conditions after t seconds
        accel = [vx; vy; vz; ax; ay; az];
        
    end %orbit
end