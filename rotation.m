function r = rotation(R,th,phi,rho)
    %% Coordinate Rotation about each axis
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
    % Inputs:   o R0    - A 1x3 vector of the satellite's initial position
    %           o V0    - A 1x3 vector of the satellite's initial velocity
    %           o dt    - The final time in seconds [s]
    %           o step  - The step sized used to determine how often to
    %                     calculate position and velocity in seconds [s]
    %
    % Outputs:  o R     - The new position.
    %           o V     - The new velocity.
    %

    clear r; clc;
    
    %% Make sure angles are between 0 and 360
    
    while th > 360
        th = th - 360;
    end
    
    while phi > 360
        phi = phi - 360;
    end
    
    while rho > 360
        rho = rho - 360;
    end
    
    while th < 0
        th = 360 + th;
    end
    
    while phi < 0
        phi = 360 + phi;
    end
    
    while rho < 0
        rho = 360 + rho;
    end
    
    %% Convert degrees to radians
    th = th * pi/180;
    phi = phi * pi/180;
    rho = rho * pi/180;
    
    %% Check R is a column vector
    
    if isrow(R)
       R = transpose(R);
    end
    
    %% Set up the rotation matrix
    
    rotx = [1,0,0;0,cos(th),sin(th);0,-sin(th),cos(th)];
    roty = [cos(phi),0,-sin(phi);0,1,0;sin(phi),0,cos(phi)];
    rotz = [cos(rho),sin(rho),0;-sin(rho),cos(rho),0;0,0,1];
    
    %% Perform the rotation
    
    r = rotx*roty*rotz*R;
    
    %% Display new vector
    
    fprintf('The x componant after rotation is %4.2f\n', r(1))
    fprintf('The y componant after rotation is %4.2f\n', r(2))
    fprintf('The z componant after rotation is %4.2f\n', r(3))
end

