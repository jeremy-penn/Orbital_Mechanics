function ground_track(R0, V0, n, mu, Re, J2, we)
    %% Calculate and plot the geocentric orbit of a satellite about the Earth
    %
    % Jeremy Penn
    % 21 October 2017
    %
    % Revision 21/10/17
    %
    % function ground_track(R0, V0, dt, step, mu)
    %
    % Purpose:  This function plots the ground track of a satellite in the
    %           geocentric frame of reference. Additionally, it creates a
    %           video of the ground track.
    % 
    % Inputs:   o R0    - A 1x3 vector of the satellite's initial position
    %           o V0    - A 1x3 vector of the satellite's initial velocity
    %           o dt    - The final time in seconds [s]
    %           o step  - The step sized used to determine how often to
    %                     calculate position and velocity in seconds [s]
    %           o mu    - standard grav param [OPTIONAL]
    %           o Re    - central body radius [OPTIONAL]
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
    
    load topo %#ok<*LOAD>
    
    %% Calculate classic orbital elements
    [h, e, i, omega, w, theta] = coe_from_rv(R0, V0, mu);
    
    a = abs( (h^2/mu) * 1/(e^2 - 1) );
    
    %% Calculate rate of change omega and w
    incl = i*(pi/180);
     
    fac = -3/2*sqrt(mu)*J2*Re^2/(1-e^2)^2/a^(7/2);
    
    domega = fac*cos(incl);
    dw     = fac*(5/2*sin(incl)^2 - 2);
    
    %% Find time since perigee
    E0 = ecc_anomaly_from_ta(theta,e);
    M0 = E0 - e*sin(E0);
    T  = 2*pi/sqrt(mu)*a^(3/2);
    t0 = (M0/(2*pi)) * T;
    tf = t0 + n*T;
   
    %% Calculate the RA and dec
    timeint = linspace(t0,tf,100);
    ind = 1;
    
    for j = 1:length(timeint)
        Me = (2*pi/T)*timeint(j);
        E  = ecc_anomaly_from_M(e, Me);
        th = ta_from_E(E,e);

        omega = omega + domega * timeint(j);
        w     = w + dw * timeint(j);

        [r, v] = rv_from_coe(h, e, i, omega, w, th);
        theta  = we * timeint(j); 
        rprime = rot3(theta)*r;

        [RA(ind), dec(ind)] = R2RA_Dec(rprime); %#ok<*SAGROW,*AGROW>
        
        ind = ind + 1;
    end
    
    %% Plot the ground track
    figure('units','normalized','outerposition',[0 0 1 1])


    image([0 360],[-90 90],flip(topo), 'CDataMapping', 'scaled')
    colormap(topomap2)

    axis equal                                % set axis units to be the same size

    ax = gca;                                 % get current axis               
    ax.XLim = [0 360];                        % set x limits
    ax.YLim = [-90 90];                       % set y limits
    ax.XTick = [0 60 120 180 240 300 360];    % define x ticks
    ax.YTick = [-90 -60 -30 0 30 60 90];      % define y ticks
    ax.YTickLabels= [{'90N', '60N', '30N', '0', '30S', '60S', '90S'}];

    ylabel('Latitude [deg]');
    xlabel('Longitude [deg]');
    title('Satellite Ground Track');
    text(RA(1), dec(1), 'o Start')
    text(RA(end), dec(end), 'o Finish')
    hold on;

    for i = 1:length(RA)
        scatter(RA(i),dec(i),'.w');
    end
end