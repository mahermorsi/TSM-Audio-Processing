[x,fs] = audioread("Bongo_ORIG.wav");

clear parameter
parameter.fsAudio = fs;
% 3.4 

% part 3(alpha = 2)

%set parameters
alpha = 2;
delta = 50;
parameter.win = win(128,2);
parameter.synHop = 64;
parameter.tolerance = delta;

%apply OLA
y_ola=olaTSM(x,alpha,parameter);

% Apply WSOLA
y_wsola = wsolaTSM(x,alpha,parameter);

figure;
title('alpha=0.5')
subplot(3,2,1);
plot(x); % Assuming the original signal is y_OLA for plotting
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the amplitude vs time for OLA
subplot(3,2,2);
plot(y_wsola);
title('for delta = 100');
xlabel('Time (s)');
ylabel('Amplitude');

%trying to find delta to cause stutering

delta = 500;
parameter.tolerance = delta;
% Apply WSOLA
y_wsola1 = wsolaTSM(x,alpha,parameter);

delta = 800;
parameter.tolerance = delta;
% Apply WSOLA
y_wsola2 = wsolaTSM(x,alpha,parameter);

% Plot the amplitude vs time for OLA
subplot(3,2,3);
plot(y_wsola1);
title('for delta=500');
xlabel('Time');
ylabel('Amplitude');

subplot(3,2,4);
plot(y_wsola1);
title('for delta=800');
xlabel('Time');
ylabel('Amplitude');

%trying to get transient skipping
delta = 1;
parameter.tolerance = delta;
parameter.synHop = 100;
y_wsola3 = wsolaTSM(x,alpha,parameter);

subplot(3,2,5)
plot(y_wsola3);
title('for delta = 1 and syncHop = 100');
xlabel('Time (s)');
ylabel('Amplitude');
sgtitle('\alpha = 2');

subplot(3,2,6);
plot(y_ola);
title('for OLA');
xlabel('Time (s)');
ylabel('Amplitude');

%write the data
audiowrite("alpha=2 OLA.wav", y_ola, fs);
audiowrite("alpha=2 SWOLA regular.wav", y_wsola, fs);
audiowrite("alpha=2 SWOLA stattur.wav", y_wsola2, fs);
audiowrite("alpha=2 SWOLA skiping.wav", y_wsola3, fs);