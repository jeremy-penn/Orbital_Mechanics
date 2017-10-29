function [a] = orbit(t, y, h, e, i, omega, w, th, mu)
   
    if nargin == 8
        mu = 398600; %[km^3/s^2] standard grav para
    end
    
    %% Set up the initial conditions
    rx = y(1); %[km]
    ry = y(2); %[km] 
    rz = y(3); %[km]
    vx = y(4); %[km/s]
    vy = y(5); %[km/s] 
    vz = y(6); %[km/s]
    
    %% Normalize the position vector for futre use
    R  = norm([rx, ry, rz]);   %Find acceleration from the position vector
    ax = -mu*rx/R^3; %[km/s^2] 
    ay = -mu*ry/R^3; %[km/s^2] 
    az = -mu*rz/R^3; %[km/s^2] 

    %% Set up new conditions after t seconds 
    a = [vx; vy; vz; ax; ay; az];
    
    %% Find r & v
    [r0, v0] = rv_from_coe(h, e, i, omega, w, th);
    
    r      = norm(r0);
    T0     = 2*pi/sqrt(mu)*(r)^(1.5); %[s] period of the orbit
    
    %% Set up initial conditions
    y0 = [r0, v0];
    t0 = [t, T0];
    
    %% Numerically solve for the orbit
    [t,y] = ode45(@orbit, t0, y0); 
    
    %% Plot Orbit 
    for i = 1:length(t)    
        plot3(y(1:i,1), y(1:i,2), y(1:i,3))    
        drawnow
    end 
end