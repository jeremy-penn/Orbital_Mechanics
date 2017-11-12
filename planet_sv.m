function [R, V, jd] = planet_sv(planet_id, d, m, y, UT)
    %% Calculate the sidereal time from the given date and UT time
    %
    % Jeremy Penn
    % 09 November 2017
    %
    % Revision  09/11/17
    %           11/11/2017 - Added jd output for use with
    %                        interplanetary_trajectory.m
    %           
    % function [R, V] = planet_sv(planet_id, d, m, y, UT)
    %
    % Purpose:  This function calculates the sidereal time.
    % 
    % Inputs:   o planet_id     - A string name of the planet
    %           o d             - The day
    %           o m             - The month
    %           o y             - The year
    %           o UT            - The hour
    %
    % Outputs:  o R     - The heliocentric position
    %           o V     - The heloiocentric velocity
    %           o jd    - The Julian Day (J2000 epoch) 
    %
    clc;
    
    %% constants
    mu = 1.327e11; %[km^3 / s^2] grav param of the Sun
    
    %% convert the planet input
    planet_id = lower(planet_id);
    
    switch planet_id
        case 'mercury'
            planet_id = 1;
        case 'venus'
            planet_id = 2;
        case 'earth'
            planet_id = 3;
        case 'mars'
            planet_id = 4;
        case 'jupiter'
            planet_id = 5;
        case 'saturn'
            planet_id = 6;
        case 'uranus'
            planet_id = 7;
        case 'neptune'
            planet_id = 8;
        case 'pluto'
            planet_id = 9;
        otherwise
            error(strcat(planet_id,' is not a planet'));
    end
    
    %% calculate JD
    j0 = 367*y - fix(7*(y + fix((m + 9)/12))/4) + fix((275*m)/9) + d + 1721013.5;
    jd = j0 + UT/24;
    
    %% calculate T0
    T0 = (jd  - 2451545) / 36525;
    
    %% search table and adjust orbital elements for JD
    [J2000_coe, rates] = planetary_elements(planet_id);
    
    coe = J2000_coe + rates*T0;
    
    %% ensure all angles are between 0 and 360
    a       = coe(1);
    e       = coe(2);
    inc     = mod(coe(3), 360);
    W       = mod(coe(4), 360);
    w_hat   = mod(coe(5), 360);
    L       = mod(coe(6), 360);
    w       = mod(w_hat - W ,360);
    M       = mod(L - w_hat  ,360);
    
    %% calculate h
    h = sqrt( mu*a*(1 - e^2) );
    
    %% calculate the eccentric anomaly
    E = ecc_anomaly_from_M(e, M*pi/180);
    E = E * 180/pi;
    
    %% calculate the true anomaly
    th = ta_from_E(E, e);
    
    %% calculate the state vector from coe
    [R,V] = rv_from_coe(h, e, inc, W, w, th, mu);
    
    
    function [J2000_coe, rates] = planetary_elements(planet_id)
        %{
  This function extracts a planet's J2000 orbital elements and
  centennial rates from Table 8.1.
 
  planet_id      - 1 through 9, for Mercury through Pluto
 
  J2000_elements - 9 by 6 matrix of J2000 orbital elements for the nine
                   planets Mercury through Pluto. The columns of each
                   row are:
                     a     = semimajor axis (AU)
                     e     = eccentricity
                     i     = inclination (degrees)
                     RA    = right ascension of the ascending
                             node (degrees)
                     w_hat = longitude of perihelion (degrees)
                     L     = mean longitude (degrees)
 
  cent_rates     - 9 by 6 matrix of the rates of change of the
                   J2000_elements per Julian century (Cy). Using "dot"
                   for time derivative, the columns of each row are:
                     a_dot     (AU/Cy)
                     e_dot     (1/Cy)
                     i_dot     (deg/Cy)
                     RA_dot    (deg/Cy)
                     w_hat_dot (deg/Cy)
                     Ldot      (deg/Cy)
 
  J2000_coe      - row vector of J2000_elements corresponding
                   to "planet_id", with au converted to km
  rates          - row vector of cent_rates corresponding to
                   "planet_id", with au converted to km
 
  au             - astronomical unit (149597871 km)
        %}
        % --------------------------------------------------------------------
        
        %---- a ----------- e --------- i ---------- RA ------- w_hat ------- L ------
        
        J2000_elements = ...
            [0.38709927  0.20563593  7.00497902  48.33076593  77.45779628  252.25032350
            0.72333566  0.00677672  3.39467605  76.67984255 131.60246718  181.97909950
            1.00000261  0.01671123 -0.00001531   0.0        102.93768193  100.46457166
            1.52371034  0.09339410  1.84969142  49.55953891 -23.94362959 	-4.55343205
            5.20288700  0.04838624  1.30439695 100.47390909  14.72847983 	34.39644501
            9.53667594  0.05386179  2.48599187 113.66242448  92.59887831 	49.95424423
            19.18916464  0.04725744  0.77263783  74.01692503 170.95427630  313.23810451
            30.06992276  0.00859048  1.77004347 131.78422574  44.96476227  -55.12002969
            39.48211675  0.24882730 17.14001206 110.30393684 224.06891629  238.92903833];
        
        cent_rates = ...
            [0.00000037  0.00001906 -0.00594749 -0.12534081  0.16047689  149472.67411175
            0.00000390 -0.00004107 -0.00078890 -0.27769418  0.00268329	  58517.81538729
            0.00000562 -0.00004392 -0.01294668  0.0         0.32327364   35999.37244981
            0.0001847 	 0.00007882 -0.00813131 -0.29257343  0.44441088   19140.30268499
            -0.00011607 -0.00013253 -0.00183714  0.20469106	 0.21252668    3034.74612775
            -0.00125060 -0.00050991  0.00193609 -0.28867794 -0.41897216    1222.49362201
            -0.00196176 -0.00004397 -0.00242939  0.04240589  0.40805281 	428.48202785
            0.00026291  0.00005105  0.00035372 -0.00508664 -0.32241464 	218.45945325
            -0.00031596  0.00005170  0.00004818 -0.01183482 -0.04062942 	145.20780515];
        
        J2000_coe      = J2000_elements(planet_id,:);
        rates          = cent_rates(planet_id,:);
        
        %...Convert from AU to km:
        au             = 149597871;
        J2000_coe(1)   = J2000_coe(1)*au;
        rates(1)       = rates(1)*au;
        
    end %planetary_elements
end