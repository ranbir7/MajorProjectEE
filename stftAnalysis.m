function [detect_time, accuracy, fig] = stftAnalysis(pos_seq, Fs, fault_type)
    window = 512;  % Reduce window size for better frequency resolution
    noverlap = 256; % Reduce overlap for better time localization
    nfft = 512;    % Increase FFT size for better analysis

        % Battery-specific frequency range analysis
    if strcmp(fault_type, 'BATT')
        freq_range = f >= 800 & f <= 1200;  % Focus on 800-1200 Hz
        energy = sum(abs(S(freq_range, :)), 1);
    else
        energy = sum(abs(S), 1);
    end
    
    % Compute STFT
    [S, f, t] = spectrogram(pos_seq, window, noverlap, nfft, Fs, 'yaxis');

    % Fault Detection via Energy
    energy = sum(abs(S), 1);
    threshold = 0.5 * max(energy); % Reduce detection threshold
    detected_samples = find(energy > threshold, 1);
    
    detect_time = Inf;
    if ~isempty(detected_samples)
        detect_time = (detected_samples / Fs) * 1000;
    end

    % === Fault Type Classification ===
    fault_class = classifyFault(fault_type); % Function to classify faults

    % === Visualization ===
    fig = figure('Name', ['STFT Analysis - ', fault_type], 'NumberTitle', 'off');
    ax = axes(fig);
    spectrogram(pos_seq, window, noverlap, nfft, Fs, 'yaxis');
    title(['Spectrogram - ', fault_type, ' (', fault_class, ')']);
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    colorbar;

    % === Disable Toolbar (Optional) ===
    set(fig, 'ToolBar', 'none');

    % Classification Accuracy
    accuracy = evaluateClassification(pos_seq, [], fault_type);
end
