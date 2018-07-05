function [stft, N] = mySTFT ( signal, L, R)
% mySTFT - Short Time Fourier Tsansform
% 
% Usage:
%         [stft, N] mySTFT( signal, L, R)
% 
% Description:
% Computes the short time fourier transform of the given
% signal, using a hamming window of length L and shift R.
% 
% In:
%   signal: an array that contains all the values of the given signal
%   L : length of the window
%   R : step shift of the window
%
% Out:
%   stft : the computed stft in the form of a L * K matrix, where L is 
%   the length if the window and K the number of windows. The rows
%   corresponds to frequency and collumns to time.
%   
%   N : points of fft, where we define them as a power of two number, 
%   which makes the algorithm faster.
%
%First, signal is windowed with an L-R shift.
sig_framed = buffer( signal, L, L-R);
%We use a hamming window.
winHamm = hamming(L);
N = 2^(nextpow2(L));
%Initialization of stft matrix.
stft = zeros( N, size(sig_framed,2));
%Every collumn that corresponds to every frame is multiplied with the
%window and, then, fft is aplied to the product.
for col = 1:size(sig_framed,2)
    temp = sig_framed(:,col) .* winHamm;
    stft(:,col) = fft(temp, N);
end
end