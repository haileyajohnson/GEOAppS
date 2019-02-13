% initialize
slope = 0.01;
step = 0.05;
x = (0:step:15);
y = (0:step:10);
h = zeros(length(y), length(x));
wave_angle_deep = -20;

shoreline = -15.*sin(linspace(pi/2, 3*pi/2, length(x))) + 20;

% build bathy grid
for r = 1:length(y)
    for col = 1:length(x)
        if r <= shoreline(col)
            h(r, col) = nan; % land
        else
            h(r, col) = -1000 * (step * slope) * (r - shoreline(col)); % depth (m)
        end
    end
end

% plot bathy
hfig = figure();
set(hfig, 'position', [200, 200, 800, 500]);       

contourf(x, y, h, 20);
hold('on');
plot(x, shoreline.*step, 'k-', 'linewidth', 2);

% initialize wave vector
crest_length = length(x)*step;
crest_pos = linspace(0, crest_length, 20); 
xdists = crest_pos.*cosd(wave_angle_deep);
ydists = crest_pos.*sind(wave_angle_deep);
y_pos = y(end)+ydists;
x_pos = x(end)-(xdists(end)-xdists);

% move wave crest to fit
min_y = min(y_pos);
if min_y < 6.5
    y_pos = y_pos + (6.5 - min_y);
    out_of_bounds = find (y_pos > y(end));        
    x_pos(out_of_bounds) = [];
    y_pos(out_of_bounds) = [];
end

% plot wave crest
plot(x_pos, y_pos, 'd-k', 'markerfacecolor', 'k', 'markersize', 6, 'linewidth', 2);    

cb = colorbar('fontsize', 12);
ylabel(cb, 'depth (m)', 'fontsize', 14);
set(gca, 'color', 'yellow', 'fontsize', 14);
colormap('winter');
ylim([0 y(end)]);
xlim([0, x(end)]);
ylabel('cross-shore pos. (km)');   
xlabel('long-shore pos. (km)');
axis equal