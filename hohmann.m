function hohmann(Ria,Rip,Rfa,Rfp,m, isp)
    %% Calculates the delta-v to Hohmann transfer from orbit 1 to 2
    %
    % Jeremy Penn
    % 23/10/2017
    %
    % Revision: 23/10/2017
    %
    % function hohmann(Ria,Rip,Rfa,Rfp)
    %
    % Purpose: This function calculates the delta-v necessary to Hohmann
    %          transfer from orbit 1 to 2. Additionally, it calculates the fuel
    %          usage.
    %
    % Input:  o Ria   - The altitude of the apoapis of the initial orbit [km]
    %         o Rip   - The altitude of the periapis of the initial orbit [km]
    %         o Rfa   - The altitude of the apoapis of the final orbit [km]
    %         o Rfp   - The altitude of the perigee of the final orbit [km]
    %         o m     - The mass of the spacecraft before 1st manuveur [kg]
    %         o isp   - The specific impulse of the engine [s]
    %
    clc;
    mu = 398600; %[km^3/s^2]
    g  = 9.807;  %[m/s^2]
    
    %% Cacluate altitude from center of the Earth
    Ria = Ria + 6378;
    Rip = Rip + 6378;
    Rfa = Rfa + 6378;
    Rfp = Rfp + 6378;
    
    %% Calculate the angular momenta
    h1 = sqrt(2*mu)*sqrt((Ria*Rip)/(Ria + Rip));
    h2 = sqrt(2*mu)*sqrt((Rfa*Rip)/(Rfa + Rip));
    h3 = sqrt(2*mu)*sqrt((Rfa*Rfp)/(Rfa + Rfp));
    
    %% Calculate the speed at each point
    va1 = h1 / Rip;
    va2 = h2 / Rip;
    va  = va2 - va1;
    va  = va*1000;   %convert to [m/s]
    
    vb2 = h2 / Rfa;
    vb3 = h3 / Rfa;
    vb  = vb3 - vb2;
    vb  = vb*1000;   %convert to [m/s]
    
    deltav = abs(va) + abs(vb);
    
    %% Calculate mass of propellant expended
    
    deltam = m*(1 - exp(-(deltav /(isp*g))));
    newm   = m - deltam;
    
    fprintf('The delta-v requirement for Hohmann insertion is %8.2f [m/s]\n', va)
    fprintf('The delta-v requirement for Hohmann breaking is %8.2f [m/s]\n', vb)
    fprintf('The total delta-v requirement for Hohmann transfer is %8.2f [m/s]\n', deltav)
    fprintf('The mass of the propellant expended is %5.2f [kg]\n', deltam)
    fprintf('The new mass of the vessel is %5.2f [kg]\n',newm)
end