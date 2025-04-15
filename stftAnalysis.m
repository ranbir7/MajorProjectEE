function [detect_time, accuracy, fig] = stftAnalysis(pos_seq, Fs, fault_type)
    % Optimized parameters for battery faults
    window = 128;       % Shorter window for better time resolution
    noverlap = 64;      % 50% overlap
    nfft = 256;
    
    % Compute STFT
    [S, f, t] = spectrogram(pos_seq, window, noverlap, nfft, Fs, 'yaxis');
    
    % Battery-specific analysis
    fault_class = classifyFault(fault_type);
    if strcmp(fault_class, 'Battery')
        freq_range = (f >= 800) & (f <= 1200);
        energy = max(abs(S(freq_range, :)), [], 1); % Peak detection
        threshold = 0.65 * max(energy);
    else
        energy = sum(abs(S), 1);                    % Broadband energy
        threshold = 0.5 * max(energy);
    end
    
    % Find first sustained detection
    detected_bins = find(energy > threshold);
    if ~isempty(detected_bins)
        % Get exact detection time (center of first qualifying window)
        detect_time = t(detected_bins(1)) * 1000;    % Convert to ms
    else
        detect_time = Inf;
    end

    % Visualization
    fig = figure('Name', ['STFT Analysis - ', fault_type], ...
                 'NumberTitle', 'off', 'Position', [100 100 800 600]);
    
    % Plot spectrogram
    [~, ~, ~, h] = spectrogram(pos_seq, window, noverlap, nfft, Fs, 'yaxis');
    title(['STFT - ', fault_type, ' (', fault_class, ')'], 'FontSize', 12);
    colorbar('EastOutside');
    
    % Focus on relevant frequencies for battery faults
    if strcmp(fault_class, 'Battery')
        ylim([500 1500]);
        set(h, 'YData', f);  % Force axis update
    end
    
    % Add threshold line
    hold on;
    plot(t, threshold * ones(size(t)), '--r', 'LineWidth', 1.5);
    hold off;
    
    accuracy = evaluateClassification(pos_seq, [], fault_type);
end