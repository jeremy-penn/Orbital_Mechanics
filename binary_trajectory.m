function [rf1,rf2] = binary_trajectory(R0,V0,m1,m2,dt,step)
    %% Calculate the relative tracjectories for two bodies orbiting their center of mass
    %
    % Jeremy Penn
    % 21 September 2017
    %
    % Revision: 21/09/17
    %            21/10/17 - Moved print functionality to  binary_plot.
    %           
    % function [rf1,rf2] = binaryTrajectory(R0,V0,m1,m2,dt,step)
    %
    % Purpose:  This function calculates the trajectories of two objects about
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
    % Requires: universal_lagrange.m
    %
    
    clc; clear R V t ind RedMassN rf1 rf2;
    
    t       = 0;                        %[s] Initial time
    ind     = 1;
    mn1     = m1 * 1.988e+30;           %[kg] Convert mass to kg
    mn2     = m2 * 1.988e+30;           %[kg] Convert mass to kg
    RedMass = (mn1*mn2) / (mn1 + mn2);  %[kg] Reduced Mass
    G       = 6.647e-25;                %[km^3/kg s^2] Grav Constant
    mu      = G * (mn1 + mn2);
    N       = (dt / step);
    rf1     = zeros(N,3);               %[km] Final Position of m1
    rf2     = zeros(N,3);               %[km] Final Position of m2
        while (t < dt)
            [R, V] = universal_lagrange(R0, V0, t, mu);
            rf1(ind,:) = (RedMass/m1)*R;
            rf2(ind,:) = -(RedMass/m2)*R;
            ind = ind + 1;
            t = t + step;
        end
end