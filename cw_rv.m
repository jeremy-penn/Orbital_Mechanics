function phi_rv = cw_rv(t,n)
    
    phi_rv = [(1/n)*sin(n*t), (2/n)*(1-cos(n*t)), 0
                (2/n)*(cos(n*t)-1), (1/n)*(4*sin(n*t)-3*n*t), 0
                0, 0, (1/n)*sin(n*t)];
    
end