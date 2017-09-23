function trajectory(R0,V0,mu,dt,step)
% TRAJECTORY calculates and plots the trajectory of a satellite around
%            a central object.

    clc; clear R V Long Lat t ind Ri;
    t      = 0;       %[s] Initial time
    ind    = 1;
        while (t < dt)
            [R, V] = UniversalLagrange(R0, V0, mu, t);
            Ri(ind,:) = R;
            [Long(ind,:), Lat(ind,:)] = R2RA_Dec(R);
            ind = ind + 1;
            t = t + step;
        end
    % Instantiate Movie Maker
    vid = VideoWriter('orbit.avi');
    open(vid);
    ma = max(Ri);
    m = max(ma);
    
    % Earth 3D Plot
    Earth3DPlot(1);
    
    for i = 1:length(Ri)
        hold on
        axis([-1.5*m ,1.5*m ,-1.5*m ,1.5*m ,-1.5*m ,1.5*m]);
        scatter3(Ri(i,1),Ri(i,2),Ri(i,3),'.r');
        frame = getframe;
        writeVideo(vid,frame);
    end
    hold off;
    close(vid);
    %
end