function [al , del] = R2RA_Dec(r)
%R2RA_DEC converts cartesian coordinates to Right Ascension 
%         and Declenation.


del = acos(r(3)/norm(r));
al  = atan(r(2) / r(1));
end

