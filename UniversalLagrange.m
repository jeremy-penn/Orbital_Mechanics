function [R , V] = UniversalLagrange(R0,V0,mu,dt)
%% Universal Lagrange Function and True Anomoly
%
% Jeremy Penn
% 22 September 2017
%

    r0  = norm(R0);      % [km] Magnitude of initial position R0
    v0  = norm(V0);      % [km/s] Magnitude of initival velocity V0
    vr0 = R0*V0'/r0;     % [km/s] Orbital velocity
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

