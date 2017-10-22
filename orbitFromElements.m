function orbitFromElements(h,i,omega,e,w,theta)
    %% Plot the orbit of an object from the classical orbital elements
    %
    %
    % Jeremy Penn
    % 20 October 2017
    %
    % Revision: 20/10/17
    %           
    % function orbitFromElements(h,i,omega,e,w,theta)
    %
    % Purpose:  This function plots an orbit from the orbital elements.
    % 
    % Inputs:   o h     - angular momentum
    %           o i     - inclination
    %           o omega - Right Ascension of the ascending node
    %           o e     - eccentricity
    %           o w     - argument of perigee
    %           o theta - true anomaly
    %
    %% Calculate the semimajor axis
    
    a = (h^2/mu)*(1/(1-e^2));
    
end