function [sine,cosine] = cordicc(angle)
 
    x = 1;
    y = 0;
    z = angle;
    
    a = 0;          % Iterative factor
	K = 0.6073;     %K Factor
    x = K*x;
while a < 30        % Really only takes a half of this value get an 0.001 of error
                    % in cosine and sine values.
    if z >=0
        d=1;
    else
        d=-1;
    end
                     %This function is used to get the +1,-1 value, the sing function don´t
                    % perform d=1 if z=0.
    xantes=x;
    x=xantes-(y*d*(1/2^a));
    y=y+(xantes*d*(1/2^a));
    z=z-(d*(atan(1/2^a)));
    a=a+1;
    
end

cosine = x;
sine = y;