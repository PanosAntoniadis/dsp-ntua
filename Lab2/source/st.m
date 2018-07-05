function [ ST_k ] = st( P_k )
% Boolean function that defines if there is a tone mask
% in frequency.
%
% Usage:
%         ST_k = st( P_k )
% 
% Description:
% Returns a binary vector that defines if there is a
% tone mask in each frequency.
%
% In:
%   P_k : spectrum of the signal in SPL 
% Out:
%   ST_k : binary vector
%
ST_k = zeros(length(P_k),1);
for i = 3:250
    if ((P_k(i) > P_k(i+1)) && (P_k(i) > P_k(i-1)))
        DK = dk(i);
        flag = 1;
        if length(DK) == 1
            DK = [DK DK];
        end
        for j = DK(1):DK(2)
            if ((P_k(i) <= (P_k(i+ j) + 7)) || (P_k(i) <= (P_k(i-j) + 7)))
                flag = 0;
            end
        end
        if (flag==1)
            ST_k(i) = 1;
        end
    end
end
end

    
    
    
    


