function [RA , dec] = ra_and_dec_from_r(r)
    %% Convert Cartesian Coordinates to Right Ascension and Declination
    %
    % Jeremy Penn
    % 22 September 2017
    %
    % Revision  22/09/17
    %           
    % function [RA , dec] = R2RA_Dec(r)
    %
    % Purpose:  This function converts the position vector, r, into the
    %           Right Acension and Declination.
    % 
    % Inputs:   o r - a 1x3 vector of the x, y and z positions of the
    %                 satellite.
    % 
    % Output:   o RA - The Right Ascension [deg]
    %           o dec - The Declination    [deg]
    %
    l = r(1)/norm(r);
    m = r(2)/norm(r);
    n = r(3)/norm(r);

    dec = asin(n);
    
    if m > 0
        RA = acos(l/cos(dec))*180/pi;
    else
        RA = 360 - acos(l/cos(dec))*180/pi;
    end
    
    dec = dec*180/pi;
end