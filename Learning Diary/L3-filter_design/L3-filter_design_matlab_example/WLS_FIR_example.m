% Example script demonstrating the properties of weighted least-squares FIR
% filter design

% Juho Liski
% created 3.2.2021

clear;
close all;
clc;

fs = 44.1e3;

%% The filter design

% Frequncy points 
f = [0 0.44 0.46 0.54 0.56 1];
% Amplitudes corresponding to the frequencies (bandpass filter)
a = [0 0 1 1 0 0];

% Different weight configurations
w1 = [1 1 1]; % No weight
w2 = [100 1 1]; % Add weight to the first stop band
w3 = [1 100 1]; % Add weight to the pass band
w4 = [1 1 100]; % Add weight to the second stop band

% Filter order
n = 200;

% The filters
b1 = firls(n,f,a,w1);
b2 = firls(n,f,a,w2);
b3 = firls(n,f,a,w3);
b4 = firls(n,f,a,w4);

% Evaluate the filters
N = 2^10;
[H1,W] = freqz(b1,1,N);
H2 = freqz(b2,1,N);
H3 = freqz(b3,1,N);
H4 = freqz(b4,1,N);

%% Plotting

% Plot filter 1
figure(1);
plot(W/(2*pi),db(H1),'linewidth',2,'color',[92 26 143]/255)
ylim([-120 10]);
ylabel('Magnitude (dB)');
xlabel('Normalized Frequency');
set(gca,'FontName','Times','FontSize',18);
% Add the texts
text(0.1,-70,'1','FontSize',22)
text(0.245,5,'1','FontSize',22)
text(0.4,-70,'1','FontSize',22)
% Add the inset figure
axes('Position',[.2 .7 .2 .2])
box on
plot(W/(2*pi),db(H1),'linewidth',2,'color',[92 26 143]/255)
ylim([-0.3 0.3]);
xlim([0.2 0.3]);
xticks([])
set(gca,'FontName','Times','FontSize',15);
%print(figure(1),'-dpdf','fig1','-r0','-painters')

% Plot the other filters similarly to filter 1
figure(2);
plot(W/(2*pi),db(H2),'linewidth',2,'color',[92 26 143]/255)
ylim([-120 10]);
ylabel('Magnitude (dB)');
xlabel('Normalized Frequency');
set(gca,'FontName','Times','FontSize',18);
text(0.1,-70,'100','FontSize',22)
text(0.245,5,'1','FontSize',22)
text(0.4,-45,'1','FontSize',22)
axes('Position',[.2 .7 .2 .2])
box on
plot(W/(2*pi),db(H2),'linewidth',2,'color',[92 26 143]/255)
ylim([-0.3 0.3]);
xlim([0.2 0.3]);
xticks([])
set(gca,'FontName','Times','FontSize',15);
%print(figure(2),'-dpdf','fig2','-r0','-painters')

figure(3);
plot(W/(2*pi),db(H3),'linewidth',2,'color',[92 26 143]/255)
ylim([-120 10]);
ylabel('Magnitude (dB)');
xlabel('Normalized Frequency');
set(gca,'FontName','Times','FontSize',18);
text(0.1,-42,'1','FontSize',22)
text(0.23,5,'100','FontSize',22)
text(0.4,-42,'1','FontSize',22)
axes('Position',[.2 .7 .2 .2])
box on
plot(W/(2*pi),db(H3),'linewidth',2,'color',[92 26 143]/255)
ylim([-0.3 0.3]);
xlim([0.2 0.3]);
xticks([])
set(gca,'FontName','Times','FontSize',15);
%print(figure(3),'-dpdf','fig3','-r0','-painters')

figure(4);
plot(W/(2*pi),db(H4),'linewidth',2,'color',[92 26 143]/255)
ylim([-120 10]);
ylabel('Magnitude (dB)');
xlabel('Normalized Frequency');
set(gca,'FontName','Times','FontSize',18);
text(0.1,-42,'1','FontSize',22)
text(0.245,5,'1','FontSize',22)
text(0.4,-70,'100','FontSize',22)
axes('Position',[.2 .7 .2 .2])
box on
plot(W/(2*pi),db(H4),'linewidth',2,'color',[92 26 143]/255)
ylim([-0.3 0.3]);
xlim([0.2 0.3]);
xticks([])
set(gca,'FontName','Times','FontSize',15);
%print(figure(4),'-dpdf','fig4','-r0','-painters')

