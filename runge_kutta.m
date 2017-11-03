function [t,y] = runge_kutta(y0, f, t0, tf, h)
    %% Runge Kutta 4th Order Numerical Method
    %
    % Jeremy Penn
    % 02 November 2017
    %
    % Revision: 02/11/2017
    %
    % function [t,y] = runge_kutta(y0, f, t0, tf, h)
    %
    % Purpose:  This function uses the Runge Kutta method for numerical
    %           integration of the given ode.
    %
    % Input:    o y0    - The value of the function at t0.
    %           o f     - The ode function.
    %           o ti    - The initial time.
    %           o tf    - The final time.
    %           o h     - The step size. Higher numbers are more accurate.
    % Output:   o t     - The vector of time intervals.
    %           o y     - The value vector.
    %
    
   %% Initial conditions 
   y   = y0;
   t   = t0:h:tf;
   
   for i = 1:length(t)-1
       k1  = f(t(i+1), y(i));
       k2  = f(t(i+1) + h/2, y(i) + (h/2) * k1);
       k3  = f(t(i+1) + h/2, y(i) + (h/2) * k2);
       k4  = f(t(i+1) + h, y(i) + h * k3);
       y(i+1)   = (h/6) * (k1 + k2 + k3 + k4);
   end
end