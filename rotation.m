function r = rotation(R,th,phi,rho)
    %% Coordinate Rotation once about each axis
    %
    % Jeremy Penn
    % 18 October 2017
    %
    % Revision  22/09/17
    %
    % function r = rotation(R,th,phi,rho)
    %
    % Purpose:  This program calculates the new position vector after applying
    %           rotations of th(x-axis), phi(y-axis), and rho(z-axis).
    % 
    % Inputs:   o R     - A 1x3 vector to be rotated.
    %           o th    - The rotation angle about the x-axis.
    %           o phi   - The rotation angle about the y-axis.
    %           o rho   - The rotation angle about the z-axis.
    %
    % Outputs:  o r     - The new vector after rotation.
    %
    % Requires: rot1.m, rot2.m, rot3.m
    %

    clear r; clc;
    
    %% Make sure angles are between 0 and 360
    th = mod(th,360);
    phi = mod(phi,360);
    rho = mod(rho,360);
    
    %% Convert degrees to radians
    th = th * pi/180;
    phi = phi * pi/180;
    rho = rho * pi/180;
    
    %% Check R is a column vector
    
    if isrow(R)
       R = transpose(R);
    end
    
    %% Set up the rotation matrix
    
    rotx = rot1(th);
    roty = rot2(phi);
    rotz = rot3(rho);
    
    %% Perform the rotation
    
    r = rotx*roty*rotz*R;
    
    %% Display new vector
    
    fprintf('The x componant after rotation is %4.2f\n', r(1))
    fprintf('The y componant after rotation is %4.2f\n', r(2))
    fprintf('The z componant after rotation is %4.2f\n', r(3))
end

