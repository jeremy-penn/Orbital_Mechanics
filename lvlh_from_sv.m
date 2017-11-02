function lvlh_from_sv(Ra, Rb, Va, Vb, mu)
    %% Calculate the relative position, velocity, and accel of B wrt A
    %
    % Jeremy Penn
    % 02/11/0217
    %
    % Revision: 02/11/0217
    %
    % Purpose: This function calculates the relative position, velocity and
    %          acceleration of B with respect to A.
    %
    % function LVLH_from_sv(Ra, Rb, Va, Vb)
    %
    % Input:    o Ra    - The position of A in geocentric coordinates
    %           o Rb    - The position of B in geocentric coordinates
    %           o Va    - The velocity of A in geocentric coordinates
    %           o Vb    - The velocity of B in geocentric coordinates
    %
    
    clc;
    
    %% Constants
    if nargin == 4
        mu = 398600;
    end
    
    ra = norm(Ra);
    rb = norm(Rb);
    
    %% Calculate the angular momentum of A
    Ha = cross(Ra,Va);
    
    %% Calculate the unit vectors i, j, k (comoving frame)
    i = Ra / ra;
    k = Ha / norm(Ha);
    j = cross(k, i);
    
    %% Calculate the orthogonal transformation matrix QXx
    QXx = [i; j; k];
    
    %% Calculate W and dW
    W  = Ha / (ra^2);
    dW = -2 * ( dot(Va,Ra) / ra^2 ) * W;
    
    %% Calculate the absolute accel of A and B
    aA = - ( mu/ra^3 ) * Ra;
    aB = - ( mu/rb^3 ) * Rb;
    
    %% Calculate relative R, V, & A in geocentric frame
    Rr = Rb - Ra;
    Vr = Vb - Va - cross(W, Rr);
    Ar = aB - aA - cross(dW, Rr) - cross(W, cross(W,Rr)) - cross(2*W, Vr);
    
    %% Calculate the relative r, v, & a in the comoving frame
    r = QXx * Rr';
    v = QXx * Vr';
    a = QXx * Ar';
    
    %% Print the results
    fprintf('The relative position in LVLH coordinates is %f *i, %f *j, %f *k [km]\n', r)
    fprintf('The relative velocity in LVLH coordinates is %f *i, %f *j, %f *k [km/s]\n', v)
    fprintf('The relative acceleration in LVLH coordinates is %f *i, %f *j, %f *k [km/s^2]\n', a)
end