%Removing past variables and commands.
clear, clc, close all

% -------------------- %
%    First Question    %
% -------------------- %

% --- a --- %
%Compute x[n] and plot it.
Fs = 1000;
Ts = 1/Fs;
t = [0:Ts:2];
n = t/Ts;
u = randn(1, 2/Ts+1);
x = 1.5*cos(2*pi*80*n*Ts) + 2.5*sin(2*pi*150*n*Ts) + 0.15*u;
figure;
plot(n,x);
xlabel('n');
ylabel('x[n]');
title(' Γραφική παράσταση του σήματος x[n]');

% --- b --- %
%Define the hamming window.
winDuration = 0.04;
winPoints = ceil(winDuration*Fs);
winHamm = hamming( winPoints);
winOverlap = 0.02;
OverlapPoints = ceil(winOverlap*Fs);
nfft = 2^(nextpow2(winPoints));
%Call spectrogram function that calculates stft of signal x with a hamming
%window and nfft points. The function returns frequency and time in their
%actual values so, then, I just plot the spectrogram.
[s ,f ,t_new] = spectrogram(x, winHamm, OverlapPoints,nfft ,Fs);
figure;
surf(t_new,f,abs(s),'edgecolor','none');

% --- c --- %
%Calculate the DT-CWT using the Morlet wavelet. The calculation of the
%scales and the corresponding frequencies is done by the function
%wavescales.
[scales , freq] = wavescales('morl', Fs);
cwt_Struct = cwtft({x,1/Fs},'Scales',scales,'Wavelet','morl');
cwt_sig = cwt_Struct.cfs;
figure;
surf(t, freq, abs(cwt_sig),'edgecolor','none');

% -------------------- %
%    Second Question   %
% -------------------- %

% --- a --- %
%Compute the new x[n] and plot it. 
x = 1.5*cos(2*pi*40*n*Ts) + 1.5*cos(2*pi*100*n*Ts) + 0.15*u;
x(0.625*Fs) = x(0.625*Fs) + 5;
x(0.650*Fs) = x(0.650*Fs) + 5;
figure;
plot(n,x);

% --- b --- %
%Define three hamming windows.
winDuration = [0.06 0.04 0.02];
winPoints = ceil(winDuration.*Fs);
winOverlap = winDuration./2;
OverlapPoints = ceil(winOverlap.*Fs);
%Call spectrogram function that calculates stft of signal x with a hamming
%window and nfft points. The function returns frequency and time in their
%actual values so, then, I just contour the spectrogram.
for i = 1:length(winDuration)
    figure;
    winHamm = hamming(winPoints(i));
    [s ,f ,t_new] = spectrogram(x, winHamm, OverlapPoints(i),2^(nextpow2(winPoints(i))) ,Fs);
    contour(t_new,f,abs(s));
    xlabel('time (sec)');
    ylabel('frequency (Hz)');
    title(strcat('Short time fourier transform of x[n] with window of length ',num2str(winDuration(i))));
end

% --- c --- %
%Calculate the DT-CWT using the Morlet wavelet. The calculation of the
%scales and the corresponding frequencies is done by the function
%wavescales.
[scales , freq] = wavescales('morl', Fs);
cwt_Struct = cwtft({x,1/Fs},'Scales',scales,'Wavelet','morl');
cwt_sig = cwt_Struct.cfs;
figure;
contour(t, freq, abs(cwt_sig));
title(' |DT-CWT(τ,f)| του σήματος x[n]');
xlabel('time (sec)');
ylabel('frequency (Hz)');