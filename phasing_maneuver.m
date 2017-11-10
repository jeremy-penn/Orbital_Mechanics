function phasing_maneuver(Ria,Rip,th,n,mu)
    %% Calculates the apogee and delta-v required for a phasing maneuver
    %
    % Jeremy Penn
    % 24 October 2017
    %
    % Revision: 24/10/17
    %           
    % function phasing_maneuver()
    %
    % Purpose:  This function calculates the phasing orbit and delta-v
    %           requirement for a phasing maneuver. Burns are assumed at
    %           perigee.
    % 
    % Inputs:   o Ria   - The apogee of the initial orbit [km].
    %           o Rip   - The perigee of the initial orbit [km].
    %           o n     - The number of phasing orbits desired [OPTIONAL].
    %           o th    - The true anomaly of the target [deg].
    %           o mu    - The standard grav parameter of the central body
    %                     [OPTIONAL]. Defaults to Earth [km^3/s^2].
    %
    clc;
    
    if nargin == 3
        n =1;
        mu = 398600; %[km^3/s^2]
    end
    
    if nargin == 4
        mu = 398600; %[km^3/s^2]
    end
    
    %% Confirm th is between 0 and 360
    th = mod(th,360);
    
    %% Convert deg to rad
    th = th * (pi/180);
    
    %% Calculate the angular momentum of the initial orbit
    h1 = sqrt( 2*mu ) * sqrt( (Ria*Rip)/(Ria+Rip) );
    
    %% Calculate the period of the primary orbit
    a1  = (1/2) * (Ria+Rip);
    t1  = ( (2*pi)/sqrt(mu) )*( a1^(3/2) );
    
    %% Calculate the eccentricity of the primary orbit
    e = (Ria-Rip) / (Ria+Rip);
    
    %% Calculate the mean anomaly of the target
    Eb = 2 * atan( sqrt( (1-e)/(1+e) ) * tan(th/2) );
    
    %% Calculate the flight time from A to B
    tab = (t1/(2*pi)) * (Eb - e*sin(Eb));
    
    %% Calculate the phasing orbit period
    t2 = t1 - tab/n;
    
    %% Calculate semi-major axis of phasing orbit
    a2 = ( (sqrt(mu)*t2)/(2*pi) )^(2/3);
    
    %% Calculate apogee of phasing orbit
    Rpa = 2*a2 - Rip;
    
    %% Calculate the angular momentum of the phasing orbit
    h2 = sqrt(2*mu) * sqrt( (Rip*Rpa)/(Rip+Rpa) );
    
    %% Calculate velocities
    va1 = h1/Rip;
    va2 = h2/Rip;
    
    dva21 = va2 - va1;
    dva12 = va1 - va2;
    
    % Total delta-v
    dv = abs(dva12)+abs(dva21);
    
    fprintf('The apogee of the phasing obrit is %4.2f [km]\n',Rpa)
    fprintf('The total delta-v required is %4.4f [km/s]\n',dv)
end