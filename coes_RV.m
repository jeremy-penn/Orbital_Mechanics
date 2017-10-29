function [r,v] = coes_RV(h,inc,RA,e,omega,theta)   
%From the orital elements, the position and velocity vectors are is found. 
%The Inputs are inputed the following matter: 
%     h is angular momentum in km^2/s 
%     inc is inclination in radians  
%     RA is right ascension of ascending node in radians 
%     e is eccelntricity (unitless) 
%     omega is argument of perigee in radians 
%     theta is true anomaly in radians 
%Equations (EQN) used come from Curtis       
mu = 398600; %Gravitational parameter of Earth (km^3/s^2)   
%Now following Algorithm 4.2 from Curtis, I use EQN. 4.37 to find r in 
%perifocal frame, and EQN 4.38 to find v in perifocal plane   
rperi = h^2/mu/(1+e*cos(theta))*[cos(theta); sin(theta); 0]; % (km)  
vperi = mu/h.*[-sin(theta); e + cos(theta); 0]; % (km/s)   
%Next use EQN 4.44 to find transformation matrix from perifocl to 
%geocentric equatorial coordinates   
Qperi=[cos(RA)*cos(inc)*sin(omega)+cos(RA)*cos(omega) -sin(RA)*cos(inc)*cos(omega)-cos(RA)*sin(omega) sin(RA)*sin(inc);
   cos(RA)*cos(inc)*sin(omega)+sin(RA)*cos(omega) cos(RA)*cos(inc)*cos(omega)-sin(RA)*sin(omega) -cos(RA)*sin(inc);
   sin(inc)*sin(omega) sin(inc)*cos(omega) cos(inc)];
%Finally use, EQN 4.46 to find the r and V in the geocentric equatorial 
%plane  
r=Qperi*rperi; %in km   
v=Qperi*vperi; %in km/s   
%Convert r and v into row vectors   
r = r'; %km  
v = v'; %km/s 