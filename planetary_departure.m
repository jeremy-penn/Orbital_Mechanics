function planetary_departure(R1, R2, r, mu_e, Re)
    %% Calculate the deltav and ejection angle for planetary transfer
    %
    % Jeremy Penn
    % 09 November 2017
    %
    % Revision: 09/11/17
    %
    % function planetary_departure(R1, R2, r, mu_e)
    %
    % Input:    o R1    - orbital radius of the inital planet
    %           o R2    - orbital radius of the target planet
    %           o r     - orbital height above the surface of initial
    %                     planet
    %           o mu_e  - standard grav param [OPTIONAL]
    %           o Re    - planetary radius [OPTIONAL]
    %
    %
    clc;
    
    %% constants
    mu_s = 1.327e11; %[km^3 / s^2] gravitational param of the Sun
    
    if nargin == 3
        Re   = 6378;     %[km] radius of the Earth
        mu_e = 398600;   %[km^3 / s^2] gravitational param of the Earth
    end
    
    %% calculate the hyperbolic excess velocity
    vinf = sqrt( mu_s / R1 ) * ( sqrt(2*R2 / (R1+R2)) -1 );
    
    %% calculate the speed of the parking orbit
    vc = sqrt( mu_e / (Re+r) );
    
    %% delta-v for the hyperbolic escape trajectory
    dv = vc * ( sqrt( 2 + (vinf/vc)^2 ) -1 );
    dv = dv * 1000;
    
    %% calculate the escape angle
    e = 1 + ( (Re+r)*vinf^2 ) / mu_e;
    
    beta = acos(1/e);
    
    beta = beta * 180/pi;
    
    beta = mod(beta,360);
    
    %% print the results
    fprintf('The delta-v of the trans-planetary injection burn is %.2f [m/s]\n',dv)
    fprintf('The ejection angle is %.2f [deg]\n', beta)
end