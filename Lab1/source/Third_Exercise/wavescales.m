function [s,f]= wavescales(wavelet,Fs)

if strcmpi(wavelet,'morl')
    numvoices = 7;
    a0 = 2^(1/numvoices);
    numoctaves = 7;
    dt= 1/Fs;
    s = 2*dt*a0.^(0:1/numvoices:numvoices*numoctaves);
    
    periods = s.*(4*pi)/(6+sqrt(38));
    f  = 1./periods;
    
else
    error('Not an acceptable type of wavelet')
end


%==== To obtain the CWT coefficients =======
% cwtstruct = cwtft({x,1/Fs},'Scales',scales,'Wavelet','morl');

% cfs = cwtstruct.cfs;

end