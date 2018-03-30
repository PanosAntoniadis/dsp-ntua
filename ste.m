function [ Energy ] = ste( x, w )
% STE - Short Time Energy
%
% Usage:
%         Energy = ste(x, w)
% 
% Description:
% Computes the short time energy of signal x using 
% a window 'w' shifting one point each time.
%
% In:
%   x : input signal
%   w : window signal 
% Out:
%   Energy : an array that contains in each cell
%   the energy computated in the corresponding window 
%
%The signal is windowed into pieces of length equal to 
%w. The 'nodelay' argument omits all the unecessary zeros.
x_windowed = buffer(x, length(w), length(w)-1, 'nodelay');
%Initialization of output matrix.
Energy = zeros(size(x_windowed,2),1);
%Every collumn of the windowed signal is multiplied with
%window w and then we add all the elements squared.
for col = 1:size(x_windowed,2)
    tmp = w .* (x_windowed(:,col));
    Energy(col) = sum(tmp.^2,1);
end
end

