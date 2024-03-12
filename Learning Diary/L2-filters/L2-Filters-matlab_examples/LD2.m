fs = 44100;
t = 0: 1/fs : 3 - 1/fs;

x = sin(2 * pi * 100 * t) + 0.6 * sin(2 * pi * 200 * t);

signal = x + 0.5 * randn(size(t));
%%
figure;
plot(t, signal)
title('noise signal');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-5, 5]);
xlim([0, 0.1]);
%%
soundsc(signal * 0.1, fs);
%%
soundsc(x * 0.1, fs);
%%
cutoff_freq = 500;
[b, a] = butter(4, cutoff_freq/(fs/2), 'low'); % design a lowpass filter

%%
filtered_signal = filter(b, a, signal);

%%
figure;
plot(t, filtered_signal);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-5, 5]);
xlim([0, 0.1]);
%%

figure;
freqz(b, a, 512, fs);
title('Frequency Response of the Low-pass Filter');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');




