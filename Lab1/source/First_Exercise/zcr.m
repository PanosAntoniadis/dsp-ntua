function [Zer] = zcr ( x, w)
% zcr - Zero Crossing Rate
% 
% Usage:
%         Zer = zcr( x, w)
% 
% Description:
% Computes the zero crossing rate of signal x using 
% a window w shifting one point each time.
% 
% In:
%   x : input signal
%   w : window signal 
% Out:
%   Zer : an array that contains in each cell
%   the zero crossing rate computated in the 
%   corresponding window.
%

%The signal is windowed into pieces of length equal to 
%w. The 'nodelay' argument omits all the unecessary zeros.
x_windowed = buffer(x, length(w), length(w)-1, 'nodelay');
Zer = zeros(1,size(x_windowed,2));
%For each collumn with compute its elements' signs and we 
%subtract them with the corresponding of the previous collumn.
%Because of a shift of one point every time, its element's sign
%is subtracted by its previous element's sign. To compute the 
%first collumn we define its previous window as a shift of one 
%point to the left. Then, we multiply the result with w.
for col = 1:size(x_windowed,2)
    if (col ~= 1)
        temp = abs(sgn(x_windowed(:,col)) - sgn(x_windowed(:,col-1)));
    else
        temp_col = [0 ; x_windowed(2:end,1)];
        temp = abs(sgn(x_windowed(:,col)) - sgn(temp_col));
    end
    Zer(col) = (temp') * w;
end
end