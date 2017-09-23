function [Cz, Sz] = Stumpff(z)
%STUMPFF Generates the Stumpff functions for a given
%        input, z.

     if (z > 0)
         Sz = (z^0.5 -sin(z^0.5))/z^1.5;
         Cz = (1 - cos(z^0.5))/z;
     elseif (z < 0)
         Sz = (sinh(-z^0.5) - (-z)^0.5)/((-z)^1.5);
         Cz = (cosh(-z^0.5) - 1)/(-z);
     else
         Sz = 1/6;
         Cz = 0.5;
     end
end

