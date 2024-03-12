% resontool
%
% An interactive tool for demonstrating
% the properties of the digital resonator.
%
% The user can click on the Z plane
% to position the pole of the filter.
%
% Vesa Valimaki, 28.10.2001 Espoo
% Last update: 22.3.2003 (scaling factor A)

figure(1);clf;
format short
x = 0.6;y = 0.6;  % Initial coordinate values for the pole
button = 0;
fontsize = 16;
Nfreq = 512;  % Number of points for magnitude and phase response
Nimp = 50;  % Number of impulse response samples to be computed
%
% Loop with user input
while button~=3  % Repeat until right mouse button is clicked
    shg  % Show figure(1)
    % Compute coefficients, frequency response and impulse response
    theta = atan(y/x);  % Pole angle
    if theta<=0 & x<0, theta = theta + pi; end
    if theta>0 & y<0, theta = theta + pi; end
    theta;
    R = sqrt(x^2 + y^2);  % Pole radius
    a1 = -2*R*cos(theta);  % Coefficient a1
    a2 = R^2;  % Coefficient a2
    [H0,w] = freqz(1,[1 a1 a2],Nfreq,1);  % Compute freq. resp.
    A = 1/max(abs(H0));
    %Ax = abs((1-R^2)*sin(theta));  % Scaling coefficient (max -> 0 dB)
    [H,w] = freqz(A,[1 a1 a2],Nfreq,1);  % Compute freq. resp.
    h = impz(A,[1 a1 a2],Nimp);  % Compute impulse response
    %
    % Pole-zero plot
    subplot(2,2,1);hold off
    zplane([],roots([1 a1 a2]));set(gca,'Fontsize',fontsize);
    title('CLICK POLE POSITION');xlabel('Real part');ylabel('Imaginary part')
    %
    % Impulse response
    subplot(2,2,3)
    stem(0:Nimp-1,h,'fill');axis([0 Nimp min([0 2*min(h)]) max([0 2*max(h)])])
    set(gca,'Fontsize',fontsize);
    xlabel('Sample index');ylabel('Impulse response');grid on
    %
    % Magnitude response
    subplot(2,2,2)
    plot(w,abs(H),'LineWidth',[2]);axis([0 0.5 0 1.1]);
    set(gca,'Fontsize',fontsize);
    ylabel('Magnitude');xlabel('Normalized frequency')
    if a1>0, sign = '+'; else sign = '';end  % Sign of a1
    title(['H(z) = ',num2str(A,3),...
            ' / (1',sign,num2str(a1,3),'z^-^1+',num2str(a2,3),'z^-^2)']);
    %
    % Phase response
    subplot(2,2,4)
    plot(w,angle(H),'LineWidth',[2])
    axis([0 0.5 -pi pi])
    set(gca,'Fontsize',fontsize);
    ylabel('Angle (rad)');xlabel('Normalized frequency')
    %
    % Get pole position (x,y) from left mouse button
    [x,y,button] = ginput(1);
end
