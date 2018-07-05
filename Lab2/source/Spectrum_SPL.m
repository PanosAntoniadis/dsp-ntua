function [ P_k ] = Spectrum_SPL( x, w, FFTLength )
% Spectrum of x in SPL
%
% Usage:
%         P_k = Spectrum_SPL( x, w, FFTLength)
% 
% Description:
% Computes the spectrum of the input signal x
% in Sound Pressure Lever.
%
% In:
%   x : input signal
%   w : window signal
%   FFTLenght : length of the fft
% Out:
%   P_k : spectrum in SPL
%
PN = 90.302;
spect = fft(x.*w, FFTLength);
P_k = PN + 10*log10( abs(spect).^2);
%Keep tha half of the signal since fft is symmetrical
P_k = P_k(1:FFTLength/2);
end
