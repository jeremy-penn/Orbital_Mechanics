function F = hyp_anomaly(e, M)
    %% Calculates the hyperbolic anomaly
    %
    % Jeremy Penn
    % 22 October 2017
    %
    % Revision  22/10/17
    %           
    % function F = hyp_anomaly(e, M)
    %
    % Purpose:  This function calculates the hyperbolic anomaly given the
    %           eccentricity and hyperbolic mean anomaly.
    % 
    % Inputs:   o e     - Eccentricity
    %           o M     - Mean anomaly [radians]
    %
    % Outputs:  o F     - Hyperbolic anomaly [radians]
    %
    
    clc; clear F;
    
    %% Initial guess
    F = M;
    
    %% Calculate F until within desired tolerance
    tol   = 1e-08;
    ratio = 1;
    
    while abs(ratio) > tol
        ratio = (e*sinh(F) - F - M) / (e*cosh(F) - 1);
        F     = F - ratio;
    end
    
    fprintf('The hyperbolic anomaly is %4.4f [rad]\n',F)