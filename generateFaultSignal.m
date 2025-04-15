function [Phase_A, Phase_B, Phase_C] = generateFaultSignal(fault_type, position, Fs)
    t = 0:1/Fs:1;
    fault_start = round(position * length(t));
    
    % Base signals
    Phase_A = sin(2*pi*50*t);
    Phase_B = sin(2*pi*50*t - 2*pi/3);
    Phase_C = sin(2*pi*50*t + 2*pi/3);
    
    noise_level = 3 * randn(size(t(fault_start:end)));
    
    switch fault_type
        case 'AG', Phase_A(fault_start:end) = Phase_A(fault_start:end) + noise_level;
        case 'BG', Phase_B(fault_start:end) = Phase_B(fault_start:end) + noise_level;
        case 'CG', Phase_C(fault_start:end) = Phase_C(fault_start:end) + noise_level;
        case 'AB'
            Phase_A(fault_start:end) = Phase_A(fault_start:end) + noise_level;
            Phase_B(fault_start:end) = Phase_B(fault_start:end) + noise_level;
        case 'AC'
            Phase_A(fault_start:end) = Phase_A(fault_start:end) + noise_level;
            Phase_C(fault_start:end) = Phase_C(fault_start:end) + noise_level;
        case 'BC'
            Phase_B(fault_start:end) = Phase_B(fault_start:end) + noise_level;
            Phase_C(fault_start:end) = Phase_C(fault_start:end) + noise_level;
        case 'ABG'
            Phase_A(fault_start:end) = Phase_A(fault_start:end) + noise_level;
            Phase_B(fault_start:end) = Phase_B(fault_start:end) + noise_level;
            Phase_C(fault_start:end) = Phase_C(fault_start:end) + 0.5*noise_level;
        case 'ACG'
            Phase_A(fault_start:end) = Phase_A(fault_start:end) + noise_level;
            Phase_C(fault_start:end) = Phase_C(fault_start:end) + noise_level;
            Phase_B(fault_start:end) = Phase_B(fault_start:end) + 0.5*noise_level;
        case 'BCG'
            Phase_B(fault_start:end) = Phase_B(fault_start:end) + noise_level;
            Phase_C(fault_start:end) = Phase_C(fault_start:end) + noise_level;
            Phase_A(fault_start:end) = Phase_A(fault_start:end) + 0.5*noise_level;
        case 'ABC'
            Phase_A(fault_start:end) = Phase_A(fault_start:end) + 5*noise_level;
            Phase_B(fault_start:end) = Phase_B(fault_start:end) + 5*noise_level;
            Phase_C(fault_start:end) = Phase_C(fault_start:end) + 5*noise_level;
        case 'ABCG'
            Phase_A(fault_start:end) = Phase_A(fault_start:end) + 3*noise_level;
            Phase_B(fault_start:end) = Phase_B(fault_start:end) + 3*noise_level;
            Phase_C(fault_start:end) = Phase_C(fault_start:end) + 3*noise_level;
        case 'BATT'
            voltage_drop = 0.3;
            transient_freq = 1000;
            duration = 0.2;
            end_sample = min(fault_start + round(duration*Fs), length(t));
            affected_samples = fault_start:end_sample;
            
            % Voltage sag
            Phase_A(affected_samples) = Phase_A(affected_samples) * (1 - voltage_drop);
            Phase_B(affected_samples) = Phase_B(affected_samples) * (1 - voltage_drop);
            Phase_C(affected_samples) = Phase_C(affected_samples) * (1 - voltage_drop);
            
            % High-frequency transient
            transient = 0.5*sin(2*pi*transient_freq*t(affected_samples));
            Phase_A(affected_samples) = Phase_A(affected_samples) + transient;
            Phase_B(affected_samples) = Phase_B(affected_samples) + transient;
            Phase_C(affected_samples) = Phase_C(affected_samples) + transient;
    end
end