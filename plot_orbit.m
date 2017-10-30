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
    % Requires: orbit.m, rv_from_coe.m
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
    [t,y] = ode45('orbit', t0, y0,'RelTol',1e-32); 
    
    %% Plot Orbit
    load topo
    
    grs80 = referenceEllipsoid('grs80','km');
        
    figure('Renderer','opengl')
    ax = axesm('globe','Geoid',grs80,'Grid','off', ...
        'GLineWidth',1,'GLineStyle','-',...
        'Gcolor',[0.9 0.9 0.1],'Galtitude',100);
    ax.Position = [0 0 1 1];
    axis equal off
    view(0,23.5)

    geoshow(topo,topolegend,'DisplayType','texturemap')
    demcmap(topo)
    land = shaperead('landareas','UseGeoCoords',true);
    plotm([land.Lat],[land.Lon],'Color','black')
    rivers = shaperead('worldrivers','UseGeoCoords',true);
    plotm([rivers.Lat],[rivers.Lon],'Color','blue')
    hold on
    
    for i = 1:length(t)    
        plot3(y(1:i,1), y(1:i,2), y(1:i,3),'color','red')    
        drawnow
    end 
end