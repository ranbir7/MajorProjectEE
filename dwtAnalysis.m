function [detect_time, accuracy, fig] = dwtAnalysis(pos_seq, zero_seq, Fs, fault_type)
    wavelet_name = 'db2';
    level = 3;
    
    [c, l] = wavedec(pos_seq, level, wavelet_name);
    d3 = detcoef(c, l, level);
    d1 = detcoef(c, l, 1); % Added D1 for battery faults
    a3 = appcoef(c, l, wavelet_name);

    fault_class = classifyFault(fault_type);

    % Adaptive thresholding
    if strcmp(fault_class, 'Battery')
        threshold = 0.7 * max(abs(d1));
        detected_samples = find(abs(d1) > threshold);
    else
        threshold = 0.4 * max(abs(d3));
        detected_samples = find(abs(d3) > threshold);
    end

    % Detection logic
    cons_detections = find(diff(detected_samples) == 1, 1);
    detect_time = Inf;
    
    if ~isempty(cons_detections)
        fault_sample = detected_samples(cons_detections);
        if strcmp(fault_class, 'Battery')
            detect_time = (fault_sample * 1000)/Fs; % D1 uses original sampling
        else
            detect_time = (fault_sample * (2^level) * 1000)/Fs;
        end
    end

    % Visualization
    fig = figure('Name', ['DWT Analysis - ', fault_type, ' (', fault_class, ')'], ...
                 'NumberTitle', 'off', 'Color', 'w');
    
    subplot(4,1,1);
    plot((0:length(pos_seq)-1)/Fs, pos_seq);
    title('Original Signal');
    
    subplot(4,1,2);
    plot((0:length(a3)-1)*(2^level)/Fs, a3);
    title('Approximation Coefficients (A3)');
    
    subplot(4,1,3);
    plot((0:length(d3)-1)*(2^level)/Fs, d3);
    hold on; yline(threshold, '--r'); title('Detail Coefficients (D3)');
    
    % Battery-specific plot
    if strcmp(fault_class, 'Battery')
        subplot(4,1,4);
        plot((0:length(d1)-1)/Fs, d1);
        hold on; yline(threshold, '--r'); 
        title('Detail Coefficients (D1)');
    end
    
    accuracy = evaluateClassification(pos_seq, zero_seq, fault_type);
end