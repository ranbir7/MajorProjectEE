function Report(results)
    % Initialize table
    fprintf('\n===== Fault Detection Performance Table =====\n');
    fprintf('SamplingRate_Hz | FaultPosition_%% | FaultType | DWT_Time_ms | STFT_Time_ms | DWT_Accuracy_%% | STFT_Accuracy_%%\n');
    fprintf('-------------------------------------------------------------------------------------------------------------\n');
    
    for fault_idx = 1:size(results, 1)
        for pos_idx = 1:size(results, 2)
            res = results(fault_idx, pos_idx);
            if isnumeric(res.DWT_Time_ms) && ~isnan(res.DWT_Time_ms) && ~isinf(res.DWT_Time_ms)
                dwt_time = res.DWT_Time_ms;
            else
                dwt_time = -1; % Assign a placeholder for undetected faults
            end
            
            if isnumeric(res.STFT_Time_ms) && ~isnan(res.STFT_Time_ms) && ~isinf(res.STFT_Time_ms)
                stft_time = res.STFT_Time_ms;
            else
                stft_time = -1; % Assign a placeholder for undetected faults
            end
            
            fprintf('%15d | %15.1f | %8s | %11.2f | %12.2f | %15.2f | %15.2f\n', ...
                res.SamplingRate_Hz, res.FaultPosition_Percent, res.FaultType, ...
                dwt_time, stft_time, res.DWT_Accuracy, res.STFT_Accuracy);
        end
    end
end
