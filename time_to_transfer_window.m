function time_to_transfer_window(phi, n1, n2, t12)
    %% Calculate the time to transfer window
    %
    % Jeremy Penn
    % 06/11/2017
    %
    % Revision: 06/11/2017
    %
    % function time_to_transfer_window(phi, n1, n2, t12)
    %
    % Purpose: This function calculates the time to an open planetary
    %          transfer window
    %
    % Input:  o phi   - The phase angle between n1 and n2 and t = 0 [deg]
    %         o n1    - The mean motion of the departing planet [rad/day]
    %         o n2    - The mean motion of the target planet [rad/day]
    %         o t12   - The transfer time of the Hohmann transfer to n1 to
    %                   n2 [day]
    %
    clc;
    
    while phi < 0
        phi = phi + 360;
    end
    
    while phi > 360
        phi = phi - 360;
    end
    
    phi = phi * pi/180;
    
    %% calculate phase angle for transfer
    phi0 = pi - n2*t12;
    
    %% calculate time to transfer window
    if n1 > n2
        N = 0;
        t = (phi0 - phi - 2*pi*N) / (n2 - n1);
        
        while t < 0
            N = N + 1;
            t = (phi0 - phi - 2*pi*N) / (n2 - n1);
        end
    elseif n2 > n1
        N = 0;
        t = (phi0 - phi + 2*pi*N) / (n2 - n1);
        
        while t < 0
            N = N + 1;
            t = (phi0 - phi + 2*pi*N) / (n2 - n1);
        end
    else
        error('Error: n1 and n2 can not be equal')
    end
    
    %% Calculate the synodic period of the orbit
    T1 = (2*pi) / n1;
    T2 = (2*pi) / n2;
    
    Tsyn = (T1*T2) / abs(T1 - T2);
    
    if abs(t - Tsyn) < 14
        fprintf('Transfer window is currently open!\n')
    else
        fprintf('The transfer window will open in %.2f days\n', t)
    end
end