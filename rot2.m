function rot2 = rot2(th)
    %% Create the rotation matrix about the y-axis
    %
    % Jeremy Penn
    % 18 October 2017
    %
    % Revision  22/09/17
    %           
    % function rot2 = rot2(th)
    %
    % Purpose:  This function calculates the rotation matrix about the
    %           y-axis
    % 
    % Inputs:   o th - The rotation angle.
    % 
    % Output:   o rot2 - Rotation matrix about the y-axis.
    %
    
    %% Create the matrix
    
    rot2 = [cos(th),0,-sin(th);0,1,0;sin(th),0,cos(th)];
end