function h = lagrtool(N)
% LAGRTOOL.M
%
% An interactive tool for demonstrating the properties
% of the Lagrange interpolation FIR filter.
%
% The user can click on the phase delay plot
% to select the desired delay D for the filter.
%
% Optional parameter N is the order of the filter.
% The default filter order is N = 3.
%
% Uses: HLAGR2.m
%
% Vesa Valimaki, 13.2.2002 & 16.2.2002 Espoo
% Last update 18.4.2002 Barcelona

figure(1);clf
set(gcf,'DoubleBuffer','on');
if nargin == 0,
    N = 3;  % Default order of Lagrange FIR filter
end
D = N/2;  % Initial value for desired delay (in samples)
Nfreq = 512;  % Number of frequency points
button = 0;
fontsize = 16;
%
% Loop with user input
while button~=3  % Repeat until right mouse button is used
    L = N+1;  % Filter length (order + 1)
    d = D-floor(N/2);  % Fractional part of D
    h = HLAGR2(L,d);  % Design Lagrange filter coefficients
    [H,w] = freqz(h,1,Nfreq,1);  % Compute frequency response
    %
    % Phase delay response
    figure(1);subplot(2,2,1)
    plot(0,N/2,'>');hold on  % Mark mid-point
    plot([0 0.5],[D D],'r','LineWidth',2);  % Mark desired delay
    plot(w(2:Nfreq),-(unwrap(angle(H(2:Nfreq)))./(2*pi*w((2:Nfreq)))),...
        'LineWidth',[2]);  % Plot phase delay response
    axis([0 0.5 0 N]);hold off
    set(gca,'Fontsize',fontsize);
    title('CLICK DESIRED DELAY HERE');
    ylabel('Phase delay (samples)');xlabel('Normalized frequency')
    text(0.1,0.9*N,['Desired delay D = ',num2str(D)],'Fontsize',fontsize);
    %
    % Impulse response
    subplot(2,2,3)
    stem(0:N,h,'fill');  % Plot coefficients
    axis([-.5 N+.5 -1.5 1.5]);hold on
    plot([-.5 N+.5],[0 0],':');  % Mark zero
    plot([D D],[0 1],'r','LineWidth',2);  % Mark desired delay
    %(unit impulse at a fractional point between samples)
    set(gca,'Fontsize',fontsize);hold off
    ylabel('Coefficient value');xlabel('Coefficient index')
    text(0,-0.8,['N = ',num2str(N)],'Fontsize',fontsize);
    %
    % Magnitude response
    subplot(2,2,2)
    plot([0 0.5],[1 1],'g','LineWidth',1.5); hold on  % Mark unity magnitude
    plot(w,abs(H),'LineWidth',[2]);  % Plot magnitude response
    axis([0 0.5 0 1.5]);hold off
    set(gca,'Fontsize',fontsize);
    ylabel('Magnitude');xlabel('Normalized frequency');title('Magnitude response');
    %
    % Pole-zero plot
    subplot(2,2,4)
    r = roots(h);  % Solve roots (transfer function zeros)
    zplane(r,[]);set(gca,'Fontsize',fontsize);
    xlabel('Real part');ylabel('Imaginary part')
    %
    figure(1);[xxx,D0,button] = ginput(1);  % Get desired delay D
    D = round(D0*50)/50;  % Quantize to steps of 0.02
    %D = quant(D0,0.02);  % Quantize to steps of 0.02
end
