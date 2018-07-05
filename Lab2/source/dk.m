 function [ D_k ] = dk( k )
% Range that will be used in the computation of tone masks
%
% Usage:
%         D_k = dk( k )
% 
% Description:
% Returns the range that will be used in order to compute
% if there is a tone mask in distinct frequency k.
%
% In:
%   k : distrinct frequency
% Out:
%   D_k : range based on inpute frequency
%
if ((k>2) && (k<63))
    D_k = 2;
elseif (k<127)
    D_k = [2,3];
elseif (k<=250)
    D_k = [2,6];
else
    D_k = [];
end
end
 
        