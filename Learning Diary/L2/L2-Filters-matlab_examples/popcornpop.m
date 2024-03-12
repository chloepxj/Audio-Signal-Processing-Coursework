function [pop,fw,fc,exc] = popcornpop(varargin)
%POPCORNPOP(playsound)
%
% Single popcorn pop sound simulator
%
% Exponantially decaying white noise is filtered
% with a second-order resonator with center
% frequency about 400 Hz with some random variation
% and bandwidth between 50 and 150 Hz.
%
% Example:
% popcornpop(1);
% will play a single pop with randomized properties
%
% Vesa Valimaki 2.7.2002
% 
% Ref:
% Russell Pinkston, "Constrained Random Event Generation
% and Retriggering in Csound," in The Csound Book (ed.
% Richard Boulanger), MIT Press, Cambridge, MA, 2000,
% pp. 339-352.

if nargin == 1,
    playsound = 1;
else playsound = 0;
end
%
fs = 44100;  % Sample rate (Hz)
fw = 50 + rand*100;  % Bandwidth of resonance (randomized 50...150 Hz) 
%fw = 1 + rand*50;  % Uncomment this to try a very narrow resonance 
fc = 300 + rand*100;  % Center frequency of resonance (Hz)
%fc = 1000 + rand*100;  % Uncomment this to try a higher resonance freq. 
%
% Design resonator
B = 2*pi*fw/fs;  % Bandwidth in radians
R = 1 - (B/2);  % Radius of pole
a1 = -2*R*cos(2*pi*fc/fs);  % Coefficient a1
a2 = R^2;  % Coefficient a2
%
% Design excitation signal
exc = zeros(1,10000);  % Initialize excitation sequence
popdur = 10000;  % Duration in samples
env = filter(1,[1 -0.999],[1 zeros(1,popdur-1)]);  % Exponential envelope
noiseseq = rand(1,popdur)-0.5;  % White noise sequence
exc(1:popdur) = env.*noiseseq;  % White noise with exponential envelope
%
% Generate pop by filtering the noise sequence with the resonator
pop = filter([1 0 -1],[1 a1 a2],exc);
%
% Play the pop, when desired
if playsound~=0, soundsc(pop,fs), end
