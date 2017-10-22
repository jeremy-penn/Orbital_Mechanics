function rot3 = rot3(th)
    %% Create the rotation matrix about the y-axis
    %
    % Jeremy Penn
    % 18 October 2017
    %
    % Revision  22/09/17
    %           
    % function rot3 = rot3(th)
    %
    % Purpose:  This function calculates the rotation matrix about the
    %           z-axis
    % 
    % Inputs:   o th - The rotation angle.
    % 
    % Output:   o rot3 - Rotation matrix about the x-axis.
    %
    
    %% Create the matrix
    
    rot3 = [cos(th),sin(th),0;-sin(th),cos(th),0;0,0,1];
end