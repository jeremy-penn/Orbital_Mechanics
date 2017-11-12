function interplanetary_trajectory()
    %% Calculates the interplanetary COE, ejection angle, & hyperbolic excess velocities
    %
    % Jeremy Penn
    % 11 November 2017
    %
    % Revision  11/11/2017
    %
    % function interplanetary_trajectory()
    %
    % Purpose:  This function calculates the sidereal time.
    %
    % Required: planet_sv.m, lambert.m, coe_from_rv.m
    %
    clc;
    
    mu = 132.71e9; % [km^3/s^2]
    
    %% inputs
    planet1 = input('Input the departing planet:\n','s');
    planet1 = lower(planet1);
    
    planet2 = input('Input the target planet:\n','s');
    planet2 = lower(planet2);
    
    date1 = input('Input the departure date & time (dd/mm/yyyy/tt & 24-hour clock):\n','s');
    split1 = strsplit(date1, '/');
    
    d1 = str2double(split1{1});
    m1 = str2double(split1{2});
    y1 = str2double(split1{3});
    UT1 = str2double(split1{4});
    
    date2 = input('Input the arrival date & time (dd/mm/yyyy/tt & 24-hour clock):\n','s');
    split2 = strsplit(date2, '/');
    
    d2 = str2double(split2{1});
    m2 = str2double(split2{2});
    y2 = str2double(split2{3});
    UT2 = str2double(split2{4});
    
    %% calculate the state vector of planet 1 at departure
    [R1, V1, jd1] = planet_sv(planet1, d1, m1, y1, UT1);
    
    %% calculate the state vector of planet 2 at arrival
    [R2, V2, jd2] = planet_sv(planet2, d2, m2, y2, UT2);
    
    %% calculate the flight time
    t12 = jd2 - jd1;
    t12 = t12 * 86400; %convert days to seconds
    
    %% solve lambert's problem for the velocities at departure & arrival
    [vd, va] = lambert(R1, R2, t12, 1e-8, mu);
    
    %% calculate the hyperbolic excess velocities at departure & arrival
    V_inf_D = vd - V1;
    V_inf_A = va - V2;
    
    %% calculate the coe of the transfer orbit
    [h, e, inc, W, w, theta] = coe_from_rv(R1, vd, mu);
    a = (h^2/mu)*(1/(1-e^2));
    
    inc = mod(inc, 360);
    W = mod(W, 360);
    w = mod(w, 360);
    theta = mod(theta, 360);
    
    %% print the results
    dd = num2str(d1);
    md = num2str(m1);
    yd = num2str(y1);
    
    da = num2str(d2);
    ma = num2str(m2);
    ya = num2str(y2);
    
    date_depart = strcat(dd,'/',md,'/',yd);
    date_arrive = strcat(da,'/',ma,'/',ya);
    
    planet_d = replace(planet1,planet1(1),upper(planet1(1)));
    planet_a = replace(planet2,planet2(1),upper(planet2(1)));
    
    disp('---------------------------------------------------------------')
    fprintf('The state vector for %s on %s: \n', planet_d,date_depart);
    disp('---------------------------------------------------------------')
    fprintf('\t r_d = %.4e*i + %.4e*j + %.4e*k [km]\n',R1)
    fprintf('\t v_d = %.4f*i + %.4f*j + %.4f*k [km/s]\n',V1)
    
    disp('---------------------------------------------------------------')
    fprintf('The state vector for %s on %s: \n', planet_a,date_arrive);
    disp('---------------------------------------------------------------')
    fprintf('\t r_a = %.4e*i + %.4e*j + %.4e*k [km]\n',R2)
    fprintf('\t v_a = %.4f*i + %.4f*j + %.4f*k [km/s]\n',V2)
    
    disp('---------------------------------------------------------------')
    disp('The orbital elements of the transfer trajectory: ')
    disp('---------------------------------------------------------------')
    fprintf('\t h    = %.4e [km^2/s]\n',h)
    fprintf('\t e    = %.4f\n',e)
    fprintf('\t i    = %.4f [deg]\n',inc)
    fprintf('\t W    = %.4f [deg]\n',W)
    fprintf('\t w    = %.4f [deg]\n',w)
    fprintf('\t th_d = %.4f [deg]\n',theta)
    fprintf('\t a    = %.4e [km]\n',a)
    
    disp('---------------------------------------------------------------')
    disp('The transfer elements: ')
    disp('---------------------------------------------------------------')
    fprintf('\t t12     = %.2f [days]\n',t12/86400);
    fprintf('\t V_inf_D = %.4f*i + %.4f*j + %.4f*k [km/s]\n',V_inf_D);
    fprintf('\t speed_d = %.4f [km/s]\n',norm(V_inf_D));
    fprintf('\t V_inf_A = %.4f*i + %.4f*j + %.4f*k [km/s]\n',V_inf_A);
    fprintf('\t speed_a = %.4f [km/s]\n',norm(V_inf_A));
    
end