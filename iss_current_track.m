function iss_current_track()
    %% pulls current ISS two-line element from NORAD website
    %{
    Jeremy Penn
    20/11/2017
    Updated: 24/06/2018
    
    function iss_current_track()
    
    Requires: ecc_anomaly_from_ta.m, ecc_anomaly_from_M.m, ta_from_E.m,
               rv_from_coe.m, rot3.m, ra_and_dec_from_r.m, earth.png
    %}
    
    %% constants
    n_orbits = input('Input the number of orbits:\n');
    Re  = 6378;          % [km] radius of the Earth
    we  = 7.27e-5;       % [rad/s] angular speed of Earth
    mu  = 398600;        % [km^3/s^2] Standard Gravitational Parameter
    J2  = 0.0010836;
    
    %% url to pull data
    url = 'http://www.celestrak.com/NORAD/elements/stations.txt';
    
    %% pull request for orbital data
    data = webread(url);
    
    %% isolate the ISS TLE
    sl = strsplit(data,'\n');
    
    for i = 1:3 % isolate the first 3 lines (ISS)
        ss{i} = strsplit(sl{i},' ');
    end
    
    ss{3}{5} = strcat('0.',ss{3}{5});
    
    for lj = 1:length(ss{3}) - 1
        coe(lj) = str2double(ss{3}{lj});
    end
    coe(8) = str2double( extractBefore(ss{3}{8},12) );
    
    %% separate coe
    inc = coe(3);           % orbital inclination [deg]
    W   = coe(4);           % longitude of the ascending node [deg]
    e   = coe(5);           % eccentricity
    w   = coe(6);           % argument of perigee [deg]
    M   = coe(7) * pi/180;  % mean anomaly [rad]
    n   = coe(8);           % mean motion [rev/d]
    
    %% Calculate the semi-major axis
    n = n * pi/43200;               % [rad/s] convert from rev/d
    a = (mu^(1/3)) / (n^(2/3));     % semi-major axis [km]
    h = sqrt( a * mu * (1 - e^2) ); % specific angular momentum [km^2/s]
    
    %% calculate the ground track
    ground_track_from_tle(inc, W, e, w, M, n)
    
    %% ouput the results
    output
    
    return
    
    %%-------------subfunctions---------------------------------
    function ground_track_from_tle(i, omega, e, w, M, n)
        % Calculate and plot the geocentric orbit of a satellite about the Earth

        %
        % Input:    o M     - mean anomaly [rad]
        %           o e     - eccentricity
        %           o i     - orbital inclination [deg]
        %           o omega - right ascension of the ascending node [deg]
        %           o w     - argument of perigee [deg]
        %           o n     - mean motion [rad/s]
        %
        
        % Calculate rate of change omega and w
        incl = i*(pi/180);
        
        fac = -3/2*sqrt(mu)*J2*Re^2/(1-e^2)^2/a^(7/2);
        
        domega = fac*cos(incl);
        dw     = fac*(5/2*sin(incl)^2 - 2);
        
        % Find time since perigee
        T  = 2*pi/n;
        t0 = (M/(2*pi)) * T;
        tf = t0 + n_orbits*T;
        
        % Calculate the RA and dec
        timeint = linspace(t0,tf,1000);
        ind = 1;
        
        for j = 1:length(timeint)
            Me = (2*pi/T)*timeint(j);       % mean anomaly at time t
            E  = ecc_anomaly_from_M(e, Me); % eccentric anomaly at time t
            th = ta_from_E(E,e);            % true anomaly at time t
            
            omega = omega + domega * timeint(j);
            w     = w + dw * timeint(j);
            
            [r, v] = rv_from_coe(h, e, i, omega, w, th*180/pi);
            theta  = we * timeint(j);
            rprime = rot3(theta)*r;
            
            [RA(ind), del(ind)] = ra_and_dec_from_r(rprime); %#ok<*NASGU,*SAGROW,*AGROW>
            
            ind = ind + 1;
        end
        
        % Separate the data into individual orbit lines
        [ra, dec, n_curves] = form_separate_curves(RA, del);
        
        % Plot the ground track
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
        end %form_separate_curves
    end %ground_track
    
    function output
        clc;
        r_a = (1 + e)*a;
        r_p = (1 - e)*a;
        v_p = sqrt( ((1+e)*mu)/((1-e)*a) );
        v_a = sqrt( ((1-e)*mu)/((1+e)*a) );
        
        fprintf('----------------------------------------------\n')
        fprintf('Current ISS orbital elements: \n')
        fprintf('----------------------------------------------\n\n')
        fprintf('\t h   = %.2f [km^2/s]\n', h)
        fprintf('\t a   = %.2f [km]\n', a)
        fprintf('\t r_a = %.2f [km]\n', r_a)
        fprintf('\t r_p = %.2f [km]\n',r_p)
        fprintf('\t i   = %.2f [deg]\n',inc)
        fprintf('\t e   = %.4f \n',e)
        fprintf('\t W   = %.2f [deg]\n',W)
        fprintf('\t w   = %.2f [deg]\n\n',w)
        fprintf('----------------------------------------------\n')
        fprintf('Orbital altitude and speed: \n')
        fprintf('----------------------------------------------\n\n')
        fprintf('Maximum altitude: %.2f [km]\n',r_a - Re)
        fprintf('Minimum altitude: %.2f [km]\n',r_p - Re)
        fprintf('Maximum speed:    %.2f [km/s]\n',v_p)
        fprintf('Minimum speed:    %.2f [km/s]\n',v_a)
        fprintf('Orbital energy:   %.2f [MJ/kg]\n',-mu/(2*a))
        fprintf('\n\n')
    end %output
end %iss_current_track