function [t_s,x_s,body2] = balisticka2(uhel,x0,y0,body2)
    %prizpusobeni uhlu meritku a pomerovemu posuvu
    uhel = uhel*sind(uhel)*sind(uhel);
    v0 = 101.5;
    g = 9.81;
    
    %vytvoreni vektoru casu
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

    
    %solver
    odefun = @krivka2;
    [t_s,x_s]=ode45(@(t_s,x_s) odefun(t_s,x_s,g),[t],P);
    
    [n,h] = newton();
    
    %podminka dopadu
    while x_s(length(t_s),3) > h(round((D+x0)/2))
    [t_s,x_s]=ode45(@(t_s,x_s) odefun(t_s,x_s,g),[t],P);
                
    T = T + 1;
    t = linspace(0,T);
    N = length(t);
    
    x = zeros(N,4);
    dx = zeros(N,4);
            
    D = D + (x(length(t_s),1) - x(1,1))/t_s(length(t_s),1);
    end
    
    %pricitani bodu
    for i=1:length(t_s)
        if (145 < x_s(i,1)) && (x_s(i,1) < 210)
            if (460 < x_s(i,3)) && (x_s(i,3) < 466)
                body2 = body2 + 1;
                        
                break;
            end
        end
    end
    
end