function ground_track_from_rv(R0, V0, n, mu, Re, J2, we)
    %% Calculate and plot the geocentric orbit of a satellite about the Earth
    %
    % Jeremy Penn
    % 21 October 2017
    %
    % Revision: 21/10/17
    %           29/10/2017 - Changed RA from 0:360 to -180:180
    %           30/10/2017 - Changed dependecy to ground_track_from_coe.m
    %
    % function ground_track(R0, V0, dt, step, mu)
    %
    % Purpose:  This function plots the ground track of a satellite in the
    %           geocentric frame of reference. Additionally, it creates a
    %           video of the ground track.
    % 
    % Inputs:   o R0    - A 1x3 vector of the satellite's initial position
    %           o V0    - A 1x3 vector of the satellite's initial velocity
    %           o n     - number of orbits
    %           o mu    - standard grav param [OPTIONAL]
    %           o Re    - central body radius [OPTIONAL]
    %           o J2    - central body second zonal harmonic [OPTIONAL]
    %           o we    - central body angular speed [OPTIONAL]
    %
    % Requires: coe_from_rv.m, ground_track_from_coe.m
    %
    
    clc;
    if nargin == 2
        n = 1;
        Re  = 6378;          % [km] radius of the Earth
        we  = 7.27e-5;       % [rad/s] angular speed of Earth
        mu  = 398600;        % [km^3/s^2] Standard Gravitational Parameter
        J2  = 0.0010836;
    end
    
    if nargin == 3
        Re  = 6378;          % [km] radius of the Earth
        we  = 7.27e-5;       % [rad/s] angular speed of Earth
        mu  = 398600;        % [km^3/s^2] Standard Gravitational Parameter
        J2  = 0.0010836;
    end
    
    %% Calculate classic orbital elements
    [h, e, i, omega, w, theta] = coe_from_rv(R0, V0, mu);
    
    %% Calculate the track
    ground_track_from_coe(h,e,i,omega,w,theta,n, mu, Re, J2, we)
end