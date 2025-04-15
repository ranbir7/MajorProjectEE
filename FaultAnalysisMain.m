clc; clear; close all;

selected_fault = 'BATT'; % Changed to battery fault
Fs = 2000;
fault_positions = [0.4, 0.5, 0.6, 0.7];
fault_types = {'AG', 'BG', 'CG', 'AB', 'AC', 'BC', 'ABG', 'ACG', 'BCG', 'ABC', 'ABCG', 'BATT'}; % Added BATT

% Initialize results storage
results = struct();

latest_dwt_fig = [];
latest_stft_fig = [];

% Process All Faults 
for fault_idx = 1:length(fault_types)
    fault_type = fault_types{fault_idx};
    
    for pos_idx = 1:length(fault_positions)
        fault_pos = fault_positions(pos_idx);

        %  Generate Fault Signal 
        [Phase_A, Phase_B, Phase_C] = generateFaultSignal(fault_type, fault_pos, Fs);

        %  Clark's Transform 
        [~, ~, zero_seq, positive_seq] = clarkTransform(Phase_A, Phase_B, Phase_C);

        %  DWT Analysis 
        [dwt_time, dwt_acc, dwt_fig] = dwtAnalysis(positive_seq, zero_seq, Fs, fault_type);

        %  STFT Analysis 
        [stft_time, stft_acc, stft_fig] = stftAnalysis(positive_seq, Fs, fault_type);

        % === Store Results in Struct ===
        results(fault_idx, pos_idx).SamplingRate_Hz = Fs;
        results(fault_idx, pos_idx).FaultPosition_Percent = fault_pos * 100;
        results(fault_idx, pos_idx).FaultType = fault_type;
        results(fault_idx, pos_idx).DWT_Time_ms = dwt_time;
        results(fault_idx, pos_idx).STFT_Time_ms = stft_time;
        results(fault_idx, pos_idx).DWT_Accuracy = dwt_acc;
        results(fault_idx, pos_idx).STFT_Accuracy = stft_acc;

       
        if strcmp(fault_type, selected_fault)

            if ~isempty(latest_dwt_fig) && ishandle(latest_dwt_fig)
                close(latest_dwt_fig);
            end
            if ~isempty(latest_stft_fig) && ishandle(latest_stft_fig)
                close(latest_stft_fig);
            end
            
            latest_dwt_fig = dwt_fig;
            latest_stft_fig = stft_fig;
        else
            close(dwt_fig);
            close(stft_fig);
        end
    end
end

if ~isempty(latest_dwt_fig) && ishandle(latest_dwt_fig)
    figure(latest_dwt_fig);
end
if ~isempty(latest_stft_fig) && ishandle(latest_stft_fig)
    figure(latest_stft_fig);
end


Report(results)