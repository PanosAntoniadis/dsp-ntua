function [fsig] = myInverseSTFT( fftSig, L, R)
% myInverseSTFT - Inverse Short Time Fourier Transform
% 
% Usage:
%         fsig = myInverseSTFT( fftsig, L, R)
% 
% Description:
% Computes the inverse short time fourier transform.
% 
% In:
%   fftsig: a matrix that contains in every collumn (= time frame) the dft.   
%   L : length of the window
%   R : step shift of the window
%
% Out:
%   fsig : the reconstructed signal.
%   
%Compute the inverse dft transform of every collumn.
i_signal = ifft( fftSig, 1024, 1);
%I place every frame in its initial position and then I add them all,
%resulting in our initial audio signal.
fsig = i_signal(:,1);
for col =2:size(i_signal,2)
    fsig = [fsig ; zeros(R,1)];
    next = [zeros((col-1)*R,1) ; i_signal(:,col)];
    fsig = fsig + next;
end


end
