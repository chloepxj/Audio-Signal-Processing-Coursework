% Example script demonstrating the use of Matlab functions in analyzing
% and designing filters and converting them to minimum phase
%
% Juho Liski & Vesa Välimäki
% Created 3.2.2021, modified 3.2.2023

clear;
close all;
clc;

fs = 100e3;  % Sample rate used is 100 kHz

%% Loudspeaker modeling with two linear-phase FIR filters

% Low-frequency highpass filter
bLF = firls(256,[0 1e-3 0.02 1],[0 0 1 1]);

% High-frequency lowpass filter
bHF = firls(32,[0 0.28 0.56 1],[1 1 0 0]);

% Full model
bLS = conv(bLF,bHF);

% Plots
% The full frequency response
figure(1); %set(figure(1),'position',[377 685 560 420]);
freqz(bLS,1,1024,fs);
%freqz(bLS,1,1024,fs); set(gca,'xscale','log')

% The frequency responses of the separate filters
%figure(11); freqz(bLF,1,1024,1);
%figure(12); freqz(bHF,1,1024,fs); %set(figure(12),'position',[377 685 560 420]);

% The full impulse response
figure(2); %set(figure(2),'position',[377 685 560 420]);
impz(bLS,1);
set(gca,'FontSize',14,'FontName','Times')
title('Impulse response');
xlim([119 169])

% The impulse responses of the separate filters
%figure(13); impz(bLF,1);
%figure(14); impz(bHF,1); %set(figure(14),'position',[377 685 560 420]);

% Example pole-zero plot: The lowpass filter
figure(3); %set(figure(3),'position',[377 685 560 420]);
zplane(bHF,1);
set(gca,'FontSize',14)
set(gca,'FontName','Times New Roman')
title('Pole-zero plot');

%% Conversion to minimum phase

NFFT = 2^12; % Must be long enough!!!
H(:,1) = fft(bLF,NFFT); % Let's go into the frequency domain
H(:,2) = fft(bHF,NFFT);

% NOTE THAT THIS IS EXACTLY WHAT THE FUNCTION RCEPS.M DOES!
for k = 1:2
    xhat = real(ifft(log(abs(H(:,k)))));
    odd = fix(rem(NFFT,2));
    wn = [1; 2*ones((NFFT+odd)/2-1,1) ; ones(1-rem(NFFT,2),1); zeros((NFFT+odd)/2-1,1)];
    Bhat = zeros(1,NFFT);
    hm(:,k) = real(ifft(exp(fft(wn.*xhat(:)))));
end

% Full filter
hLS = conv(hm(:,1),hm(:,2));

% Plots


% The frequency responses of the separate filters
%figure(21); freqz(hm(:,1),1,1024,1);
%figure(22); freqz(hm(:,2),1,1024,fs); %set(figure(22),'position',[939 685 560 420]);

% The full impulse response
figure(4); %set(figure(4),'position',[939 685 560 420]);
impz(hLS,1);
set(gca,'FontSize',14,'FontName','Times')
title('Impulse response, after min-phase convernsion');
xlim([0 50])

% The impulse responses of the separate filters
%figure(23); impz(hm(:,1),1);
%figure(24); impz(hm(:,2),1); xlim([0 32]); %set(figure(24),'position',[939 685 560 420]);

% The full frequency response, check that the magnitude didn't change!
figure(5); %set(figure(5),'position',[939 685 560 420]);
freqz(hLS,1,1024,fs);
%freqz(hLS,1,1024,fs); set(gca,'xscale','log')
title('Magnitude, after min-phase conversion');

% Example pole-zero plot: The lowpass filter
% The zeros outside the unit circle are now moved inside the
% unit circle
rs = roots(bHF); % Compute the roots of the polynomial B
for k = 1:length(rs)    
    if abs(rs(k)) > 1 % Find the zeros that are outside the unit circle
        rs(k) = (1/abs(rs(k))).*exp(1i*angle(rs(k))); % Feflect the zeros
    end
end
Bn = poly(rs); % Find the polynomial with the specified roots

figure(6); %set(figure(6),'position',[939 685 560 420]);
zplane(Bn,1);
set(gca,'FontSize',14)
set(gca,'FontName','Times New Roman')
title('Pole-zero plot, after min-phase conversion');
