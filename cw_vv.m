function phi_vv = cw_vv(t,n)
    
    phi_vv = [cos(n*t), 2*sin(n*t), 0
                -2*sin(n*t), 4*cos(n*t)-3, 0
                0, 0, cos(n*t)];
    
end