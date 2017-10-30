function euler_rotation(R, alpha, beta, gamma)
    %% Computes the "classical" Euler angle sequence
    % This program computes the classical Euler angle sequence
    %
    % Jeremy Penn
    % 18 October 2017
    %
    % Revision 19/10/17
    %
    % function eulerRotation(R, alpha, beta, gamma)
    %
    % Purpose:  This function computes the Euler angle sequence about any 3
    %           axis sequence.
    % 
    % Inputs:   o R     - A 1x3 vector of the satellite's initial position.
    %           o alpha - The primary Euler angle.
    %           o beta  - The secondary Euler angle.
    %           o gamma - The tertiary Euler angle.
    %
    % Requires: rot1.m, rot2.m, rot3.m
    %
    
    clear r; clc;
    %% Check the angles are between 0 and 360
    
    while alpha > 360
        alpha = alpha - 360;
    end
    
    while beta > 360
        beta = beta - 360;
    end
    
    while gamma > 360
        gamma = gamma - 360;
    end
    
    while alpha < 0
        alpha = 360 + alpha;
    end
    
    while beta < 0
        beta = 360 + beta;
    end
    
    while gamma < 0
        gamma = 360 + gamma;
    end
    
    %% Convert to radians
    
    alpha = alpha * pi/180;
    beta  = beta * pi/180;
    gamma = gamma * pi/180;
    
    %% Check that R is a column vector
    
    if isrow(R)
        R = transpose(R);
    end
    
    %% Calculate Euler angle sequences
    str1 = input('Please choose the primary rotation axis ','s');
    str2 = input('Please choose the secondary rotation axis ','s');
    str3 = input('Please choose the tertiary rotation axis ','s');
    
    switch str1
        case 'x'
            switch str2
                case 'x'
                    switch str3
                        case 'z'
                            r = rot1(alpha)*rot1(beta)*rot3(gamma)*R;
                        case 'y'
                            r = rot1(alpha)*rot1(beta)*rot2(gamma)*R;
                        case 'x'
                            r = rot1(alpha)*rot1(beta)*rot1(gamma)*R;
                        otherwise
                            error('Input must be char not a %s',class(str3))
                    end
                case 'y'
                    switch str3
                        case 'z'
                            r = rot1(alpha)*rot2(beta)*rot3(gamma)*R;
                        case 'y'
                            r = rot1(alpha)*rot2(beta)*rot2(gamma)*R;
                        case 'x'
                            r = rot1(alpha)*rot2(beta)*rot1(gamma)*R;
                        otherwise
                            error('Input must be char not a %s',class(str3))
                    end
                case 'z'
                    switch str3
                        case 'z'
                            r = rot1(alpha)*rot3(beta)*rot3(gamma)*R;
                        case 'y'
                            r = rot1(alpha)*rot3(beta)*rot2(gamma)*R;
                        case 'x'
                            r = rot1(alpha)*rot3(beta)*rot1(gamma)*R;
                        otherwise
                            error('Input must be char not a %s',class(str3))
                    end
                otherwise
                    error('Input must be char not a %s',class(str2))
            end
        case 'y'
            switch str2
                case 'x'
                    switch str3
                        case 'z'
                            r = rot2(alpha)*rot1(beta)*rot3(gamma)*R;
                        case 'y'
                            r = rot2(alpha)*rot1(beta)*rot2(gamma)*R;
                        case 'x'
                            r = rot2(alpha)*rot1(beta)*rot1(gamma)*R;
                        otherwise
                            error('Input must be char not a %s',class(str3))
                    end
                case 'y'
                    switch str3
                        case 'z'
                            r = rot2(alpha)*rot2(beta)*rot3(gamma)*R;
                        case 'y'
                            r = rot2(alpha)*rot2(beta)*rot2(gamma)*R;
                        case 'x'
                            r = rot2(alpha)*rot2(beta)*rot1(gamma)*R;
                        otherwise
                            error('Input must be char not a %s',class(str3))
                    end
                case 'z'
                    switch str3
                        case 'z'
                            r = rot2(alpha)*rot3(beta)*rot3(gamma)*R;
                        case 'y'
                            r = rot2(alpha)*rot3(beta)*rot2(gamma)*R;
                        case 'x'
                            r = rot2(alpha)*rot3(beta)*rot1(gamma)*R;
                        otherwise
                            error('Input must be char not a %s',class(str3))
                    end
                otherwise
                    error('Input must be char not a %s',class(str2))
            end
        case 'z'
            switch str2
                case 'x'
                    switch str3
                        case 'z'
                            r = rot3(alpha)*rot1(beta)*rot3(gamma)*R;
                        case 'y'
                            r = rot3(alpha)*rot1(beta)*rot2(gamma)*R;
                        case 'x'
                            r = rot3(alpha)*rot1(beta)*rot1(gamma)*R;
                        otherwise
                            error('Input must be char not a %s',class(str3))
                    end
                case 'y'
                    switch str3
                        case 'z'
                            r = rot3(alpha)*rot2(beta)*rot3(gamma)*R;
                        case 'y'
                            r = rot3(alpha)*rot2(beta)*rot2(gamma)*R;
                        case 'x'
                            r = rot3(alpha)*rot2(beta)*rot1(gamma)*R;
                        otherwise
                            error('Input must be char not a %s',class(str3))
                    end
                case 'z'
                    switch str3
                        case 'z'
                            r = rot3(alpha)*rot3(beta)*rot3(gamma)*R;
                        case 'y'
                            r = rot3(alpha)*rot3(beta)*rot2(gamma)*R;
                        case 'x'
                            r = rot3(alpha)*rot3(beta)*rot1(gamma)*R;
                        otherwise
                            error('Input must be char not a %s',class(str3))
                    end
                otherwise
                    error('Input must be char not a %s',class(str2))
            end
        otherwise
            error('Input must be char not a %s',class(str1))
    end
    %% Display the results
    
    fprintf('The new x-coordinate is %4.2f\n',r(1))
    fprintf('The new y-coordinate is %4.2f\n',r(2))
    fprintf('The new z-coordinate is %4.2f\n',r(3))
end

