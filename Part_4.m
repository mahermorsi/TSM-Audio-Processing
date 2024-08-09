%loading the voice files

[x,fs1] = audioread("Female_voice.wav");
[y,fs2] = audioread("Male_voice.wav");

L1 = length(x);
L2 = length(y);
clear parameter

%finding the vocal range
X = abs(fft(x));
Y = abs(fft(y));
%ploting the FFTs

figure(); 
subplot(3,2,1);
plot((fs1/L1)*(0:L1/2),X(1:L1/2+1));
xlabel("f[Hz]");
ylabel("magnitude");
title("female voice FFT");
subplot(3,2,2);
plot((fs2/L2)*(0:L2/2),Y(1:L2/2+1));
xlabel("f[Hz]");
ylabel("magnitude");
title("male voice FFT");

%calculating the shift 
n_w2m = 1200*log2(194/220);
n_m2w = 1200*log2(220/194);

%performing the shift
clear parameter
parameter.fsAudio = fs1;
%OLA
parameter.algTSM = @olaTSM;
x_ola = pitchShiftViaTSM(x, n_w2m, parameter);
y_ola = pitchShiftViaTSM(y, n_m2w, parameter);
%SWOLA
parameter.tolerance = 200;
parameter.algTSM = @wsolaTSM;
x_wsola = pitchShiftViaTSM(x, n_w2m, parameter);
y_wsola = pitchShiftViaTSM(y, n_m2w, parameter);

%calculating the FFT
X_ola = abs(fft(x_ola));
X_wsola = abs(fft(x_wsola));
Y_ola = abs(fft(y_ola));
Y_wsola = abs(fft(y_wsola));

%plotting the results
subplot(3,2,3);
plot((fs1/L1)*(0:L1/2),X_ola(1:L1/2+1));
xlabel("f[Hz]");
ylabel("magnitude");
title("female voice after OLA shift FFT");
subplot(3,2,5);
plot((fs1/L1)*(0:L1/2),X_wsola(1:L1/2+1));
xlabel("f[Hz]");
ylabel("magnitude");
title("female voice after WSOLA shift FFT");
subplot(3,2,4);
plot((fs2/L2)*(0:L2/2),Y_ola(1:L2/2+1));
xlabel("f[Hz]");
ylabel("magnitude");
title("male voice after OLA shift FFT");
subplot(3,2,6);
plot((fs2/L2)*(0:L2/2),Y_wsola(1:L2/2+1));
xlabel("f[Hz]");
ylabel("magnitude");
title("male voice after WSOLA shift FFT");

%writing the data
audiowrite("male shift OLA.wav", y_ola, fs2);
audiowrite("male shift WSOLA.wav", y_wsola, fs2);
audiowrite("female shift OLA.wav", x_ola, fs2);
audiowrite("female shift WSOLA.wav", x_wsola, fs2);



