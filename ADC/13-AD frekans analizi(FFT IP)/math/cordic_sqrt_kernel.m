n = 20;
x = fi(1.6250+0.25,1,20,17);
y = fi(1.6250-0.25,1,20,17);
k = 4; % Used for the repeated (3*k + 1) iteration steps
for idx = 1:n
    xtmp = bitsra(x, idx); % multiply by 2^(-idx)
    ytmp = bitsra(y, idx); % multiply by 2^(-idx)
    if y < 0
        x(:) = x + ytmp;
        y(:) = y + xtmp;
    else
        x(:) = x - ytmp;
        y(:) = y - xtmp;
    end
     if idx==k
         xtmp = bitsra(x, idx); % multiply by 2^(-idx)
         ytmp = bitsra(y, idx); % multiply by 2^(-idx)
         if y < 0
             x(:) = x + ytmp;
             y(:) = y + xtmp;
         else
             x(:) = x - ytmp;
             y(:) = y - xtmp;
         end
         k = 3*k + 1;
     end
 end % idx loop
 
An=1;
for i=1:n
An=An*sqrt(1-power(2,-2*i));
end
x
res=x/An

