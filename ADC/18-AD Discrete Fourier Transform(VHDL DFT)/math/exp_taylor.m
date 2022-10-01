%e üzeri ix
function [out] = exp_taylor(x)

%out = 1+x+power(x,2)/factorial(2)+power(x,3)/factorial(3)+power(x,4)/factorial(4)+power(x,5)/factorial(5)+power(x,6)/factorial(6);
out = (1 - power(x,2)/factorial(2) + power(x,4)/factorial(4) - power(x,6)/factorial(6) + power(x,8)/factorial(8)- power(x,10)/factorial(10)) ...
      + 1i*(x - power(x,3)/factorial(3) + power(x,5)/factorial(5) - power(x,7)/factorial(7) + power(x,9)/factorial(9));

end

