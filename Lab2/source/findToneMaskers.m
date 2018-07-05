function [ P_tm ] = findToneMaskers( P_k )
% Power of the mask in frequency k.
%
% Usage:
%         P_tm = findToneMaskers( P_k )
% 
% Description:
% Computes the power of the mask in the 
% distinct frequency k.
%
% In:
%   P_k : Spectrum of the signal in SPL
% Out:
%   P_tm : Power of the mask in frequency k.
%
%Computes the indexes of the tone masks.
ST_k = st(P_k);
%Computes for every index that there is a tone mask
%its power. All other indexes are zero.
P_tm = zeros(size(ST_k,1),1);
for i = 1:length(ST_k)
    if (ST_k(i) == 1)
        P_tm(i) = 10*log10( 10.^(0.1.*P_k(i-1)) + 10.^(0.1.*P_k(i)) + 10.^(0.1.*P_k(i+1)));
    end
end
end











