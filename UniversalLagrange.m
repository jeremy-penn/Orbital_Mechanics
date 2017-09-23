function [R , V] = UniversalLagrange(R0,V0,mu,dt)
%UNIVERSALLAGRANGE Calculates the universal anomoly, position, and velocity
% of a particle after time, dt

    r0  = norm(R0);      % [km] Magnitude of initial position R0
    v0  = norm(V0);      % [km/s] Magnitude of initival velocity V0
    vr0 = R0*V0'/r0;     % [km/s] Orbital velocity
    alfa   = 2/r0 - v0^2/mu;
    %{
    if     (alfa > 0 )
        fprintf('The trajectory is an ellipse\n');
    elseif (alfa < 0)
        fprintf('The trajectory is an hyperbola\n');
    elseif (alfa == 0)
        fprintf('The trajectory is an parabola\n');
    end
    %}
    X0 = mu^0.5*abs(alfa)*dt;  %[km^0.5]Initial estimate of X0
    Xi = X0;
    tol = 1E-10;              % Tolerance
    while(1)
        zi = alfa*Xi^2;
        [ Cz,Sz] = Stumpff( zi );
        fX  = r0*vr0/(mu)^0.5*Xi^2*Cz + (1 - alfa*r0)*Xi^3*Sz + r0*Xi -(mu)^0.5*dt;
        fdX = r0*vr0/(mu)^0.5*Xi*(1 - alfa*Xi^2*Sz) + (1 - alfa*r0)*Xi^2*Cz + r0;
        eps = fX/fdX;
        Xi = Xi - eps;
        if(abs(eps) < tol )
            break
        end
    end
    %fprintf('Universal anomaly X = %4.3f [km^0.5] \n\n',Xi)
    % Lagrange f and g coefficients in terms of the universal anomaly

    f  =  1 - Xi^2/r0*Cz;
    g  = dt - 1/mu^0.5*Xi^3*Sz;
    R  = f*R0 + g*V0;
    r = norm(R);
    df = mu^0.5/(r*r0)*(alfa*Xi^3*Sz - Xi);
    dg = 1 - Xi^2/r*Cz;
    V = df*R0 + dg*V0;
   % fprintf('Position after %4.2f [min] R = %4.2f*i + %4.2f*j + %4.2f*k[km] \n',dt/60,R);
   % fprintf('Velocity after %4.2f [min] V = %4.3f*i + %4.3f*j + %4.2f*k[km/s] \n',dt/60,V);
end

