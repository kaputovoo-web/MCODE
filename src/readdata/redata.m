function data_struct = redata(data_matrix, config)

    if isempty(data_matrix)
        error('ERROR: empty inputs!');
    end

    %% 字段映射
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

    %% ===== 直接向量化赋值 =====
    for j = 1:size(fields_map, 1)
        field_name = fields_map{j, 1};
        col_idx    = fields_map{j, 2};

        data_struct.(field_name) = double(data_matrix(:, col_idx));
    end

    %% ===== 计算 ddop =====
    data_struct.ddop = data_struct.op1 - data_struct.op2;

    %% ===== 生成时间轴（=====
    data_struct.time = generateTimeAxis(length(data_struct.time), config);

end


function time = generateTimeAxis(N, config)
    fs = config.fs;
    time = (0:N-1)' / fs;
end
