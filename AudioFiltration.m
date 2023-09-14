% Read audio file
[x,fs] = audioread("audio.wav"); 
len = length(x);
X=fft(x,len);

%load filter 
load('filter.mat');

%Shifting the spectrum to be centered around zero
frequency=(-len/2:len/2-1)*fs/len;

%Plotting audio signal against frequency in HZ
subplot(2,1,1)
plot(frequency,abs(fftshift(X))/len);
xlabel('frequency in HZ');
ylabel('Amplitude');
title ('the original audio');
grid on

%Filtering audio signal
Filtered_Audio = filter(Hd,x);
AudioTransform = fft(Filtered_Audio);

%Plot Signal of Filtered Audio Signal (shifted around 0)
subplot(2,1,2)
plot(frequency,abs(fftshift(AudioTransform))/len);
xlabel('frequency in HZ');
ylabel('Amplitude');
title ('the filtered audio');
grid on

%play filtered audio signal
sound(Filtered_Audio,fs);
audiowrite('filtered.wav',Filtered_Audio,fs);
 f2 = (-len/2:len/2-1)*2*fs/len ;
 
 %Plot Frequency response & impulse response of Filter
 freqz (Hd);
 impz (Hd);
 
 %Multiplying the audio speed x2
 Doubled_sound = stretchAudio(Filtered_Audio,2);
 sound(Doubled_sound,fs);
 subplot(3,1,1)
 
%Plot Signal of Filtered Multiplyed speed Audio Signal (shifted around 0)
 plot(f2,abs(fftshift(AudioTransform))/len);
 xlabel('frequency in HZ');
 ylabel('Amplitude');
 title ('the stretched audio');
 grid on

 %specification of the filter which we used
 function Hd = LowPassFilter 
Fs = 48000;  % Sampling Frequency

N  = 100;   % Order
Fc = 2000;  % Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
Hd = design(h, 'butter');
end