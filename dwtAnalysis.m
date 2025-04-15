function [detect_time, accuracy, fig] = dwtAnalysis(pos_seq, zero_seq, Fs, fault_type)
    wavelet_name = 'db2'; % PDF uses db2
    level = 3;

    %battery Fault
    d1 = detcoef(c, l, 1);
    
    % Adaptive threshold selection
    if strcmp(fault_type, 'BATT')
        threshold = 0.7 * max(abs(d1));  % Use D1 for battery faults
        detected_samples = find(abs(d1) > threshold);
    else
        threshold = 0.4 * max(abs(d3));  % Original D3 logic
        detected_samples = find(abs(d3) > threshold);
    end

    % DWT Decomposition
    [c, l] = wavedec(pos_seq, level, wavelet_name);
    d3 = detcoef(c, l, level); 
    a3 = appcoef(c, l, wavelet_name); 
    
    % Determine Fault Classification
    fault_class = classifyFault(fault_type); 

    % Threshold for D3 Only (No Thresholds for A3 or Original Signal)
    threshold_d3 = 0.4 * max(abs(d3));

    % Double Detection Logic (2 consecutive samples)
    detected_samples = find(abs(d3) > threshold_d3);
    cons_detections = find(diff(detected_samples) == 1, 1); 
    
    detect_time = Inf;
    if ~isempty(cons_detections)
        fault_sample = detected_samples(cons_detections);
        detect_time = (fault_sample * (2^level) * 1000) / Fs; % Convert to ms
    end
    
    % Time Vectors for All Subplots
    t_original = (0:length(pos_seq)-1)/Fs; % Original signal time (seconds)
    t_a3 = (0:length(a3)-1)*(2^level)/Fs; % A3 coefficients time (seconds)
    t_d3 = (0:length(d3)-1)*(2^level)/Fs; % D3 coefficients time (seconds)
    
    % === Visualization ===
    fig = figure('Name', ['DWT Analysis - ', fault_type, ' (', fault_class, ')'], ...
                 'NumberTitle', 'off', 'Color', 'w');


    % === 1. Original Signal (No Threshold) ===
    subplot(3,1,1);
    plot(t_original, pos_seq, 'k'); % Removed bold lines
    title('Original Signal', 'FontSize', 10, 'FontWeight', 'bold');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([0 t_original(end)]);

    % === 2. Approximation Coefficients (A3) (No Threshold) ===
    subplot(3,1,2);
    plot(t_a3, a3, 'b'); % Removed bold lines
    title('Approximation Coefficients (A3)', 'FontSize', 10, 'FontWeight', 'bold');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([0 t_original(end)]);

    % === 3. Detail Coefficients (D3) with Threshold/Fault Markers ===
    subplot(3,1,3);
    plot(t_d3, d3, 'r'); % Removed bold lines
    hold on;
    yline(threshold_d3, '--k', 'Threshold', 'FontSize', 8, 'FontWeight', 'bold', 'Color', 'k'); 
    if ~isempty(cons_detections)
        fault_time = t_d3(fault_sample); % Time in seconds
        xline(fault_time, '--b', 'Fault!', 'FontSize', 8, 'FontWeight', 'bold', 'Color', 'b');
    end
    title('Detail Coefficients (D3)', 'FontSize', 10, 'FontWeight', 'bold');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([0 t_original(end)]);

    % Add D1 plot for battery faults
    if strcmp(fault_type, 'BATT')
        subplot(4,1,4);
        plot(t_d1, d1, 'g');
        title('Detail Coefficients (D1)');
    % === Classification Accuracy Calculation ===
    accuracy = evaluateClassification(pos_seq, zero_seq, fault_type);
end
