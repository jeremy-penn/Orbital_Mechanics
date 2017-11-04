function phi_rr = cw_rr(t,n)
   
    phi_rr = [4-3*cos(n*t), 0, 0
                6*(sin(n*t) - n*t) 1 0
                0 0 cos(n*t)];
end