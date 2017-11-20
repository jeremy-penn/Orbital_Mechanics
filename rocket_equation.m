function dv = rocket_equation(isp, m0, mf, g)
    if nargin == 0
        isp = input('Input specific impulse of the rocket engine (s): \n');
        m0  = input('Input the initial mass of the rocket (kg):\n');
        mf  = input('Input the final mass of the rocket (kg):\n');
        g   = input('Input magnitude of surface gravity (m/s^2):\n');
    end
    
    dv = g*isp*log(m0/mf);
end