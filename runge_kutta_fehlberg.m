function [tout, yout] = runge_kutta_fehlberg(ode_function, tspan, y0, tolerance)
    %% Runge Kutta Fehlberg Numerical Integration
    %
    % Jeremy Penn
    % 02 November 2017
    %
    % Revision: 02/11/2017
    %
    % function [tout, yout] = runge_kutta_fehlberg(ode_function, tspan, y0, tolerance)
    %
    % Purpose:  This function uses the Runge-Kutta-Fehlberg method for
    %           numerical integration of the given ode.
    %
    % Input:    o ode_function  - The function to be integrated
    %           o tspan         - 1x2 vector which gives the initial and
    %                             final time
    %           o y0            - The inital conditions
    %           o tolerance     - The desired solution tolerance
    %
    % Output:   o tout          - The vector of time intervals.
    %           o yout          - The value vector.
    %
    
a = [0 1/4 3/8 12/13 1 1/2];

b = [    0          0          0          0         0
        1/4         0          0          0         0
        3/32       9/32        0          0         0
     1932/2197 -7200/2197  7296/2197      0         0
      439/216      -8      3680/513   -845/4104     0
       -8/27        2     -3544/2565  1859/4104  -11/40];

c4 = [25/216  0  1408/2565    2197/4104   -1/5    0  ];
c5 = [16/135  0  6656/12825  28561/56430  -9/50  2/55]; 

if nargin < 4
    tol  = 1.e-8;
else
    tol = tolerance;
end

t0   = tspan(1);
tf   = tspan(2);
t    = t0;
y    = y0;
tout = t;
yout = y';
h    = (tf - t0)/100; % Assumed initial time step.

while t < tf
    hmin = 16*eps(t);
    ti   = t;
    yi   = y;
    %...Evaluate the time derivative(s) at six points within the current
    %   interval:
    for i = 1:6
        t_inner = ti + a(i)*h;
        y_inner = yi;
        for j = 1:i-1
            y_inner = y_inner + h*b(i,j)*f(:,j);
        end
        f(:,i) = feval(ode_function, t_inner, y_inner);
    end

    %...Compute the maximum truncation error:
    te     = h*f*(c4' - c5'); % Difference between 4th and
                              % 5th order solutions
    te_max = max(abs(te));    
   
    %...Compute the allowable truncation error:
    ymax       = max(abs(y));
    te_allowed = tol*max(ymax,1.0);
    
    %...Compute the fractional change in step size:
    delta = (te_allowed/(te_max + eps))^(1/5);
     
    %...If the truncation error is in bounds, then update the solution:
    if te_max <= te_allowed
        h     = min(h, tf-t);
        t     = t + h;
        y     = yi + h*f*c5';      
        tout  = [tout;t];
        yout  = [yout;y'];
    end
    
    %...Update the time step:
    h  = min(delta*h, 4*h);
    if h < hmin
        fprintf(['\n\n Warning: Step size fell below its minimum\n'...
                 ' allowable value (%g) at time %g.\n\n'], hmin, t)
        return
    end  
end