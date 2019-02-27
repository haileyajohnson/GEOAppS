function [ k, e ] = newton_raphson( T, h )
    omega = 2*pi/T;
    g = 9.81;
    tol = 1e-6;    
    
    Lo = (g*T^2)/(2*pi);
    % first approximation
    k = 2*pi/Lo;
    e = k;
    
    while e > tol
        f = g*k*tanh(k*h) - omega^2;
        f_prime = g*(k*h*(1-tanh(k*h)^2) + tanh(k*h));
        k2 = k - f/f_prime;
        e = abs(k2-k)/k;
        k = k2;
    end

end

