function E = ecc_anomaly_from_M(e, M)
    %% Calculates the eccentric anomaly
    %
    % Jeremy Penn
    % 22 October 2017
    %
    % Revision  22/10/17
    %           
    % function E = ecc_anomaly(e, M)
    %
    % Purpose:  This function calculates the eccentric anomaly given the
    %           eccentricity and mean anomaly.
    % 
    % Inputs:   o e     - Eccentricity
    %           o M     - Mean anomaly [radians]
    %
    % Outputs:  o E     - Eccentric anomaly [radians]
    %
    
    %% Choose initial estimate for E
    if M < pi
        E = M + e/2;
    else
        E = M - e/2;
    end
    
    %% Calculate the ratio to given tolerance
    tol = 1e-08;
    ratio = 1;
    
    while abs(ratio) > tol
        ratio = (E - e*sin(E) - M)/(1 - e*cos(E));
        E = E - ratio;
    end    
end