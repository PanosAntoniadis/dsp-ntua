function [ T_q ] = Abs_Thr_Hearing( f )
% Absolute Threshold of Hearing
%
% Usage:
%         T_q = Abs_Thr_Hearing( f ) 
% 
% Description:
% Computes for every frequency in the array f
% the Absolute Threshold of Hearing.
%
% In:
%   f : input array of frequencies
% Out:
%   T_q : output array that includes the 
%         absolute threshold of hearing in each frequency
%
T_q = 3.64*(f/1000).^(-0.8) - 6.5*exp(-0.6 *(f/1000 - 3.3).^2) + 10^(-3)*(f/1000).^4;
end