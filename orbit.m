function orbit()
    %% plots the orbit of a small mass around a large central mass
    %
    % Jeremy Penn
    % 22/11/17
    %
    % Requires: rkf45.m,
    %
    
    %% constants
    G  = 6.6742e-20; %[km^3/kg s^2] gravitational constant
    
    %% inputs
    m1 = input('Input the mass of the central body (kg):\n');
    R  = input('Input the radius of the central body (km):\n');
    m2 = input('Input the mass of the orbiting body (kg):\n');
    
    r0 = input('Input the initial geocentric position vector of the orbiting body [x, y, z](km):\n');
    v0 = input('Input the initial geocentric velocity vector of the orbiting body [vx, vy, vz] (km/s):\n');
    
    t0 = input('Input the initial time (s):\n');
    tf = input('Input the final time (s): \n');
    
    %% numerically integrate the orbit
    mu    = G*(m1 + m2);
    y0    = [r0 v0]';
    [t,y] = rkf45(@rates, [t0 tf], y0);
    
    %% plot and print the results
    output
    
    return
    
    %% -------subfunctions------------------------
    function dydt = rates(t,f)
        % ~~~~~~~~~~~~~~~~~~~~~~~~
        %{
        This function calculates the acceleration vector using Equation 2.22
  
        t          - time
        f          - column vector containing the position vector and the
               velocity vector at time t
        x, y, z    - components of the position vector r
        r          - the magnitude of the the position vector
        vx, vy, vz - components of the velocity vector v
         ax, ay, az - components of the acceleration vector a
         dydt       - column vector containing the velocity and acceleration
                      components
        %}
        % ------------------------
        x    = f(1);
        y    = f(2);
        z    = f(3);
        vx   = f(4);
        vy   = f(5);
        vz   = f(6);
        
        r    = norm([x y z]);
        
        ax   = -mu*x/r^3;
        ay   = -mu*y/r^3;
        az   = -mu*z/r^3;
        
        dydt = [vx vy vz ax ay az]';
    end %rates
    
    function output
        %{
        This function computes the maximum and minimum radii, the times they
        occur and the speed at those times. It prints those results to
        the command window and plots the orbit.

        r         - magnitude of the position vector at the times in t
        imax      - the component of r with the largest value
        rmax      - the largest value of r
        imin      - the component of r with the smallest value
        rmin      - the smallest value of r
        v_at_rmax - the speed where r = rmax
        v_at_rmin - the speed where r = rmin
        %}
        % -------------
        [h, e, inc, W, w, ta] = coe_from_rv(r0,v0);
        for i = 1:length(t)
            r(i) = norm([y(i,1) y(i,2) y(i,3)]);
        end
        
        [rmax imax] = max(r);
        [rmin imin] = min(r);
        
        v_at_rmax   = norm([y(imax,4) y(imax,5) y(imax,6)]);
        v_at_rmin   = norm([y(imin,4) y(imin,5) y(imin,6)]);
        
        %...Output to the command window:
        clc;
        fprintf('\n\n--------------------------------------------------------\n')
        fprintf('\n Earth Orbit\n')
        fprintf(' %s\n', datestr(now))
        fprintf('\n The initial position is [%g, %g, %g] (km).',...
            r0(1), r0(2), r0(3))
        fprintf('\n\t   Magnitude = %g km\n', norm(r0))
        fprintf('\n The initial velocity is [%g, %g, %g] (km/s).',...
            v0(1), v0(2), v0(3))
        fprintf('\n\t   Magnitude = %g km/s\n', norm(v0))
        fprintf('\n Initial time = %g h.\n Final time   = %g h.\n',0,tf/3600)
        fprintf('\n The minimum altitude is %g km at time = %g h.',...
            rmin-R, t(imin)/3600)
        fprintf('\n The speed at that point is %g km/s.\n', v_at_rmin)
        fprintf('\n The maximum altitude is %g km at time = %g h.',...
            rmax-R, t(imax)/3600)
        fprintf('\n The speed at that point is %g km/s\n', v_at_rmax)
        fprintf('\n The classic orbital elements:\n')
        fprintf('\n\t h  = %.2f [km^2/s]',h)
        fprintf('\n\t e  = %.2f',e)
        fprintf('\n\t i  = %.2f [deg]',inc)
        fprintf('\n\t W  = %.2f [deg]',W)
        fprintf('\n\t w  = %.2f [deg]',w)
        fprintf('\n\t ta = %.2f [deg]',ta)
        fprintf('\n--------------------------------------------------------\n\n')
        
        %...Plot the results:
        %   Draw the planet
        [xx, yy, zz] = sphere(100);
        surf(R*xx, R*yy, R*zz)
        colormap(light_gray)
        caxis([-R/100 R/100])
        shading interp
        
        %   Draw and label the X, Y and Z axes
        line([0 2*R],   [0 0],   [0 0]); text(2*R,   0,   0, 'X')
        line(  [0 0], [0 2*R],   [0 0]); text(  0, 2*R,   0, 'Y')
        line(  [0 0],   [0 0], [0 2*R]); text(  0,   0, 2*R, 'Z')
        
        %   Plot the orbit, draw a radial to the starting point
        %   and label the starting point (o) and the final point (f)
        hold on
        plot3(  y(:,1),    y(:,2),    y(:,3),'k')
        line([0 r0(1)], [0 r0(2)], [0 r0(3)])
        text(   y(1,1),    y(1,2),    y(1,3), 'o')
        text( y(end,1),  y(end,2),  y(end,3), 'f')
        
        %   Select a view direction (a vector directed outward from the origin)
        view([1,1,.4])
        
        %   Specify some properties of the graph
        grid on
        axis equal
        xlabel('km')
        ylabel('km')
        zlabel('km')
        
        function map = light_gray
            % ~~~~~~~~~~~~~~~~~~~~~~~
            %{
             This function creates a color map for displaying the planet as light
             gray with a black equator.
  
            r - fraction of red
            g - fraction of green
            b - fraction of blue

            %}
            % -----------------------
            r = 0.8; g = r; b = r;
            map = [r g b
                0 0 0
                r g b];
        end %light_gray
    end %output
end