function [alpha, beta, zero, positive] = clarkTransform(A,B,C)
    alpha = (2/3)*(A - 0.5*B - 0.5*C);
    beta = (2/3)*(sqrt(3)/2*(B - C));
    zero = (A + B + C)/3;
    positive = sqrt(alpha.^2 + beta.^2); 
end
