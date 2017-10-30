function rot1 = rot1(th)
    %% Create the rotation matrix about the x-axis
    %
    % Jeremy Penn
    % 18 October 2017
    %
    % Revision  22/09/17
    %           
    % function rot1 = rot1(th)
    %
    % Purpose:  This function calculates the rotation matrix about the
    %           x-axis
    % 
    % Inputs:   o th - The rotation angle. [rad]
    % 
    % Output:   o rot1 - Rotation matrix about the x-axis.
    %
    
    %% Create the matrix
    
    rot1 = [1,0,0;0,cos(th),sin(th);0,-sin(th),cos(th)];
end