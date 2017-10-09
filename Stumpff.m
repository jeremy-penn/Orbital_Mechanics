function [Cz, Sz] = Stumpff(z)
%% Stumpff Functions
%
% Jeremy Penn
% 22 September 2017
%

     if (z > 0)
         Sz = (z^0.5 -sin(z^0.5))/z^1.5;    %C3 Stumpff
         Cz = (1 - cos(z^0.5))/z;           %C2 Stumpff
     elseif (z < 0)
         Sz = (sinh(-z^0.5) - (-z)^0.5)/((-z)^1.5); %C3 Stumpff (negative argument)
         Cz = (cosh(-z^0.5) - 1)/(-z);              %C2 Stumpff (negative argument)
     else
         Sz = 1/6;
         Cz = 0.5;
     end
%     
end

