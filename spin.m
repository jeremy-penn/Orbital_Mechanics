% spin.m: Rotates a view around the equator one revolution
% in 5-degree steps. Negative step makes it rotate normally
% (west-to-east).
axesm('globe','Grid','off','Gcolor',[.7 .8 .9])
set(gca, 'Box','off', 'Projection','perspective')

axis vis3d

load topo

topo = topo / (earthRadius('km')* 20);
hs = meshm(topo,topolegend,size(topo),topo);
demcmap(topo)

set(gcf,'color','black');
axis off;

camlight right
lighting Gouraud;
material ([.7, .9, .8])

n   = 16000/100;
rps = 360/86164.100;     %  Earth's deg/s rotational speed

m   = rps*n;

for i=360:- m:0
	   view(i,23.5);     %  Earth's axis tilts by 23.5 degrees
	   drawnow
end