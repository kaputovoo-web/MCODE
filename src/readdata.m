function [data, file_path] = readdata(file_path_input)
    data = [];
    file_path = '';

    try
        if nargin == 0 || isempty(file_path_input)
            [file_name, folder_path] = uigetfile({
                '*.txt', '文本文件 (*.txt)';
                '*.mat', 'MAT文件 (*.mat)';
                '*.*', '所有文件 (*.*)'
            }, 'data file');
           
            if file_name == 0
                disp('用户取消了文件选择');
                return;
            end
            file_path = fullfile(folder_path, file_name);
        else
            file_path = file_path_input;
            if ~exist(file_path, 'file')
                error('指定的文件不存在：%s', file_path);
            end
        end

        try
            %dlmread读取（逗号分隔、跳过第一行、不跳列）
            data = dlmread(file_path, ',', 1, 0);
            disp(['loaddata：', file_path]);
        catch
            disp('Warnning:Non numerical data exists');
            fid = fopen(file_path, 'r');
            temp_file = [tempdir, 'temp_cleaned.txt']; % 创建临时清理文件
            tfid = fopen(temp_file, 'w');
            
            line_num = 0;
            while ~feof(fid)
                line = fgetl(fid);
                line_num = line_num + 1;
                if line_num == 1 
                    fprintf(tfid, '%s\n', line);
                    continue;
                end
                clean_line = regexprep(line, '[^0-9\,\.\-\+eE]', '');
                fprintf(tfid, '%s\n', clean_line);
            end
            fclose(fid);
            fclose(tfid);
            
            data = dlmread(temp_file, ',', 1, 0);
            delete(temp_file); % 删除临时文件
            disp(['loaddata：', file_path]);
        end

    catch ME
        disp(['loaddata error：', ME.message]);
        data = [];
        file_path = '';
    end
end