%Removing past variables and commands.
clear, clc, close all

% -------------------- %
%    First Question    %
% -------------------- %
%Read audio signal and save it to an array named signal
[signal, Fs] = audioread('vasw.wav');
Ts = 1/Fs;
%Compute the parameters of the window
prompt = 'Please enter the duration of the window in seconds:\n ';
winDuration = input(prompt);
prompt = 'Please enter the shift of the window in seconds:\n ';
winShift = input(prompt);
winPoints = winDuration*Fs;
shiftPoints = winShift*Fs;
%Call mySTFT funtion to apply stft to our audio signal.
[fftSig, nfft] = mySTFT(signal, winPoints, winPoints-shiftPoints);

% -------------------- %
%    Second Question   %
% -------------------- %
%Define time and frequency values. Time values corresponds to the center of
%every frame.
t = [0: size(fftSig,2)-1]*(winDuration-winShift) + winDuration/2;
f = [0:(size(fftSig,1)-1)]*Fs/nfft;
%Label x and y axis.
%Plot the amplitude defining the range of axis.
figure;
s = surf(t, f,log10(abs(fftSig)),'edgecolor','none');
ylim([0 3000]);
xlabel('time (sec)');
ylabel('frequency (Hz)');
%I display the words that sounds in every frame in order to isolate some
%vowels. Time values have been calculated using praat.
text(0.64,2500,'όλα');
text(0.897,2500,'αυτά');
text(1.2,2500,'ήταν');
text(1.45,2500,'η');
text(1.71,2500,'άμυνα');
text(2.02,2500,'μέσα');
text(2.25,2500,'στο');
text(2.5,2500,'μυαλό');
text(2.94,2500,'μου');
title( '|STFT(τ,f)| of speech signal speech-utterance.wav');
%Isolate two /α/'s and two /o/'s and plot their spectrograms separately.
vowels = [0.76 0.8 ; 1.5 1.6 ; 0.59 0.66 ; 2.63 2.71];
points = ceil(vowels./Ts);
win_pts = floor(points./(winPoints-shiftPoints));
%Plot the spectrogram of each vowel in a for loop.
for i = 1:4
    figure;
    s = surf(t(win_pts(i,1):win_pts(i,2)), f, log10(abs(fftSig(:,win_pts(i,1):win_pts(i,2)))),'edgecolor','none');
    axis([t(win_pts(i,1)),t(win_pts(i,2)), 0,3000]);
    ylabel('frequency (Hz)');
    xlabel('time (sec) ');
    if (i==1 || i==2)
        vowel = ' /a/';
    else
        vowel = ' /o/';
    end
    title( strcat('|STFT(τ,f)| of ',vowel));
end

% -------------------- %
%    Third Question    %
% -------------------- %
%Call myInverseSTFT function that reconstructs our initial signal. Then I
%play and save it to a wav file.
final_signal = myInverseSTFT( fftSig, winPoints, winPoints-shiftPoints);
sound(final_signal,Fs);
audiowrite('speech_utterance_rec.wav',final_signal,Fs);

% -------------------- %
%    Fourth Question   %
% -------------------- %
%Check if the prerequisite for a full reconstruction applies.
figure;
ola(winPoints, shiftPoints, 3*winPoints/2);





