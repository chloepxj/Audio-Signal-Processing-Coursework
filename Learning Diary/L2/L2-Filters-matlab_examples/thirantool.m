function a = thirantool(N)
% THIRANTOOL.M
%
% thirantool(N)
% An interactive tool for demonstrating the properties
% of the Nth-order Thiran fractional delay allpass filter.
%
% The user can click with the "left mouse button" on the phase
% delay plot to select the desired delay D for the filter.
%
% The default order of the allpass filter is 1, but the
% user can select order in the function call, for example
% thirantool(3)
% runs the program using a 3rd-order allpass filter.
%
% Clicking the "right mouse button" quits the program.
%
% Uses: apflat2.m
%
% Vesa Valimaki, 18.2.2002 on the bus to Pori
% Last update 18.4.2002 Barcelona

figure(2);clf
set(gcf,'DoubleBuffer','on');
if nargin == 0,
    N = 1;  % Default order of Thiran allpass filter
end
D = N + 0.5;  % Initial value for desired delay (in samples)
Nfreq = 512;  % Number of frequency points
button = 0;
fontsize = 16;
%
% Loop with user input
while button~=3  % Repeat until right mouse button is used
    d = D - N;  % Fractional part of D
    if d==-1; d = -0.999999; end
    a = apflat2(N,d);  % Design denominator coefficients
    b = a(N+1:-1:1);   % Reverse order for numerator coefficients
    figure(2)
    %
    % Phase delay response
    subplot(2,2,1)
    [H,w] = freqz(b,a,Nfreq,1);  % Compute frequency response
    plot(0.01,N-1,'^');hold on  % Mark lower limit for stability (N-1)
    plot(0.01,N,'.g');  % Mark lower limit of optimal interval (N)
    plot([0 0.5],[D D],'r','LineWidth',2);  % Mark desired delay
    plot(w(2:Nfreq),-(unwrap(angle(H(2:Nfreq)))./(2*pi*w((2:Nfreq)))),...
        'LineWidth',[2]);  % Plot phase delay response
    axis([0 0.5 N-1.5 N+3.5]);hold off
    set(gca,'Fontsize',fontsize);
    title('CLICK DESIRED DELAY HERE');
    ylabel('Phase delay (samples)');xlabel('Normalized frequency')
    text(0.1,N+3,['Desired delay D = ',num2str(D)],'Fontsize',fontsize);
    %
    % Phase response
    subplot(2,2,2)
    plot([0 0.5],[0 -N],'g','LineWidth',1.5); hold on 
    % Phase response of delay of N samples
    % (just for comparison, because Thiran allpass filter deviates from this)
    plot(w,unwrap(angle(H))/pi,'LineWidth',2);  % Plot phase response
    axis([0 0.5 -N-0.2 0.2]);hold off
    set(gca,'Fontsize',fontsize);
    xlabel('Normalized frequency');ylabel('Phase (rad/pi)');
    title(['Thiran allpass filter: N = ',num2str(N)]);
    %
    % Impulse response
    subplot(2,2,3)
    h = impz(b,a,N+10);  % Compute first N+10 impulse response samples
    stem(0:N+9,h,'fill');  % Plot beginning of impulse response
    axis([-.5 N+10-.5 -1.5 1.5]);hold on
    plot([-.5 N+10-.5],[0 0],':k');  % Mark zero
    plot([D D],[0 1],'r','LineWidth',2);  % Mark desired delay
    %(unit impulse at a fractional point between samples)
    set(gca,'Fontsize',fontsize);hold off
    ylabel('Impulse response');xlabel('Sample index')
    %title(['a = [',num2str(a,3),']'])
    text(0,-1,['a = [',num2str(a,3),']'],'Fontsize',fontsize);
    %
    % Pole-zero plot
    subplot(2,2,4)
    ra = roots(a);  % Solve poles (zeros of denominator)
    rb = roots(b);  % Solve zeros (zeros of numerator)
    zplane(rb,ra);set(gca,'Fontsize',fontsize);
    %title('Poles and zeros');
    xlabel('Real part');ylabel('Imaginary part')
    %
    figure(2);[xxx,D0,button] = ginput(1);  % Get desired delay D
    D = round(D0*50)/50;  % Quantize to steps of 0.02
    %D = quant(D0,0.02);  % Quantize to steps of 0.02
end
