%% FFT for Spectral Analysis
% This example shows the use of the FFT function for spectral  analysis.  A
% common use of FFT's is to find the frequency components of a signal buried in
% a noisy time domain signal.
%
% Copyright 1984-2005 The MathWorks, Inc. 
% $Revision: 5.8.4.2 $  $Date: 2009/04/03 21:23:24 $
%
% modified by RTB for QMBC on 7 June 2011

%%
% First create some data.  Consider data sampled at 1000 Hz.  Start by forming a
% time axis for our data, running from t=0 until t=.25 in steps of 1
% millisecond.  Then form a signal, x, containing sine waves at 50 Hz and 120
% Hz.

Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
plot(Fs*t(1:100),x(1:100),'b'); hold on;
xlabel('time (milliseconds)'); ylabel('amplitude');

%%
% Add some random noise with a standard deviation of 2 to  produce a noisy
% signal y.  Take a look at this noisy  signal y by plotting it.

y = x + 2*randn(size(t));     % Sinusoids plus noise
plot(Fs*t(1:100),y(1:100),'r')
title('Signal Corrupted with Zero-Mean Random Noise')


%%
% Clearly, it is difficult to identify the frequency components from looking at
% this signal; that's why spectral analysis is so popular.
%
% Finding the discrete Fourier transform of the noisy signal y is easy; just
% take the fast-Fourier transform (FFT).

NFFT = 2^nextpow2(L);   % Next power of 2 from length of y
Y = fft(y,NFFT)/L;      % Normalized by the length of the signal; Why?

%%
% Compute the power spectral density, a measurement of the energy at various
% frequencies, using the complex conjugate (CONJ).  Form a  frequency axis for
% the first (NFFT/2 + 1) points and use it to plot the result.  (The remainder of the
% points are symmetric.)

Pyy = Y.*conj(Y);
f = Fs/2*linspace(0,1,NFFT/2+1);
figure;
plot(f,Pyy(1:NFFT/2+1));
title('Power spectral density')
xlabel('Frequency (Hz)')
ylabel('Power');

