fs = 44100;
G4 = 392;
C4 = 261;
F3 = 174.61;
% Generate the signal for a duration of 1 sec
t = 0:1/fs:1-1/fs;
x = cos(2*pi*261*t) + 0.4*cos(2*pi*783*t);
x = x';

% Transpose (change pitch) to G4 (392 Hz)
n_G4 = 1200 * log2(G4/C4); 
n_F3 = 1200 * log2(F3/C4); 

clear parameter
% Using OLA for pitch shifting, tolerance is 0 in default.
parameter.algTSM = @olaTSM;
parameter.synHop = 1024;
parameter.win = win(2048,2);
y_G4_OLA = pitchShiftViaTSM(x, n_G4, parameter);
y_F3_OLA = pitchShiftViaTSM(x, n_F3, parameter);

% Using WSOLA for pitch shifting, tolerance is 512 in default.
clear parameter
parameter.algTSM = @wsolaTSM; % WSOLA function in TSM toolbox
y_G4_WSOLA = pitchShiftViaTSM(x, n_G4, parameter);
y_F3_WSOLA = pitchShiftViaTSM(x, n_F3, parameter);

% Plot amplitude versus time
plot_and_save_pitch_shifted_signals(x, 'G4',y_G4_OLA,y_G4_WSOLA,fs);
plot_and_save_pitch_shifted_signals(x, 'F3',y_F3_OLA,y_F3_WSOLA,fs);

plot_and_save_fft(y_G4_OLA, y_G4_WSOLA, fs, 'G4');
plot_and_save_fft(y_F3_OLA, y_F3_WSOLA, fs, 'F3');

function plot_and_save_fft(y_OLA, y_WSOLA, fs, targetNote)
    % Compute the FFT for OLA and WSOLA signals
    Y_OLA = fft(y_OLA);
    Y_WSOLA = fft(y_WSOLA);

    % Frequency vector for plotting
    N = length(Y_OLA);
    f = (0:N-1)*(fs/N);

    % Plot the FFT for OLA
    figure;
    subplot(2,1,1);
    plot(f, abs(Y_OLA)/max(abs(Y_OLA))); % Normalize FFT for better visualization
    title(['FFT of Transposed Signal to ', targetNote, ' using OLA']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (Normalized)');
    xlim([0 2000]); % Focus on the relevant frequency range

    % Plot the FFT for WSOLA
    subplot(2,1,2);
    plot(f, abs(Y_WSOLA)/max(abs(Y_WSOLA))); % Normalize FFT for better visualization
    title(['FFT of Transposed Signal to ', targetNote, ' using WSOLA']);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (Normalized)');
    xlim([0 2000]); % Focus on the relevant frequency range
    % Save the FFT plots
    outputFilename_FFT = ['FFT of C4 to ', targetNote, '.png'];
    outputDir = './Part One graphs outputs';  
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);  % Create the directory if it doesn't exist
    end

    saveas(gcf, fullfile(outputDir, outputFilename_FFT));
    disp(['FFT plot saved to: ' outputFilename_FFT]);
end

function plot_and_save_pitch_shifted_signals(x, targetNote, y_OLA, y_WSOLA, fs)
    % Time vector for the original signal
    t = (0:length(y_OLA)-1) / fs;

    % Plot the original signal
    figure;
    subplot(3,1,1);
    plot(t, x); % Assuming the original signal is y_OLA for plotting
    title('Original Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Plot the amplitude vs time for OLA
    subplot(3,1,2);
    plot((0:length(y_OLA)-1)/fs, y_OLA);
    title(['Transposed Signal to ', targetNote, ' using OLA']);
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Plot the amplitude vs time for WSOLA
    subplot(3,1,3);
    plot((0:length(y_WSOLA)-1)/fs, y_WSOLA);
    title(['Transposed Signal to ', targetNote, ' using WSOLA']);
    xlabel('Time (s)');
    ylabel('Amplitude');
    
    % Save the figure to the specified directory
    outputDir = './Part One graphs outputs';  % Specify the output directory
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);  % Create the directory if it doesn't exist
    end

    outputFilename = ['Amplitude vs Time for C4 to ', targetNote, '.png'];
    saveas(gcf, fullfile(outputDir, outputFilename));

    % Save the transposed signals for listening test
    audioOutputDir = './Part One audio outputs';  % Specify the audio output directory
    if ~exist(audioOutputDir, 'dir')
        mkdir(audioOutputDir);  % Create the directory if it doesn't exist
    end

    % Save the transposed signals for listening test
    outputFilename_OLA = ['C4 to ', targetNote, ' using OLA.wav'];
    outputFilename_WSOLA = ['C4 to ', targetNote, ' using WSOLA.wav'];
    outputDir = './Part One audio outputs';  % Specify the output directory
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);  % Create the directory if it doesn't exist
    end

    audiowrite(fullfile(outputDir,outputFilename_OLA), y_OLA, fs);
    audiowrite(fullfile(outputDir,outputFilename_WSOLA), y_WSOLA, fs);

    disp(['OLA pitch-shifted file saved to: ' outputFilename_OLA]);
    disp(['WSOLA pitch-shifted file saved to: ' outputFilename_WSOLA]);
end