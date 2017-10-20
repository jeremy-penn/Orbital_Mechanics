function [al , del] = R2RA_Dec(r)
    %% Convert Cartesian Coordinates to Right Ascension and Declination
    %
    % Jeremy Penn
    % 22 September 2017
    %
    % Revision  22/09/17
    %           
    % function [al , del] = R2RA_Dec(r)
    %
    % Purpose:  This function converts the position vector, r, into the
    %           Right Acension and Declination.
    % 
    % Inputs:   o r - a 1x3 vector of the x, y and z positions of the
    %                 satellite.
    % 
    % Output:   o al - The Right Ascension
    %           o del - The Declination
    %

    del = acos(r(3)/norm(r));
    al  = atan(r(2) / r(1));
%
end