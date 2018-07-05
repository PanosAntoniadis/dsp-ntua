function [ T_tm] = tone_threshold( j, P_tm , b )
%Individual masking threshold of a tone mask
%
% Usage:
%         T_tm = tone_threshold( j, P_tm, b )
% 
% Description:
%   Computes the individual masking threshold of the    
%   tone mask in distinct frequency j.
% In:
%   j : Frequency of tone mask
%   P_tm : Power of tone mask 
%   b : Array of frequencies in bark scale
% Out:
%   T_tm : Individual masking threshold
%

%Determine where tone mask j is in barks
ToneMaskLocation = b(j);

%Compute range in barks
low = ToneMaskLocation - 3;
high = ToneMaskLocation + 8;

%Compute range in discrete frequencies
low = find(b<low,1,'last' );
if isempty(low); low = 1; end
high = find(b<high, 1, 'last' );

%Calculate SF(i,j)
SF = zeros(1,high-low+1);
for i=low:high
   ToneMaskeeLocation = b(i);
   Db = ToneMaskeeLocation - ToneMaskLocation;
   if (Db>=-3 && Db<-1)
      SF(i-low+1) = 17*Db-0.4*P_tm+11;
   elseif (Db>=-1 && Db<0)
      SF(i-low+1) = (0.4*P_tm+6)*Db;
   elseif (Db>=0 && Db<1)
      SF(i-low+1) = -17*Db;
   elseif (Db>=1 && Db<8.5)
      SF(i-low+1)=(0.15*P_tm-17)*Db-0.15*P_tm;
   end
end

%Calculate individual tone threshold of tone mask j
T_tm = zeros( 256,1 );
for i = low:high
    T_tm(i) = SF(i-low+1) + P_tm - 0.275*b(j) - 6.025;
end
end
    


