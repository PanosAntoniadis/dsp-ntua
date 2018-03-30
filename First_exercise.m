%Removing past variables and commands.
clear, clc, close all

% ------------------------------- %
%    First and Second Question    %
% ------------------------------- %
%Reading the .wav file and computing its sample time.
prompt = 'Please enter the name of the sound file:\n ';
filename = input(prompt,'s');
[signal ,Fs] = audioread(filename);
Ts = 1/Fs;
%Defining our hamming window.
prompt = 'Please enter the duration of the window in seconds:\n ';
hamming_duration = input(prompt);
hamming_points = ceil(hamming_duration/Ts);
wHam = hamming(hamming_points);
%Call ste funtion that returns energy per window.
Energy = ste(signal, wHam);
%Defining time in order to plot the signal
%and plot the normalized signal.
t = [0:length(signal)-1] / Fs;  
figure;
plot(t,signal/mean(abs(signal)),'b');
hold on;
%Plot the normalized ste.
%We should match the Energy of its window to
%the middle of the window length. That's why
%we set start time and stop time as follows.
plot(t(hamming_points/2:(end-hamming_points/2)),Energy/mean(Energy),'r');
xlabel('time (sec)');
ylim([min(signal/mean(abs(signal)))-1 max(signal/mean(abs(signal)))+1]);
title('signal (blue) and normalized short time energy (red)');
%Call zcr funtion that returns zero crossing
%rate per window.
Z = zcr(signal,wHam);
figure;
%Plot the normalized signal.
plot(t,signal/mean(abs(signal)),'b');
hold on;
%Plot the zcr (not normalized).
%We should match the ZCR of its window to
%the middle of the window length. That's why
%we set start time and stop time as follows.
plot(t(hamming_points/2:(end-hamming_points/2)),Z,'r');
xlabel('time (sec)');
ylim([min(signal/mean(abs(signal)))-1 max(Z)+1]);
title('signal (blue) and zero crossing rate (red)');
hold off;
