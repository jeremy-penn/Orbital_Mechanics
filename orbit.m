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
    
    rx=y(1); %km 
    ry=y(2); %km 
    rz=y(3); %km 
    vx=y(4); %km/s
    vy=y(5); %km/s 
    vz=y(6); %km/s
    
    %% Calculate accelerations
    
    R=norm([rx, ry, rz]);
    ax=-mu*rx/R^3; %km/s^2
    ay=-mu*ry/R^3; %km/s^2
    az=-mu*rz/R^3; %km/s^2
    %% Set up new conditions after t seconds
    
    accel = [vx; vy; vz; ax; ay; az];
end