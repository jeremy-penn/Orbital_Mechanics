function non_impulse_thrust()
    %% calculates the nonimpulse thrust over the time interval
    %
    % Jeremy Penn
    % 19/11/2017
    %
    % function non_impulse_thrust()
    %
    % Required: kepler_convert.m, rfk45.m, rv_from_r0v0_ta.m
    %
    
    %% constants
    mu      = 398600;
    g0      = 9.807;
    
    %% inputs
    alt     = input('Input the altitude of perigee [x, y, z] (km):\n');
    vel     = input('Input the velocity of the orbit [vx, vy, vz] (km/s):\n');
    r0      = [alt(1), alt(2), alt(3)];
    v0      = [vel(1), vel(2), vel(3)];
    t0      = 0;
    t_burn  = input('Input the total burn time (s): \n');
    
    m0      = input('Input the mass of the rocket (kg):\n');
    T       = input('Input the engine thrust (kN):\n');
    Isp     = input('Input the engine specific impulse (s):\n');
    
    %% integrate the equations of motion
    y0    = [r0 v0 m0]';
    [t,y] = rkf45(@rates, [t0 t_burn], y0, 1.e-16);
    
    %% compute the state vector and mass after burn
    r1  = [y(end,1) y(end,2) y(end,3)];
    v1  = [y(end,4) y(end,5) y(end,6)];
    m1  = y(end,7);
    coe = kepler_convert(r1,v1,mu);
    e   = coe(2);
    TA  = coe(6);
    a   = coe(1);
    
    %% find the state vector at apogee of the post-burn trajectory:
    dtheta  = mod(TA,360);
    
    [ra,va] = rv_from_r0v0_ta(r1, v1, dtheta, mu);
    
    clc;
    
    fprintf('\n\n--------------------------------------------------------\n')
    fprintf('\nBefore ignition:')
    fprintf('\n  Mass = %g kg', m0)
    fprintf('\n  State vector:')
    fprintf('\n    r = [%10g, %10g, %10g] (km)', r0(1), r0(2), r0(3))
    fprintf('\n      Radius = %g', norm(r0))
    fprintf('\n    v = [%10g, %10g, %10g] (km/s)', v0(1), v0(2), v0(3))
    fprintf('\n      Speed = %g\n', norm(v0))
    fprintf('\nThrust          = %12g kN', T)
    fprintf('\nBurn time       = %12.6f s', t_burn)
    fprintf('\nMass after burn = %12.6E kg\n', m1)
    fprintf('\nEnd-of-burn-state vector:')
    fprintf('\n    r = [%10g, %10g, %10g] (km)', r1(1), r1(2), r1(3))
    fprintf('\n      Radius = %g', norm(r1))
    fprintf('\n    v = [%10g, %10g, %10g] (km/s)', v1(1), v1(2), v1(3))
    fprintf('\n      Speed = %g\n', norm(v1))
    fprintf('\nPost-burn trajectory:')
    fprintf('\n  Eccentricity   = %g', e)
    fprintf('\n  Semimajor axis = %g km', a)
    fprintf('\n  Apogee state vector:')
    fprintf('\n    r = [%17.10E, %17.10E, %17.10E] (km)', ra(1), ra(2), ra(3))
    fprintf('\n      Radius = %g', norm(ra))
    fprintf('\n    v = [%17.10E, %17.10E, %17.10E] (km/s)', va(1), va(2), va(3))
    fprintf('\n      Speed = %g', norm(va))
    fprintf('\n\n--------------------------------------------------------\n\n')
    
    %% -----subfunctions----------------------------
    function dfdt = rates(t,f) %#ok<*INUSL>
        
        x  = f(1);  y = f(2);  z = f(3);
        vx = f(4); vy = f(5); vz = f(6);
        m  = f(7);
        
        r    = norm([x y z]);
        v    = norm([vx vy vz]);
        ax   = -mu*x/r^3 + T/m*vx/v;
        ay   = -mu*y/r^3 + T/m*vy/v;
        az   = -mu*z/r^3 + T/m*vz/v;
        mdot = -T*1000/g0/Isp;
        
        dfdt = [vx vy vz ax ay az mdot]';
        
    end %rates
end