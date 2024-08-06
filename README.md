# TSM (Time-Scale Modification) Algorithms Project

## Goal

The primary goal of this project is to gain experience with the Overlap-Add (OLA) and Wave Similarity Overlap-Add (WSOLA) algorithms. These algorithms are used for time-scale modification (TSM) of audio signals. We will utilize the WSOLA MATLAB function from the TSM toolbox by Meinard Muller from Audiolabs. This project aims to understand the WSOLA algorithm, compare its performance with OLA, and explore the limits of various parameters on different inputs.

## Outline

1. **Download the WSOLA function**: 
   - Obtain `wsola.m` from [Audiolabs TSM Toolbox](https://www.audiolabs-erlangen.de/resources/MIR/TSMtoolbox/).
   - Download the whole package, and add its path to the project.

2. **Test OLA and WSOLA** using different inputs as detailed in the "Experiments and Plots" section.

3. **Outputs**:
   - Modified signal amplitude vs time plots.
   - Output sound files of the modified signals.
   - Spectrum analysis (FFT, not STFT where necessary).

## Parameters

1. **Stretching Factor** (`alfa` = Hs/Ha, `beta` = 1/alfa = Ha/Hs):
   - `alfa > 1` slows down the signal.
   - `alfa < 1` speeds up the signal.

2. **Other Parameters**:
   - Sample rate: Ensure the correct sample rate when loading audio files. You may interpolate or decimate if advantageous.
   - Frame size.
   - Synthesis hop-size.
   - Window types: Rectangular, Hann, Blackman, or optimal Kaiser window with parameter beta.

## Details

### Signal Generation/Loading

- Generate or load signals. For stereo inputs, use the mean or sum of the left and right channels.
- Define the sampling rate when loading files:
  ```matlab
  [x, fs] = audioread("bach_minuet.mp3");
  ```

## Experiments and Plots

### 1. Pitch Modification of a Periodic Signal

1.1 **Generate a signal** for a duration of 1 second:
   ```matlab
   fs = 44100; % Sample rate
   x = cos(2*pi*(1:fs)*261/fs) + 0.4*cos(2*pi*(1:fs)*783/fs);
   ```

1.2 **Transpose the signal** to different pitches (G4 and F3).

1.3 **Using OLA**: Optimize parameters for the best result based on amplitude vs time plot and listening test.

1.4 **Using WSOLA**: Optimize parameters, including `delta`, for the best result based on amplitude vs time plot and listening test.

1.5 **Comparison**: Explain the differences between OLA and WSOLA and the trade-offs made.

### 2. Parameter Limits for Slowing Down & Speeding Up

2.1 **Generate a signal** for a duration of 2 seconds:
   ```matlab
   x = cos(2*pi*(1:2*fs)*261/fs) + 0.4*cos(2*pi*(1:2*fs)*783/fs);
   ```

2.2 **Test WSOLA** for speed changes while maintaining the original pitch using standard parameters (`N=1024`, `Hs=N/2`, `delta=Hs/4`, `alfa` range [0.125, 8]).

2.3 **Evaluate** maximum and minimum possible synthesis hop-size and frame size, explaining theoretical and practical limitations.

### 3. Percussive Signal Testing

3.1 **Use "Bongo_ORIG.wav"** with a sample rate of 22050 Hz.

3.2 **Read Section 4.2 "Artifacts"** in "A review of time scale modification of Music Signals" by Muller & Driedger, 2016.

3.3 **WSOLA**: Find parameters causing "transient doubling" or "stuttering" and "transient skipping" for different `delta` values. Compare with OLA.

### 4. Speech File Testing

4.1 **Use "Female_voice.wav"** and "Male_voice.wav".

4.2 **Estimate frequency ranges** for male and child voices. Change the pitch to achieve desired voice characteristics using OLA and WSOLA.

4.3 **State best parameters** and compare the performance of both algorithms.

## Deliverables

1. **Plots**: Amplitude vs time for all results.
2. **Output Sound Files**: Include parameter settings in filenames and generate filenames directly from parameter values and input type.
3. **Report**: Plots, explanations, and conclusions on OLA & WSOLA performance and capabilities.

### Introduction to WSOLA

- WSOLA improves OLA by correlating neighboring frames and allowing deviations from the defined hop-size within a limited range (`[-Delta, +Delta]`).

### Experiments and Plots

- For each experiment, generate and test signals, adjust parameters, and compare the results of OLA and WSOLA.

### Summary

- Summarize the strengths and weaknesses of OLA and WSOLA based on experimental findings. Provide plots and explanations for the chosen parameters and their effects on the results.

## References

- [TSM Toolbox by Meinard Muller](https://www.audiolabs-erlangen.de/resources/MIR/TSMtoolbox/)
- [A review of time scale modification of Music Signals](https://www.audiolabs-erlangen.de/content/resources/MIR/Publications/2016_Mueller_Driedger_TSM_AcceptedVersion.pdf)

This README provides a comprehensive guide to understanding and using OLA and WSOLA algorithms for time-scale modification of audio signals. Follow the outlined steps and experiments to explore their performance and limitations.
