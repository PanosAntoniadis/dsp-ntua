function [ T_nm] = noise_threshold( j, P_nm , b )
%Individual masking threshold of a noise mask
%
% Usage:
%         T_nm = noise_threshold( j, P_nm, b )
% 
% Description:
%   Computes the individual masking threshold of the    
%   noise mask in distinct frequency j.
% In:
%   j : Frequency of noise mask
%   P_nm : Power of noise mask 
%   b : Array of frequencies in bark scale
% Out:
%   T_nm : Individual masking threshold
%

%Determine where noise mask j is in barks
NoiseMaskLocation = b(j);

%Compute range in barks
low = NoiseMaskLocation - 3;
high = NoiseMaskLocation + 8;

%Compute range in discrete frequencies
low = find(b<low,1,'last' );
if isempty(low); low = 1; end
high = find(b<high, 1, 'last' );

%Calculate SF(i,j)
SF = zeros(1,high-low+1);
for i=low:high
   NoiseMaskeeLocation = b(i);
   Db = NoiseMaskeeLocation - NoiseMaskLocation;
   if (Db>=-3 && Db<-1)
      SF(i-low+1) = 17*Db-0.4*P_nm+11;
   elseif (Db>=-1 && Db<0)
      SF(i-low+1) = (0.4*P_nm+6)*Db;
   elseif (Db>=0 && Db<1)
      SF(i-low+1) = -17*Db;
   elseif (Db>=1 && Db<8.5)
      SF(i-low+1)=(0.15*P_nm-17)*Db-0.15*P_nm;
   end
end

%Calculate individual noise threshold of noise mask j
T_nm = zeros( 256,1 );
for i = low:high
    T_nm(i) = SF(i-low+1) + P_nm - 0.275*b(j) - 6.025;
end
end
   