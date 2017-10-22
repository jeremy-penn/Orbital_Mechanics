function [R , V] = UniversalLagrange(R0,V0,dt)
    %% Universal Lagrange Function and True Anomoly
    %
    % Jeremy Penn
    % 22 September 2017
    %
    % Revision  22/09/17
    %           19/10/17 - Moved the ploting to outside functions to
    %           increase encapsulation.
    %
    % function [R , V] = UniversalLagrange(R0,V0,dt)
    %
    % Purpose:  This function calculates the true anomaly to find the f and
    %           g lagrange functions used to calculate the time-dependent 
    %           position and velocity of a satellite.
    % 
    % Inputs:   o R0    - A 1x3 vector of the satellite's initial position
    %           o V0    - A 1x3 vector of the satellite's initial velocity
    %           o dt    - The final time in seconds [s]
    %           o step  - The step sized used to determine how often to
    %                     calculate position and velocity in seconds [s]
    %
    % Outputs:  o R     - The new position.
    %           o V     - The new velocity.
    %

    r0  = norm(R0);      % [km] Magnitude of initial position R0
    v0  = norm(V0);      % [km/s] Magnitude of initival velocity V0
    vr0 = R0*V0'/r0;     % [km/s] Orbital velocitymu
    mu  = 398600;        % [km^3/s^2] Standard Gravitational Parameter
    alpha   = 2/r0 - v0^2/mu;

    X0 = mu^0.5*abs(alpha)*dt;  %[km^0.5]Initial estimate of X0
    Xi = X0;
    tol = 1E-10;              % Tolerance
    while(1)
        zi = alpha*Xi^2;
        [ Cz,Sz] = Stumpff( zi );
        fX  = r0*vr0/(mu)^0.5*Xi^2*Cz + (1 - alpha*r0)*Xi^3*Sz + r0*Xi -(mu)^0.5*dt;
        fdX = r0*vr0/(mu)^0.5*Xi*(1 - alpha*Xi^2*Sz) + (1 - alpha*r0)*Xi^2*Cz + r0;
        eps = fX/fdX;
        Xi = Xi - eps;
        if(abs(eps) < tol )
            break
        end
    end
    %% Lagrange f and g coefficients in terms of the universal anomaly

    f  =  1 - Xi^2/r0*Cz;
    g  = dt - 1/mu^0.5*Xi^3*Sz;
    R  = f*R0 + g*V0;
    r = norm(R);
    df = mu^0.5/(r*r0)*(alpha*Xi^3*Sz - Xi);
    dg = 1 - Xi^2/r*Cz;
    V = df*R0 + dg*V0;
end

