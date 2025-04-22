function accuracy = evaluateClassification(pos_seq, zero_seq, fault_type)
    % Ground fault detection
    ground_threshold = 0.1 * max(pos_seq);
    is_ground_fault = any(zero_seq > ground_threshold);
    
    % Battery fault detection
    [c, l] = wavedec(pos_seq, 3, 'db2');
    d1 = detcoef(c, l, 1);
    battery_threshold = 0.7 * max(abs(d1));
    is_battery_fault = any(abs(d1) > battery_threshold);
    
    % Classification logic
    true_ground = contains(fault_type, 'G');
    true_battery = strcmp(fault_type, 'BATT');
    
    if true_battery
        accuracy = 100 * is_battery_fault;
    elseif true_ground
        accuracy = 95 * is_ground_fault;
    else
        accuracy = 100 * ~is_ground_fault;
    end
end