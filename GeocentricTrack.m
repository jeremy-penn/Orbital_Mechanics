function GeocentricTrack(R0, V0, dt, step,mu)
    %% Calculate and plot the geocentric orbit of a satellite about the Earth
    %
    % Jeremy Penn
    % 19 October 2017
    %
    % Revision 19/10/17
    %
    % function GeocentricTrack(R0, V0, dt, step)
    %
    % Purpose:  This function plots the orbit of a satellite in the
    %           geocentric frame of reference. Additionally, it creates a
    %           video of the orbit.
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
    
    [Ri,Vi] = trajectory(R0,V0,dt,step,mu);
    
    %% Instantiate Movie Maker
    str = input('Would you like a movie?\n','s');
    
    if strcmpi(str,'y') || strcmpi(str,'yes')
        movName = input('Please name the movie\n','s');
        con     = strcat('~/Documents/matlab/movie/',movName);
        vid = VideoWriter(con);
        open(vid);
        % Earth 3D Plot And Movie Export

        figure('units','normalized','outerposition',[0 0 1 1]);
        EarthPlot('orbit');
        hold on
        scatter3(Ri(1,1),Ri(1,2),Ri(1,3),'.r');
        for i = 2:length(Ri)
            scatter3(Ri(i,1),Ri(i,2),Ri(i,3),'.r');
            frame = getframe(gcf);
            writeVideo(vid,frame);
        end
        hold off;
        close(vid);
    else
        % Earth 3D Plot
        
        figure('units','normalized','outerposition',[0 0 1 1]);
        EarthPlot('orbit');
        hold on
        for i = 1:length(Ri)
            scatter3(Ri(i,1),Ri(i,2),Ri(i,3),'.r');
        end
    end
end