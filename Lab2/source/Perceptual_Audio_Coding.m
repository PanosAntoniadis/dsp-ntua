%Removing past variables and commands.
clear, clc, close all

%Ask the user for quantization method and save the answer.
prompt = 'Please enter the quantization method you prefer (1 for adaptive quantizer , 2 for 8-bit quantizer):\n ';
answer = input(prompt);

%Reading the signal.
[x, Fs] = audioread('music.wav');

%Converting signal from stereo to mono.
y = zeros(1,size(x,1));
for i=1:length(x)
    y(i)= (x(i,1) + x(i,2))/2; 
end

% - - - - - - - %
%    Part 1     %
% - - - - - - - &

%
% Step 1.0 : Normalization of the signal.
%
y = Normalize(y);

%Break the signal into frames of N samples.
%Since length(y)/N is not an integer, we fill
%the last collumn with zeros.
N = 512;
y_buffered = buffer(y, N);

%Define the array of frequencies and convert 
%them to bark scale.
FFTLength = N;
F = [1:FFTLength/2]*(Fs/FFTLength);
b = Bark_scale(F);

%Define the absolute threshold of hearing that 
%will be used later.
T_q = Abs_Thr_Hearing(F);

%Define the window signal that will be used.
hann = hanning(FFTLength);

%All the computations will be executed for every window of the signal
%Here we have all the necessary initializations.

P_k = zeros( FFTLength/2, size(y_buffered,2));  %Spectrum in dB SPL
ST_k = zeros( FFTLength/2, size(y_buffered,2)); %Points that we have initial tone and noise masks
P_tm_init = zeros( FFTLength/2, size(y_buffered,2));    %Power of initial tone masks
P_nm_init = zeros( FFTLength/2, size(y_buffered,2));    %Power of initial noise masks
P_tm = zeros( FFTLength/2, size(y_buffered,2)); %Power of reduced tone masks
P_nm = zeros( FFTLength/2, size(y_buffered,2)); %Power of reduced noise masks
T_g = zeros( FFTLength/2, size(y_buffered,2));  %Absolute Threshold of Hearing
reconstr_signal_buffered = zeros(639, size(y_buffered,2));   %Buffered reconstructed signal
overall_number_of_bits = 0; %Number of bits of reconstructed signal

for frame = 1:size(y_buffered,2)
    %Step 1.1 : Compute the spectrum of each frame in SPL.
    P_k(:,frame) = Spectrum_SPL( y_buffered(:,frame), hann, FFTLength);
    
    % Step 1.2 : Compute the power of each tone mask.
    P_tm_init(:,frame) = findToneMaskers( P_k(:,frame));
    %Compute the power of each noise mask.
    P_nm_init(:,frame) = findNoiseMaskers( P_k(:,frame), P_tm_init(:,frame), b);
    
    % Step 1.3 : Reduce the number of tone and noise masks.
    [P_tm(:,frame) , P_nm(:,frame)] = checkMaskers(P_tm_init(:,frame)' , P_nm_init(:,frame)', T_q, b);
    %Compute the distinct frequencies in which there is a tone mask.
    tm_idx = find(P_tm(:,frame));
    %Compute the distinct frequencies in which there is a tone mask.
    nm_idx = find(P_nm(:,frame));
    
    % Step 1.4 : Compute individual masking treshold for tone masks.
    T_tm = zeros( 256, length(tm_idx));
    for j = 1:length(tm_idx)
        T_tm(:,j) = tone_threshold(tm_idx(j), P_tm(tm_idx(j),frame), b);
    end
    %Compute individual masking treshold for noise masks.
    T_nm = zeros( 256, length(nm_idx) );
    for j = 1:length(nm_idx)
         T_nm(:,j) = noise_threshold(nm_idx(j), P_nm(nm_idx(j),frame), b);
    end
    
    % Step 1.5 : Compute global masking treshold.
    for i = 1:size(T_g,1)
        T_g(i,frame) = 10*log10(10^(0.1*T_q(i)) + sum(10.^(0.1*T_tm(i,:))) + sum(10.^(0.1*T_nm(i,:))));
    end
   
    % - - - - - - - %
    %    Part 2     %
    % - - - - - - - &
    
    % Step 2.0 : Creating Filterbank
    M = 32;
    L = 2*M;
    h_k = zeros(M,L);
    g_k = zeros(M,L);
    % Analysis filters
    for q = 1:M
        for n =1:L
            h_k(q,n) = sin( (n-1+1/2)*pi/(2*M)) * sqrt(2/M) * cos(((2*(n-1)+M+1)*(2*(q-1)+1)*pi)/(4*M));
        end
    end   
    % Synthesis filters
    for q = 1:M
        for n =1:L
            g_k(q,n) = h_k(q,2*M-n+1);
        end
    end
    %Number of levels of input music signal
    R = 2^16;
    %Based on the user input use an adaptive or an 8bit quantizer
    if (answer == 1)
       [reconstr_signal_buffered(:,frame), bits_per_frame] = adaptive_quantizer( h_k, g_k, M, L, R, y_buffered(:,frame), T_g(:,frame));
    else
       [reconstr_signal_buffered(:,frame), bits_per_frame] = quantizer_8bit( h_k, g_k, M, L, R, y_buffered(:,frame));
    end
    overall_number_of_bits = overall_number_of_bits + bits_per_frame;
end
%Calculate final recontructed signal using the Overlap-Add method
L = size(reconstr_signal_buffered,1);
R = 512;
reconstructed_y = reconstr_signal_buffered(1:R,1);
for frame =2:size(reconstr_signal_buffered,2)
    reconstructed_y = [reconstructed_y; (reconstr_signal_buffered(R+1:L,frame-1) +reconstr_signal_buffered(1:L-R,frame))];
    reconstructed_y = [reconstructed_y; reconstr_signal_buffered(L-R+1:R,frame)];
end

%Ignore the first 2M samples
reconstructed_y = reconstructed_y(2*M:end)';
initial_number_of_bits = 16*length(y);

%Compute mean squared error and compression rate
mse = immse(y, reconstructed_y(1:length(y)));
compression_rate = overall_number_of_bits/initial_number_of_bits*100;

%Saving wav file
if (answer == 1)
    audiowrite('rec_signal(AdaptiveQuantizer).wav',reconstructed_y,Fs)
else
    audiowrite('rec_signal(8bitQuantizer).wav',reconstructed_y,Fs)
end
%Prining some useful measures
initial_number_of_bits
overall_number_of_bits
compression_rate
mse








