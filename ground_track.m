function ground_track(R0, V0, dt, step, mu)
    %% Calculate and plot the geocentric orbit of a satellite about the Earth
    %
    % Jeremy Penn
    % 21 October 2017
    %
    % Revision 21/10/17
    %
    % function ground_track(R0, V0, dt, step, mu)
    %
    % Purpose:  This function plots the ground track of a satellite in the
    %           geocentric frame of reference. Additionally, it creates a
    %           video of the ground track.
    % 
    % Inputs:   o R0 - A 1x3 vector of the satellite's initial position
    %           o V0 - A 1x3 vector of the satellite's initial velocity
    %           o dt - The final time in seconds [s]
    %           o step - The step sized used to determine how often to
    %                    calculate position and velocity in seconds [s]
    %
    
    if nargin == 4
        mu  = 398600;        % [km^3/s^2] Standard Gravitational Parameter
    end
    
    load topo
    
    [Ri,Vi] = trajectory(R0,V0,dt,step,mu);
    
    %% Convert positions to RA and dec
    ind = 1;
    N   = length(Ri);
    RA  = zeros(N,1);
    dec = zeros(N,1);
    
    for j = 1:length(Ri)
        [RA(ind),dec(ind)] = R2RA_Dec(Ri(j,:));
        ind = ind + 1;
    end
    
    %% Instantiate Movie Maker
    str = input('Would you like a movie?\n','s');
    
    if strcmpi(str,'y') || strcmpi(str,'yes')
        movName = input('Please name the movie\n','s');
        con     = strcat('~/Documents/matlab/movie/',movName);
        vid = VideoWriter(con);
        open(vid);
        % Plot the ground track
        figure('units','normalized','outerposition',[0 0 1 1])


        image([0 360],[-90 90], flip(topo), 'CDataMapping', 'scaled')
        colormap(topomap1)

        axis equal                                % set axis units to be the same size

        ax = gca;                                 % get current axis               
        ax.XLim = [0 360];                        % set x limits
        ax.YLim = [-90 90];                       % set y limits
        ax.XTick = [0 60 120 180 240 300 360];    % define x ticks
        ax.YTick = [-90 -60 -30 0 30 60 90];      % define y ticks
        
        ylabel('Latitude [deg]');
        xlabel('Longitude [deg]');
        title('Satellite Ground Track');
        hold on;
        
        for i = 1:length(Ri)
            scatter(RA(i),dec(i),'.r');
            frame = getframe(gcf);
            writeVideo(vid,frame);
        end
        close(vid);
    else
        % Plot the ground track
        figure('units','normalized','outerposition',[0 0 1 1])

        
        image([0 360],[-90 90], flip(topo), 'CDataMapping', 'scaled')
        colormap(topomap1)

        axis equal                                % set axis units to be the same size

        ax = gca;                                 % get current axis               
        ax.XLim = [0 360];                        % set x limits
        ax.YLim = [-90 90];                       % set y limits
        ax.XTick = [0 60 120 180 240 300 360];    % define x ticks
        ax.YTick = [-90 -60 -30 0 30 60 90];      % define y ticks
        
        ylabel('Latitude [deg]');
        xlabel('Longitude [deg]');
        title('Satellite Ground Track');
        hold on;
        
        for i = 1:length(Ri)
            scatter(RA(i),dec(i),'.r');
        end
    end
end