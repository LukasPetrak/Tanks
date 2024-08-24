function [dx] = krivka2(t,x,g)
    %random generator poryvu vetru
    a = rand(1);
    if a > 0.5
        b = 0.1*rand(1);
    else
        b = -0.1*rand(1);
    end
    b = round(b,2);    

    %stavova matice
    dx(1,1) = -x(2,1);
    dx(2,1) = b*x(2,1);
    dx(3,1) = x(4,1);
    dx(4,1) = -g;
end