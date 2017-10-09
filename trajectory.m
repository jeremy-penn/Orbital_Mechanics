function trajectory(R0,V0,mu,dt,step)
%% Calculate And Plot Trajectory
%
% Jeremy Penn
% 22 September 2017
% NOTES: Time [s], Distance [km], Velocity [km/s], Grav Parameter [km^3 / s^2]
%
    clc; clear R V Long Lat t ind Ri;
    t      = 0;       %[s] Initial time
    ind    = 1;
    N      = (dt / step) + 1;
    Ri     = zeros(N,3);
        while (t < dt)
            [R, V] = UniversalLagrange(R0, V0, mu, t);
            Ri(ind,:) = R;
            ind = ind + 1;
            t = t + step;
            % disp(ind)
        end
%    
    %% Instantiate Movie Maker
    vid = VideoWriter('orbit.avi');
    open(vid);
    %
    %% Earth 3D Plot And Movie Export
    Earth3DPlot;
    scatter3(Ri(1,1),Ri(1,2),Ri(1,3),'.r');
    hold on
    for i = 2:length(Ri)
        scatter3(Ri(i,1),Ri(i,2),Ri(i,3),'.r');
        frame = getframe(gcf);
        writeVideo(vid,frame);
    end
    hold off;
    close(vid);
    %
end