function [ b ] = Bark_scale( f )
% Frequency to Bark scale converter
%
% Usage:
%         b = Bark_scale(f)
% 
% Description:
% Converts the input array of frequencies to
% Bark scale frequencies.
%
% In:
%   f : input array of frequencies
% Out:
%   b : frequencies converted to Bark scale 
%
b = 13*atan(0.00076*f) + 3.5*atan((f/7500).^2);
end
