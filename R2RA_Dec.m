function [al , del] = R2RA_Dec(r)
%% Convert Cartesian Coordinates to Right Ascension and Declination
%
% Jeremy Penn
% 22 September 2017
%

    del = acos(r(3)/norm(r));
    al  = atan(r(2) / r(1));
%
end