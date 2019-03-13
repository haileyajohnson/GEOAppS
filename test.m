% initialize
slope = 0.01;
x = (0:1:100);
y = (0:1:50);
h = zeros(length(y), length(x));
wave_angle_deep = [0, 15, 45, 60];

phases = linspace(pi/2, 3*pi/2, length(x));
shoreline = -5.*sin(phases) + 7;
angles = rad2deg(atan(-cos(phases)));

% build bathy grid
for r = 1:length(y)
    for col = 1:length(x)
        if r <= shoreline(col)
            h(r, col) = nan; % land
        else
            h(r, col) = - slope * (r - shoreline(col)); % depth (m)
        end
    end
end

hfig = figure();
set(hfig, 'position', [200, 200, 800, 500]);      
for i = (1:4)
    subplot(2, 2, i);
    % plot bathy 

    contourf(x, y, h, 20);
    hold('on');
    plot(x, shoreline, 'k-', 'linewidth', 2);

    % initialize wave vector
    break_depth = 30;
    alpha = deg2rad(wave_angle_deep(i));
    if sin(alpha) > 0 % anchor to left side
        left_y = break_depth - ((break_depth-shoreline(1))*sin(alpha));
        right_y = left_y + (tan(alpha)*x(end));
    else % anchor to right side
        right_y = break_depth + ((break_depth-shoreline(end))*sin(alpha));
        left_y = right_y - (tan(alpha)*x(end));
    end

    % plot wave crest
    plot([0, x(end)], [left_y, right_y], '--r', 'linewidth', 2.5);

    colormap('winter');
    ticks = [1, 10, 20, 50, 80, 90,100];
    xticks(x(ticks));
    xticklabels([0,15, 30, 45, 30, 15, 0]);
    ylabel('cross-shore pos. (m)');   
    xlabel('local shoreline angle (deg)');
    title(['Wave angle = ', num2str(abs(wave_angle_deep(i))), ' (deg)'])
    set(gca, 'color', 'yellow', 'fontsize', 14);
    ylim([0, y(end)]);
    xlim([0, x(end)]); 
end