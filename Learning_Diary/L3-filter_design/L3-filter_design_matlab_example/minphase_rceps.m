% minphasex.m
% Script that designs a linear pahse filter with Matlab's 'fir1' function
% and constructs a minimum phase filter using the cepstral-domain windowing.
% 
% Vesa V�lim�ki 6.2.2001
% last modified 21.2.2007 by Heidi-Maria Lehtonen

N = 60;  % Order of FIR filter
NFFT = 2048;  % Must be long enough!!!
h = fir1(N,0.4);  % An example linear-phase FIR filter
H = fft(h,NFFT);  % Let's go into the frequency domain

% NOTE THAT THIS IS EXACTLY WHAT THE FUNCTION RCEPS.M DOES!
xhat = real(ifft(log(abs(H))));
odd = fix(rem(NFFT,2));
wn = [1; 2*ones((NFFT+odd)/2-1,1) ; ones(1-rem(NFFT,2),1); zeros((NFFT+odd)/2-1,1)];
Bhat = zeros(1,NFFT);
hm(:) = real(ifft(exp(fft(wn.*xhat(:)))));

figure(1);freqz(h,1,512,1);axis([0 0.5 -100 10])
title('Original Linear-Phase FIR Filter');zoom on
figure(2);freqz(hm,1,512,1);axis([0 0.5 -100 10])
title('Minimum-Phase FIR Filter');zoom on
figure(3);subplot(2,1,1);stem(0:N,h,'fill')
title('Original Linear-Phase FIR Filter')
figure(3);subplot(2,1,2);stem(0:N,hm(1:N+1),'fill')
title('Minimum-Phase FIR Filter')
