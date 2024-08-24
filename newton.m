function [n,h] = newton()
    %Newtonuv polynom
    
    %vektory zadanych bodu
    x = linspace(0,10,11);
    y = [453 461 454 454 462 463 469 479 466 472 468];
    
    x = x';
    y = y';
    N = length(x);
    
    %vytvoreni matic
    d = zeros(N);
    P = d;
    
    %zapsani vektoru do matic
    d(:,1) = x;
    P(:,1) = y;
    
    %vypocet koeficientu metodou pomernych diferenci
    for k=2:N
        for i=k:N
            d(i,k) = d(i,1) - d(i-k+1,1);
            P(i,k) = (P(i,k-1) - P(i-1,k-1))/d(i,k);
        end
    end
    
    %koeficienty polynomu lezi na hlavni diagonale
    m = linspace(x(1),x(N),3000);
    
    p2 = 0;
    p3 = 1;
    p5 = P(1,1);
    
    %vytvoreni prislusneho polynomu
    for i=1:(N-1)
        p2 = m - x(i);
        p3 = p3.*p2;
        p4 = (P(i+1,i+1)).*p3;
        
        p5 = p5 + p4;
    end
    
    n = linspace(0,1500,3000);
    h = ones(1,length(n)).*p5;
    
    %pripadne vykresleni
% %     plot(x,y,'or')
% %     hold on
% %     plot(m,p5,'b')
%     plot(n,h)
% %     hold off
end

