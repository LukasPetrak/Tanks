function [dx] = krivka(t,x,b,g)
    %stavova matice
    dx(1,1) = x(2,1);
    dx(2,1) = b*x(2,1);
    dx(3,1) = x(4,1);
    dx(4,1) = -g;
end