function [t_s,x_s,body1,deltaV,n,h] = balisticka(uhel,v0,x0,y0,body1)
    %prizpusobeni uhlu meritku a pomerovemu posuvu
    uhel = uhel*sind(uhel)*sind(uhel);
    g = 9.81;
    
    %vytvoreni vektrou casu
    D = ((v0^2)*sind(2*uhel))/g;        %predpokladany dostrel
    T = 2*v0*sind(uhel)/g;              %cas dopadu
    t = linspace(0,T);
    N = length(t);
    
    %maticovy zapis
    x = zeros(N,4);
    dx = zeros(N,4);
    
    %pocatecni podminky
    v0x = v0*cosd(uhel);
    v0y = v0*sind(uhel);

    P = [x0 v0x y0 v0y];
    
    %random generator poryvu vetru
    a = rand(1);
    if a > 0.5
        b = 0.05*rand(1);
    else
        b = -0.05*rand(1);
    end
    b = round(b,2);
    
    
    %solver
    odefun = @krivka;
    [t_s,x_s]=ode45(@(t_s,x_s) odefun(t_s,x_s,b,g),[t],P);
    
    [n,h] = newton();

    %podminka dopadu
    while x_s(length(t_s),3) > h(round((D+x0)/2))
    [t_s,x_s]=ode45(@(t_s,x_s) odefun(t_s,x_s,b,g),[t],P);
                
    T = T + 0.1;
    t = linspace(0,T);
    N = length(t);
    
    x = zeros(N,4);
    dx = zeros(N,4);
            
    D = D + (x(length(t_s),1) - x(1,1))/t_s(length(t_s),1);
    
    end

    %pricitani bodu
    for i=1:length(t_s)
        if (1030 < x_s(i,1)) && (x_s(i,1) < 1095)
            if (478 < x_s(i,3)) && (x_s(i,3) < 484)
                body1 = body1 + 1;
                        
                break;
            end
        end

    end
    
    %vypocet poryvu vetru
    deltaX = x_s(length(t_s),1) - D - x0;
    deltaV = deltaX/T;
    
end