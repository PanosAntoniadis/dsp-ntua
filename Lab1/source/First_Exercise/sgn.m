function [y] = sgn (x)
% sgn - Sign function
% 
% Usage:
%         y = sgn(x)
% 
% Description:
% It returns an array containing the sign of 
% each element of x.
% 
% In:
%   x: an array of real numbers
%
% Out:
%   y: an array containing '1' if x has a positive
%   number or zero in the same cell. Otherwise, '-1'.
%
 y= zeros(length(x),1);
for i=1:length(x)
    if x(i)<0
        y(i) = -1;
    else
        y(i) = 1;
    end
end
end


        