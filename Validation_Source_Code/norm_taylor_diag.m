function stat = norm_taylor_diag(ts, varargin)

    % old
    % ---
    % mat: matrix containing time series (TS)
    % ref: vector containing the ID of the reference TS
    %      mat(:, ref(i)) is the reference TS of mat(:, i)
    %      ref(i) = i for reference TS
    % problem: all reference TS must be the same size, while sometimes
    %          measuremnts do not have the same time step
    %
    % new
    % ---
    % ts{k}: matrix containing the reference TS (1st column) and the TS to
    %        compare with (other columns)
    %
    % varargin: properties for figures

    
    % ------------- %
    % create figure %
    % ------------- %
    
%     figure
    hold on
    axis equal
    ax = gca;
    ax.LineWidth = 1;
    ax.FontSize = 14;
    
    
    % ------------------ %
    % compute statistics %
    % ------------------ %

    % stat{k} is a matrix gathering all the statistics about time series
    % row #1: mean
    % row #2: bias
    % row #3: root mean square error
    % row #4: centered root mean square error
    % row #5: standard deviation
    % row #6: correlation coefficien
    
    
    % for each reference time series
    for k = 1:length(ts)
        
        % number of time series
        nts{k} = size(ts{k}, 2);
        
        if nts{k} > 8
            error(['defalut marker_face_color limited to 8 time ' ...
                   'series, including the reference time series']);
        end
        
        % initialize stat{k} matrix
        stat{k} = zeros(6, nts{k});
        
        % indices of "not NaN" data in each time series
        ind = find(~isnan(ts{k}(:, 1)));
        
        % for each time series
        for j = 1:nts{k}

            % time series
            X = ts{k}(ind, j);
            
            % reference time series
            Xref = ts{k}(ind, 1);

            % number of data
            N = size(X, 1);

            % mean
            S = mean(X);
            
            % reference mean
            Sref = mean(Xref);

            % bias
            bias = S - Sref;

            % root mean square error
            RMSE = sqrt(sum((X - Xref) .^ 2) / N);

            % centered root mean square error
            CRMSE = sqrt(sum(((X - S) - (Xref - Sref)) .^ 2) / N);

            % standard deviation
            sigma = sqrt(sum((X - S) .^ 2) / N);

            % standard deviation of the reference
            sigmaref = sqrt(sum((Xref - Sref) .^ 2) / N);

            % correlation coefficient
            R = sum((X - S) .* (Xref - Sref)) / (N * sigma * sigmaref);

            % statistic matric
            stat{k}(1, j) = S;
            stat{k}(2, j) = bias;
            stat{k}(3, j) = RMSE;
            stat{k}(4, j) = CRMSE;
            stat{k}(5, j) = sigma;
            stat{k}(6, j) = R;

        end
                
    end
    
%     stat
    % ------------------ %
    % standard deviation %
    % ------------------ %
    
    % maximum standard deviation to plot
    sigmamax = 0;
    for k = 1:length(ts)
        sigma = stat{k}(5, :) ./ stat{k}(5, 1); % normalized std
        if max(sigma) > sigmamax
            sigmamax = max(sigma);
        end
    end    
    
    % standard deviation limit on diagram
    sigmalim = max(1.25, ceil(sigmamax * 4) / 4);
    ax.XLim = ([0 sigmalim]);
    ax.YLim = ([0 sigmalim]);
    
    % draw circles
    for i = 0.25:0.25:sigmalim
        theta = 0:90;
        x = i * cosd(theta);
        y = i * sind(theta);
        if i == 1
            h = plot(x, y);
            h.Color = 'k';
            h.LineWidth = 2;
            h.LineStyle = '-';
        elseif i == sigmalim
            h = plot(x, y);
            h.Color = ax.ColorOrder(3, :);
            h.LineWidth = 1;
            h.LineStyle = '-';
        else
            h = plot(x, y);
            h.Color = 'k';
            h.LineWidth = 1;
            h.LineStyle = '--';
        end
    end
    
    % axis
    ax.YTick = [0.25:0.25:sigmalim - 0.25];
    ax.YLabel.String = 'standard deviation';
    
    
    % ------------------------------- %
    % centered root mean square error %
    % ------------------------------- %
    
    % draw circles
    for i = 0.25:0.25:1
        
        % full circles
        theta = 0:180;
        x = i * cosd(theta) + 1;
        y = i * sind(theta);
        
        % remove what is outside the diagram
        ind = find(x <= (1 + sigmalim ^ 2 - i ^ 2) * 0.5);
        x = x(ind);
        y = y(ind);
        
        % plot
        h = plot(x, y);
        h.Color = ax.ColorOrder(1, :);
        h.LineWidth = 1;
        h.LineStyle = '--';
    end
    
    % axis
    ax.XTick = [0:0.25:0.75];
    ax.XTickLabel = [1:-0.25:0.25];
    ax.XLabel.String = 'centered root mean square error';
    ax.XColor = ax.ColorOrder(1, :);
    
    
    % ----------------------- %
    % correlation coefficient %
    % ----------------------- %
    
    % tick values
    tick = [0.1:0.1:0.9 0.95 0.99];
    
    for i = 1:length(tick)
        
        % draw lines
        x = [0 sigmalim * tick(i)];
        y = [0 sigmalim * sin(acos(tick(i)))];
        h = plot(x, y);
        h.Color = ax.ColorOrder(3, :);
        h.LineWidth = 1;
        h.LineStyle = ':';
        
        % write ticks
        h = text(x(2), y(2), num2str(tick(i)));
        h.Color = ax.ColorOrder(3, :);
        h.FontSize = 14;
        h.VerticalAlignment = 'bottom';
        h.HorizontalAlignment = 'center';
        h.Rotation = acos(tick(i)) * 180 / pi - 90;
    end
    
    % title
    h = text((sigmalim + 0.08) * cosd(45), (sigmalim + 0.08) * sind(45), ...
             'correlation coefficient');
    h.Color = ax.ColorOrder(3, :);
    h.FontSize = 14;
    h.VerticalAlignment = 'bottom';
    h.HorizontalAlignment = 'center';
    h.Rotation = -45;
    
    
    % ------------- %
    % read varargin %
    % ------------- %
    
    % default values
    marker = 'osd^v><ph+*x.';
    marker_edge_color = ax.ColorOrder;
    marker_face_color = ax.ColorOrder;
   
    % implement something for when using non default values
    
    
    % --------- %
    % plot data %
    % --------- %
    
    % reference point
    h = plot(1, 0);
    h.Marker = 'o';
    h.MarkerEdgeColor = 'k';
    h.MarkerFaceColor = 'k';
    h.MarkerSize = 8;
    h.LineStyle = 'none';
    
    % other points
    for k = 1:length(ts)
        r = stat{k}(5, :) ./ stat{k}(5, 1);
        theta = acos(min(1, stat{k}(6, :)));
        x = r .* cos(theta);
        y = r .* sin(theta);

        for j = 2:nts{k}
            h = plot(x(j), y(j));
            h.Marker = marker(k);
            h.MarkerEdgeColor = marker_edge_color(j - 1, :);
            h.MarkerFaceColor = marker_face_color(j - 1, :);
        end 
    end
    