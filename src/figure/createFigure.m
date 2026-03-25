function fig = createFigure(cfg)
    fig = gcf;          % 获取当前图窗
    ax = gca;           % 获取当前坐标轴
    
    switch cfg.type
        case 'single'
            target_width = 16;   % 放大为原来的约2倍
            target_height = 10;
        case 'double'
            target_width = 32;   % 放大为原来的约2倍
            target_height = 14;
        otherwise
            target_width = 20;
            target_height = 12;
    end
    
    % 统一单位
    set(fig, 'Units', 'centimeters');
    set(ax, 'Units', 'centimeters');
    
    % 调整坐标轴位置和大小
    set(ax,  ...
            'FontName', cfg.fontName, ...
            'FontSize', cfg.fontSize, ...
            'LineWidth', 3, ...
            'ColorOrder', cfg.colorOrder);
   
end