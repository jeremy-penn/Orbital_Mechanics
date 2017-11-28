function ground_track_from_tle(i, omega, e, w, M, n)
    %% Calculate and plot the geocentric orbit of a satellite about the Earth
    %
    % Jeremy Penn
    % 20/11/17
    %
    % Revision: 21/10/2017
    %           29/10/2017 - Changed RA from 0:360 to -180:180
    %           30/10/2017 - Reverted back to 0:360. Changed map to make
    %                        plot lines more readable. Also fixed an issue
    %                        with inverted y-axis from image import.
    %
    % function ground_track_from_tle(i, omega, e, w, M, n)
    %
    % Purpose:  This function plots the ground track of a satellite in the
    %           geocentric frame of reference from the two line element.
    %
    % Input:    o M     - mean anomaly [deg]
    %           o e     - eccentricity
    %           o i     - orbital inclination [deg]
    %           o omega - right ascension of the ascending node [deg]
    %           o w     - argument of perigee [deg]
    %           o n     - mean motion [rev/d]
    %
    % Requires: ecc_anomaly_from_ta.m, ecc_anomaly_from_M.m, ta_from_E.m,
    %           rv_from_coe.m, rot3.m, ra_and_dec_from_r.m, earth.png
    %
    
    clc;
    %% constants
    n_orbits = input('Input the number of orbits:\n');
    Re  = 6378;          % [km] radius of the Earth
    we  = 7.27e-5;       % [rad/s] angular speed of Earth
    mu  = 398600;        % [km^3/s^2] Standard Gravitational Parameter
    J2  = 0.0010836;
    
    n = n * pi/43200;    % [rad/s] convert from rev/d
    %% Calculate the semi-major axis
    a = (mu^(1/3)) / (n^(2/3));
    h = sqrt( a * mu * (1 - e^2) );
    
    %% Calculate rate of change omega and w
    incl = i*(pi/180);
    
    fac = -3/2*sqrt(mu)*J2*Re^2/(1-e^2)^2/a^(7/2);
    
    domega = fac*cos(incl);
    dw     = fac*(5/2*sin(incl)^2 - 2);
    
    %% Find time since perigee
    T  = 2*pi/n;
    t0 = (M/(2*pi)) * T;
    tf = t0 + n_orbits*T;
    
    %% Calculate the RA and dec
    timeint = linspace(t0,tf,1000);
    ind = 1;
    
    for j = 1:length(timeint)
        Me = (2*pi/T)*timeint(j);
        E  = ecc_anomaly_from_M(e, Me);
        th = ta_from_E(E,e);
        
        omega = omega + domega * timeint(j);
        w     = w + dw * timeint(j);
        
        [r, v] = rv_from_coe(h, e, i, omega, w, th*180/pi);
        theta  = we * timeint(j);
        rprime = rot3(theta)*r;
        
        [RA(ind), del(ind)] = ra_and_dec_from_r(rprime); %#ok<*NASGU,*SAGROW,*AGROW>
        
        ind = ind + 1;
    end
    
    %% Separate the data into individual orbit lines
    [ra, dec, n_curves] = form_separate_curves(RA, del);
    
    %% Plot the ground track
    
    figure('units','normalized','outerposition',[0 0 1 1])
    map = imread('~/Documents/earth.png');
    image([0 360],[-90 90], flip(map), 'CDataMapping','scaled');
    
    axis equal                                % set axis units to be the same size
    
    ax = gca;                                 % get current axis
    ax.XLim = [0 360];                        % set x limits
    ax.YLim = [-90 90];                       % set y limits
    ax.XTick = [0 60 120 180 240 300 360];    % define x ticks
    ax.YTick = [-90 -60 -30 0 30 60 90];      % define y ticks
    ax.YTickLabels = {'\bf 90 S', '\bf 60 S', '\bf 30 S', '\bf 0', '\bf 30 N', '\bf 60 N', '\bf 90 N'};
    ax.XTickLabels = {'\bf 0', '\bf 60', '\bf 120','\bf 180', '\bf 240', '\bf 300', '\bf 360'};
    set(gca,'FontSize',16,'Ydir','normal')
    set(gcf,'color',[.43, .43, .43])
    ax.XAxis.Color = 'w';
    ax.YAxis.Color = 'w';
    
    ylabel('Latitude [deg]','FontSize',20,'color','w');
    xlabel('Longitude [deg]','FontSize',20,'color','w');
    title('Satellite Ground Track','FontSize',24,'color','w');
    
    ts = text(ra{1}(1), dec{1}(1), 'o Start','color','black','FontWeight','bold');
    tf = text(ra{end}(end), dec{end}(end), 'o Finish','color','black','FontWeight','bold');
    
    ts.FontSize = 14;
    tf.FontSize = 14;
    
    hold on;
    
    for kk = 1:n_curves
        plot(ra{kk}, dec{kk})
    end
    
    function [RA, Dec, n_curves] = form_separate_curves(ra, dec)
        
        tol = 100;
        curve_no = 1;
        n_curves = 1;
        k = 0;
        ra_prev = ra(1);
        
        for li = 1:length(ra)
            if abs(ra(li) - ra_prev) > tol
                curve_no = curve_no + 1;
                n_curves = n_curves + 1;
                k = 0;
            end
            k = k + 1;
            RA{curve_no}(k) = ra(li);
            Dec{curve_no}(k) = dec(li);
            ra_prev = ra(li);
        end
    end
end