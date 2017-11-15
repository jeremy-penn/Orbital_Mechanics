function wait_time()
    %% Calculate the wait time after Hohmann transfer for return transfer
    %
    % Jeremy Penn
    % 06/11/17
    %
    % Required: planet_select.m, time_of_transfer.m
    %
    clc;
    
    %% inputs
    planet1 = input('Input the departure planet:\n','s');
    planet2 = input('Input the target planet:\n','s');
    
    planet1 = lower(planet1);
    planet2 = lower(planet2);
    
    dp = planet_select(planet1);
    da = planet_select(planet2);
    
    n1 = 2*pi/dp(8);
    n2 = 2*pi/da(8);
    
    t12 = time_of_transfer(dp(5),da(5)) / 86400;
    
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