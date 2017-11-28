function twobody()
    %% solves the two body problem
    %
    % Jeremy Penn
    % 23/11/17
    %
    % function twobody()
    %
    % Required: rkf45.m
    
    %% constants
    G = 6.67408e-20; %[km^3 / kg s^2]
    
    %% inputs
    m1   = input('Input the mass of the first object (kg):\n');
    m2   = input('Input the mass of the second object (kg):\n');
    t0   = input('Input the initial time (s):\n');
    tf   = input('Input the final time (s):\n');
    
    R1_0 = input('Input the initial position vector of the first mass [x, y, z] (km):\n');
    R2_0 = input('Input the initial position vector of the second mass [x, y, z] (km):\n');
    
    V1_0 = input('Input the initial velocity vector of the first mass [x, y, z] (km):\n');
    V2_0 = input('Input the initial velocity vector of the second mass [x, y, z] (km):\n');
    
    %% make sure all vectors are column vectors
    if isrow(R1_0)
        R1_0 = R1_0';
    end
    
    if isrow(R2_0)
        R2_0 = R2_0';
    end
    
    if isrow(V1_0)
        V1_0 = V1_0';
    end
    
    if isrow(V2_0)
        V2_0 = V2_0';
    end
    
    %% set initial coniditions
    y0 = [R1_0; R2_0; V1_0; V2_0];
    
    %% integrate the equations of motion
    [t,y] = rkf45(@rates, [t0 tf], y0);
    
    %% output the results
    output
    
    return
    
    %% ---------subfunctions----------------------------------
    function dydt = rates(t,y)
        
        R1   = [y(1); y(2); y(3)];
        R2   = [y(4); y(5); y(6)];
        
        V1   = [y(7); y(8); y(9)];
        V2   = [y(10); y(11); y(12)];
        
        r    = norm(R2 - R1);
        
        A1   = G*m2*(R2 - R1)/r^3;
        A2   = G*m1*(R1 - R2)/r^3;
        
        dydt = [V1; V2; A1; A2];
        
    end %rates
    
    function output
        %
        % This function calculates the trajectory of the center of mass and
        % plots
        %
        % (a) the motion of m1, m2 and G relative to the inertial frame
        % (b) the motion of m2 and G relative to m1
        % (c) the motion of m1 and m2 relative to G
        %
        clc;
        
        %...Extract the particle trajectories:
        X1 = y(:,1); Y1 = y(:,2); Z1 = y(:,3);
        X2 = y(:,4); Y2 = y(:,5); Z2 = y(:,6);
        
        %...Locate the center of mass at each time step:
        XG = []; YG = []; ZG = [];
        for i = 1:length(t)
            XG = [XG; (m1*X1(i) + m2*X2(i))/(m1 + m2)];
            YG = [YG; (m1*Y1(i) + m2*Y2(i))/(m1 + m2)];
            ZG = [ZG; (m1*Z1(i) + m2*Z2(i))/(m1 + m2)];
        end
        
        %...Plot the trajectories:
        figure (1)
        axis off
        title('Motion relative to the inertial frame')
        hold on
        plot3(X1, Y1, Z1, '-r')
        plot3(X2, Y2, Z2, '-g')
        plot3(XG, YG, ZG, '-b')
        
        %comet3(X1, Y1, Z1);
        %comet3(X2, Y2, Z2);
        
        
        text(X1(1), Y1(1), Z1(1), '1', 'color', 'r')
        text(X2(1), Y2(1), Z2(1), '2', 'color', 'g')
        text(XG(1), YG(1), ZG(1), 'G', 'color', 'b')
        
        common_axis_settings
        
        figure (2)
        title('Motion of m2 and G relative to m1')
        hold on
        plot3(X2 - X1, Y2 - Y1, Z2 - Z1, '-g')
        plot3(XG - X1, YG - Y1, ZG - Z1, '-b')
        
        
        text(X2(1)-X1(1), Y2(1)-Y1(1), Z2(1)-Z1(1), '2', 'color', 'g')
        text(XG(1)-X1(1), YG(1)-X1(1), ZG(1)-X1(1), 'G', 'color', 'b')
        
        common_axis_settings
        
        figure (3)
        title('Motion of m1 and m2 relative to G')
        hold on
        plot3(X1 - XG, Y1 - YG, Z1 - ZG, '-r')
        plot3(X2 - XG, Y2 - YG, Z2 - ZG, '-g')
        
        text(X1(1)-XG(1), Y1(1)-YG(1), Z1(1)-ZG(1), '1', 'color', 'r')
        text(X2(1)-XG(1), Y2(1)-YG(1), Z2(1)-ZG(1), '1', 'color', 'g')
        
        common_axis_settings
        
        function common_axis_settings
            %
            % This function establishes axis properties common to the several plots
            %
            text(0, 0, 0, 'o')
            axis('equal')
            view([2,4,1.2])
            grid on
            axis equal
            xlabel('X (km)')
            ylabel('Y (km)')
            zlabel('Z (km)')
        end %common_axis_settings
    end %output
end