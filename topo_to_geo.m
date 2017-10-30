function topo_to_geo(th, phi, A, a)
    %% Coverts from topocentric to geocentric coordinates
    %
    % Jeremy Penn
    % 22/10/2017
    %
    % Revision: 22/10/2017
    %
    % function topo_to_geo(Del, th, phi, A, a)
    %
    % Input:    o th    - The local sidereal time [deg]
    %           o phi   - The latitude of the observer [deg]
    %           o A     - The azimuth angle of the target [deg]
    %           o a     - The angular elevation of the object [deg]
    %
    % Requires: ra_and_dec_from_r.m
    %
    
    clc;
    
    %% Convert from degrees to radians
    th  = th * pi/180;
    phi = phi * pi/180;
    A   = A * pi/180;
    a   = a * pi/180;
    
    %% Set up the rotation matrix
    Q = [-sin(th), -sin(phi)*cos(th), cos(phi)*cos(th); cos(th), -sin(phi)*sin(th), cos(phi)*sin(th); 0, cos(phi), sin(phi)];
    
    %% Calculate the position in topo coordinates, rho
    rho = [cos(a)*sin(A); cos(a)*cos(A); sin(a)];
    
    %% Convert coordinates
    r = Q*rho;
    
    %% Calculate the RA and Dec
    [RA,Dec] = ra_and_dec_from_r(r);
    
    fprintf('The RA of the object in the Geocentric frame is %5.2f [deg]\n',RA)
    fprintf('The Dec of the object in the Geocentric frame is %5.2f [deg]\n',Dec)
end