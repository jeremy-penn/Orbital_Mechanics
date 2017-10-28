grs80 = referenceEllipsoid('grs80','km');
load topo

ax = axesm('globe','Geoid',grs80,'Grid','off', ...
            'GLineWidth',1,'GLineStyle','-',...
            'Gcolor',[0.9 0.9 0.1],'Galtitude',100);
        ax.Position = [0 0 1 1];
        axis equal off
        view(3)

        geoshow(topo,topolegend,'DisplayType','texturemap')
        demcmap(topo)
        land = shaperead('landareas','UseGeoCoords',true);
        plotm([land.Lat],[land.Lon],'Color','black')
        rivers = shaperead('worldrivers','UseGeoCoords',true);
        plotm([rivers.Lat],[rivers.Lon],'Color','blue')
       
for i=360:-5:0
	   view(i,23.5);     %  Earth's axis tilts by 23.5 degrees
	   drawnow
end