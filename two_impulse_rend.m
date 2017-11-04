function two_impulse_rend(r0, v0, R0, V0, t)
    %% Plot the orbits of small mass orbiting a large central body
    %
    % Jeremy Penn
    % 03 November 2017
    %
    % Revision: 03/11/17
    %
    % function two_impulse_rend(r0, v0, R0, V0, t)
    %
    % Purpose:  This function calculates the dv required and trajectory vector
    %           for a two-impulse rendezvous in LEO. Additionally plots the
    %           position vector over the time interval.
    %
    % Input:    o r0    - target's geocentric position vector
    %           o v0    - target's geocentric velocity vector
    %           o R0    - chaser's geocentric position vector
    %           o V0    - chaser's geocentric velocity vector
    %           o t     - time to intercept target
    %
    % Requires: cw_rr.m, cw_rv.m, cw_vr.m, cw_vv.m
    %
    %
    clc;
    
    %% Calculate the LVLH coordinates
    i = r0 / norm(r0);
    j = v0 / norm(v0);
    k = cross(i,j);
    
    %% transformation matrix from from geocentric to LVLH
    QXx = [i; j; k];
    
    %% relative vectors in geocentric coords
    n   =  norm(v0) / norm(r0);
    Wss = n*k;
    
    dr = R0 - r0;
    dv = V0 - v0 - cross(Wss, dr);
    
    %% relative position vector in LVLH 
    dr0 = QXx * dr';
    dv0_ = QXx * dv';
    
    %% CW matrices
    phi_rr = cw_rr(t,n);
    phi_rv = cw_rv(t,n);
    phi_vr = cw_vr(t,n);
    phi_vv = cw_vv(t,n);
    
    %% rel velocity after impulse
    dv0p = -inv(phi_rv)*phi_rr*dr0;
    
    %% rel final velocity before 2nd impulse
    dvf_ = phi_vr*dr0 + phi_vv*dv0p;
    
    %% delta-v
    delta_v0 = abs( dv0p - dv0_ );
    delta_vf = abs( 0 - dvf_ );
    
    total_dv = (norm(delta_v0) + norm(delta_vf)) * 1e3;
    
    %% trajectory angle
    r = phi_rr*dr0 + phi_rv*dvf_;
    
    times = 0:100:t;
    pr = zeros(length(times),3);
    for lj = 1:length(times)
        pr(lj,:) = cw_rr(times(lj),n)*dr0 + cw_rv(times(lj),n)*dvf_;
    end
    
    plot3(pr(:,1),pr(:,2),pr(:,3));
    
    fprintf('The total delta-v required for the two-impulse rendezvous is %.1f [m/s]\n', total_dv)
    fprintf('The trajectory vector is %.2f*i + %.2f*j + %.2f*k [km]\n ', r)
    
end