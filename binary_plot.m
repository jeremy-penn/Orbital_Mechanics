function binary_plot(R0,V0,dt,step,m1,m2)
    %% Plot the orbits of two objects orbiting their center of mass.
    %
    % Jeremy Penn
    % 21 October 2017
    %
    % Revision: 21/10/17
    %           
    % function binary_plot(R0,V0,dt,step,m1,m2)
    %
    % Purpose:  This function plots the trajectories of two objects about
    %           their common center of mass.
    % 
    % Inputs:   o R0    - A 1x3 vector of the initial separation vector
    %                     between m1 and m2.
    %           o V0    - A 1x3 vector of the initial total velocity vector.
    %           o dt    - The time difference (tf - ti).
    %           o step  - The step size for the calculation
    %           o m1    - Mass of object 1 in solar mass
    %           o m2    - Mass of object 2 in solar mass
    %
    % Requires: binary_trajectory.m
    %
    %% Calculate the trajectories
    [rf1,rf2] = binary_trajectory(R0,V0,m1,m2,dt,step);
    
    %% Plot Orbits
    
    str = input('Readout plot to video?\n','s');
    
    switch str
        case 'y'
            name = input('Please name output animation\n','s');
            con     = strcat('~/Documents/matlab/animation/',name);
            vid = VideoWriter(con);
            open(vid);
            set(gcf,'color','black');
            whitebg('black');
            CoM = ((rf1(1,:) * m1) + (rf2(1,:) * m2)) / (m1 * m2);
            scatter3(CoM(1),CoM(2),CoM(3),'xwhite');
            hold on

            for i = 1:length(rf1)
                axis off
                grid off
                scatter3(rf1(i,1),rf1(i,2),rf1(i,3),'.r');
                scatter3(rf2(i,1),rf2(i,2),rf2(i,3),'.g');
                frame = getframe(gcf);
                writeVideo(vid,frame);
            end
            hold off;
            close(vid);
        case 'yes'
            name = input('Please name output animation\n','s');
            con     = strcat('~/Documents/matlab/animation/',name);
            vid = VideoWriter(con);
            open(vid);
            set(gcf,'color','black');
            whitebg('black');
            CoM = ((rf1(1,:) * m1) + (rf2(1,:) * m2)) / (m1 * m2);
            scatter3(CoM(1),CoM(2),CoM(3),'xwhite');
            %hold on

            for i = 1:length(rf1)
                axis off
                grid off
                scatter3(rf1(i,1),rf1(i,2),rf1(i,3),'.r');
                scatter3(rf2(i,1),rf2(i,2),rf2(i,3),'.g');
                frame = getframe(gcf);
                writeVideo(vid,frame);
            end
            %hold off;
            close(vid);
        case 'n'
            set(gcf,'color','black');
            whitebg('black');
            CoM = ((rf1(1,:) * m1) + (rf2(1,:) * m2)) / (m1 * m2);
            scatter3(CoM(1),CoM(2),CoM(3),'xwhite');
            hold on

            for i = 1:length(rf1)
                axis off
                grid off
                scatter3(rf1(i,1),rf1(i,2),rf1(i,3),'.r');
                scatter3(rf2(i,1),rf2(i,2),rf2(i,3),'.g');
            end
            hold off
        case 'no'
            set(gcf,'color','black');
            whitebg('black');
            CoM = ((rf1(1,:) * m1) + (rf2(1,:) * m2)) / (m1 * m2);
            scatter3(CoM(1),CoM(2),CoM(3),'xwhite');
            hold on

            for i = 1:length(rf1)
                axis off
                grid off
                scatter3(rf1(i,1),rf1(i,2),rf1(i,3),'.r');
                scatter3(rf2(i,1),rf2(i,2),rf2(i,3),'.g');
            end
            hold off
        otherwise
            error('Error: Please choose "yes" or "no"')
    end
end