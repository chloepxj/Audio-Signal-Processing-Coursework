% minphase_hilbert.m
% Script that constructs a minimum-phase filter having the same magnitude 
% response as a given FIR filter using the Hilbert transform.
%
% Vesa Välimäki 6.2.2001
% last modified 21.2.2007 by Heidi-Maria Lehtonen
% Modified 6.2.2015 by Vesa välimäki

N = 20;  % Order of FIR filter
NFFT = 2048;  % Must be long enough!!!
%h = fir1(N,0.4);  % An example linear-phase FIR filter
h = 0.5*(rand(1,N+1)-0.5);
H = fft(h,NFFT);  % Let's go into the frequency domain
P = -imag(hilbert(log(abs(H))));  % Compute the minimum-phase function
Hm = abs(H).*exp(j*P);  % Replace phase response with P
hm = real(ifft(Hm));  % Obtain the minimum-phase impulse response
%
figure(1);freqz(h,1,512,1);axis([0 0.5 -100 10])
title('Original FIR Filter');zoom on
figure(2);freqz(hm,1,512,1);axis([0 0.5 -100 10])
title('Minimum-Phase FIR Filter');zoom on
figure(3);subplot(2,1,1);stem(0:N,h,'fill')
title('Original FIR Filter')
figure(3);subplot(2,1,2);stem(0:N,hm(1:N+1),'fill')
title('Minimum-Phase FIR Filter')
