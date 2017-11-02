function geocentric_track(R0, V0, dt, step,mu)
    %% Calculate and plot the geocentric orbit of a satellite about the Earth
    %
    % Jeremy Penn
    % 19 October 2017
    %
    % Revision: 19/10/17
    %           28/10/2017 - Added a rotating globe for movie mode.
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
    % Requires: trajectory.m
    %
    
    load topo
    
    if nargin == 4
        mu  = 398600;        % [km^3/s^2] Standard Gravitational Parameter
    end
    
    [Ri,Vi] = trajectory(R0,V0,dt,step,mu);
    
    %% Instantiate Movie Maker
    str = input('Would you like an animation?\n','s');
    
    if strcmpi(str,'y') || strcmpi(str,'yes')
        movName = input('Please name the movie\n','s');
        con     = strcat('~/Documents/matlab/animation/',movName);
        vid = VideoWriter(con,'MPEG-4');
        open(vid);
        
        grs80 = referenceEllipsoid('grs80','km');
        
        figure('Renderer','opengl')
        ax = axesm('globe','Geoid',grs80,'Grid','off', ...
            'GLineWidth',1,'GLineStyle','-',...
            'Gcolor',[0.9 0.9 0.1],'Galtitude',100);
        ax.Position = [0 0 1 1];
        axis equal off

        h1 = geoshow(topo,topolegend,'DisplayType','texturemap');
        demcmap(topo)
        land = shaperead('landareas','UseGeoCoords',true);
        h2 = plotm([land.Lat],[land.Lon],'Color','black');
        rivers = shaperead('worldrivers','UseGeoCoords',true);
        h3 = plotm([rivers.Lat],[rivers.Lon],'Color','blue');
        
        n          = dt/step;
        rate       = 360/86164;       % Earth's rotation rate [deg/sec]
        rotperstep = n*rate;
        totalrot   = rotperstep*step; % Total degrees of rotation
        rotation   = 360:-rotperstep:totalrot;
        direction  = [0, 0, 1];
        hold on
        
        for i = 1:length(Ri)
            ax = axesm('globe','Geoid',grs80,'Grid','off', ...
                'GLineWidth',1,'GLineStyle','-',...
                'Gcolor',[0.9 0.9 0.1],'Galtitude',100);
            ax.Position = [0 0 1 1];
            axis equal off
            
            rotate(h1,direction,rotation(i))
            rotate(h2,direction,rotation(i))
            rotate(h3,direction,rotation(i))
            view(0,23.5)
            scatter3(Ri(i,1),Ri(i,2),Ri(i,3),'.r');
            refreshdata
            drawnow
            frame = getframe;
            writeVideo(vid,frame);
        end
        close(vid);
    else
        
        grs80 = referenceEllipsoid('grs80','km');
        
        figure('Renderer','opengl')
        ax = axesm('globe','Geoid',grs80,'Grid','off', ...
            'GLineWidth',1,'GLineStyle','-',...
            'Gcolor',[0.9 0.9 0.1],'Galtitude',100);
        ax.Position = [0 0 1 1];
        axis equal off
        view(0,23.5)

        geoshow(topo,topolegend,'DisplayType','texturemap')
        demcmap(topo)
        land = shaperead('landareas','UseGeoCoords',true);
        plotm([land.Lat],[land.Lon],'Color','black')
        rivers = shaperead('worldrivers','UseGeoCoords',true);
        plotm([rivers.Lat],[rivers.Lon],'Color','blue')
        
        for i = 1:length(Ri)
            scatter3(Ri(i,1),Ri(i,2),Ri(i,3),'.r');
        end
    end
end