function fault_class = classifyFault(fault_type)
    switch fault_type
        case {'AG', 'BG', 'CG'}
            fault_class = 'SLG';
        case {'AB', 'AC', 'BC'}
            fault_class = 'LL';
        case {'ABG', 'ACG', 'BCG'}
            fault_class = 'DLG';
        case 'ABC'
            fault_class = 'LLL';
        case 'ABCG'
            fault_class = 'LLLG';
        case 'BATT'
            fault_class = 'Battery';
        otherwise
            fault_class = 'Unknown';
    end
end
