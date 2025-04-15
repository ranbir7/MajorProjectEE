function fault_class = classifyFault(fault_type)
    switch fault_type
        case {'AG', 'BG', 'CG'}
            fault_class = 'SLG'; % Single-Line-to-Ground Fault
        case {'AB', 'AC', 'BC'}
            fault_class = 'LL'; % Line-to-Line Fault
        case {'ABG', 'ACG', 'BCG'}
            fault_class = 'DLG'; % Double-Line-to-Ground Fault
        case 'ABC'
            fault_class = 'LLL'; % Three-Phase Fault
        case 'ABCG'
            fault_class = 'LLLG'; % Three-Phase-to-Ground Fault
        otherwise
            fault_class = 'Unknown'; % Fallback case
    end
end
