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
parameter.fsAudio = fs;

% Using OLA for pitch shifting, tolerance is 0 in default.
parameter.algTSM = @olaTSM;
y_G4_OLA = pitchShiftViaTSM(x, n_G4, parameter);
y_F3_OLA = pitchShiftViaTSM(x, n_F3, parameter);

% Using WSOLA for pitch shifting, tolerance is 512 in default.
clear parameter
parameter.fsAudio = fs;
parameter.algTSM = @wsolaTSM; % WSOLA function in TSM toolbox
y_G4_WSOLA = pitchShiftViaTSM(x, n_G4, parameter);
y_F3_WSOLA = pitchShiftViaTSM(x, n_F3, parameter);

% Plot amplitude versus time
plot_and_save_pitch_shifted_signals(x, 'G4',y_G4_OLA,y_G4_WSOLA,fs);
plot_and_save_pitch_shifted_signals(x, 'F3',y_F3_OLA,y_F3_WSOLA,fs);




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