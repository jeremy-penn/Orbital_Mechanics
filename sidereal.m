function stime = sidereal(y, m, d,h, min, sec,gam)
    %% Calculate the sidereal time from the given date and UT time
    %
    % Jeremy Penn
    % 21 October 2017
    %
    % Revision  21/10/17
    %           
    % function stime = sidereal(y, m, d,h, min, sec)
    %
    % Purpose:  This function calculates the sidereal time.
    % 
    % Inputs:   o y     - The year
    %           o m     - The month
    %           o d     - The day
    %           o h     - The hour
    %           o min   - The minutes
    %           o sec   - The seconds
    %           o gam   - The eastward longitude
    %
    % Outputs:  o stime - The sidereal time
    %
    
    j0 = 367*y - fix(7*(y + fix((m + 9)/12))/4) + fix((275*m)/9) + d + 1721013.5;
    T0 = (j0 - 2451545) / 36525;
    
    thg0 = 100.4606184 + 36000.77004*T0 + 0.000387933*T0^2 - 2.583e-08*T0^3;
    
    while thg0 > 360
        thg0 = thg0 - 360;
    end
    
    while thg0 < 0
        thg0 = 360 + thg0;
    end
    
    UT  = h + min/60 + sec/3600;
    thg = thg0 + 360.98564724*(UT/24);
    th  = thg + gam; 
    
    while th > 0
        th = th - 360;
    end
    
    while th < 0
        th = 360 + th;
    end
    
    stime = th;
    
    fprintf('The local sidereal time is %5.2f',stime)
end