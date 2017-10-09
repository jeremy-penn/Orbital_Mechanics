function binaryTrajectory(R0,V0,m1,m2,dt,step) %#ok<*STOUT>
%% Calculate And Plot Trajectory
%
% Jeremy Penn
% 01 October 2017
%
% Notes: R0 [pc], V0 [km/s], m1 & m2 in solar mass
%
    
    clc; clear R V t ind RedMassN rf1 rf2;
    t       = 0;                        %[s] Initial time
    ind     = 1;
    mn1     = m1 * 1.988e+30;           %[kg] Convert mass to kg
    mn2     = m2 * 1.988e+30;           %[kg] Convert mass to kg
    RedMass = (mn1*mn2) / (mn1 + mn2);  %[kg] Reduced Mass
    mu      = (mn1+mn2) * 6.674e-24;    %[km^3/s^2] Gravitational Parameter
    N       = (dt / step);
    rf1     = zeros(N,3);               %[km] Final Position of m1
    rf2     = zeros(N,3);               %[km] Final Position of m2
        while (t < dt)
            [R, V] = UniversalLagrange(R0, V0, mu, t); %#ok<*ASGLU>
            rf1(ind,:) = (RedMass/m1)*R;
            rf2(ind,:) = -(RedMass/m2)*R;
            ind = ind + 1;
            t = t + step;
            % disp(ind)
        end
%        
    %% Plot Orbits
    vid = VideoWriter('orbit.avi');
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
    %
end