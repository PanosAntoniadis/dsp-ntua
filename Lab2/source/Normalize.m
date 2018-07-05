function [ y ] = Normalize( x )
% Normalize the input signal.
%
% Usage:
%         y = Normalize(x)
% 
% Description:
% Returns the normalized input signal.
%
% In:
%   x : input signal
% Out:
%   y : normalized input signal 
%
max_abs = max(abs(x));
y = x/max_abs;
end