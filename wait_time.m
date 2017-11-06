function wait_time(n1, n2, t12)
    %% Calculate the wait time after Hohmann transfer for return transfer
    %
    % Jeremy Penn
    % 06/11/17
    %
    clc;
    
    %% calculate the phase angle after transfer
    phif = pi - n1*t12;
    
    %% calculate the wait time
    if n1 > n2
        N = 0;
        twait = (-2*phif - 2*pi*N) / (n2 - n1);
        
        while twait < 0
            N = N + 1;
            twait = (-2*phif - 2*pi*N) / (n2 - n1);
        end
        
    elseif n2 > n1
        N = 0;
        twait = (-2*phif + 2*pi*N) / (n2 - n1);
        
        while twait < 0    
            N = N + 1;
            twait = (-2*phif + 2*pi*N) / (n2 - n1);
        end
        
    else
        error('Error: n1 and n2 can not be equal')
    end
    
    fprintf('The wait time is %.2f days\n',twait)
end