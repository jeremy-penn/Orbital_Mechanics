function EarthPlot(mode)
    %% Textured 3D Earth example
    %
    % Jeremy Penn
    % 21/10/2017
    %
    % Revision: 21/10/2017
    %           
    % function EarthPlot(mode)
    %
    % Purpose:  This function calculates the trajectories of two objects about
    %           their common center of mass.
    %
    % Input:    o mode - A string either "orbit" for a 3D sphere of the
    %                    Earth or "ground" for a topographical flat map.
    % 
    clf
    load topo topo topomap1    % load data
    r = 6371; % [km] radius of the Earth
    
    if strcmpi(mode,'orbit')
        [x,y,z] = sphere(100);          % create a sphere 
        s = surface(r*x,r*y,r*z);            % plot spherical surface

        s.CData = topo;                % set color data to topographic data
        s.FaceColor = 'texturemap';    % use texture mapping
        s.EdgeColor = 'none';          % remove edges
        s.FaceLighting = 'gouraud';    % preferred lighting for curved surfaces
        s.SpecularStrength = 0.4;      % change the strength of the reflected light

        light('Position',[-1 0 1])     % add a light

        axis square off                % set axis to square and remove axis
        view([-30,30])                 % set the viewing angle
    elseif strcmpi(mode,'ground')
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
    else
        error('Error: Input must be "orbit" or "ground".\n')
    end
end