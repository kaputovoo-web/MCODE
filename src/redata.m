function [data_struct] = redata(data_matrix,config)

    data_struct = struct();
    if isempty(data_matrix)
        disp('ERROR:empty inputs!');
        return;
    end
    
    row_num = size(data_matrix, 1);
    
    fields_map = {
        'time', 1;          
        'lon', 2;      
        'lat', 3;       
        'alt', 4;       
        'pacc', 5; 
        'Lidar_d', 6;
        'op1', 7; 
        'op2', 8; 
        'fx', 9;     
        'fy', 10;    
        'fz', 11;    
        'roll', 12;          
        'pitch', 13;         
        'yaw', 14;          
        'Satellite', 15;      
        'Barometer', 16;     
        'east', 17;          
        'north', 18;         
        'zone', 19;           
    };
    
    % 逐行构建结构体（保留你的核心逻辑）
    for i = 1:row_num
        row_struct = struct();
        for j = 1:size(fields_map, 1)
            field_name = fields_map{j, 1};
            col_idx = fields_map{j, 2};
            row_struct.(field_name) = double(data_matrix(i, col_idx));
        end
        if i == 1
             data_struct = repmat(row_struct, row_num, 1);
        end
        data_struct(i) = row_struct;
    end
    time_axis = generateTimeAxis(data_struct, config);
    for i = 1:row_num
        data_struct(i).time = time_axis(i);
    end
end

function time = generateTimeAxis(data, config)
    N = length(data);
    fs = config.fs;
    time = (0:N-1)' / fs; 
end