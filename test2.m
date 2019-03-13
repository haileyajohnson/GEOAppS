close all; clear all;
%% initialize
angles = [(0:1:90), (89:-1:-89), (-90:1:-1)];
angles = repmat(angles, 1, 2);
i = (1:1:length(angles));

% initialize global values
x = (0:5:800);
y = (0:2:400);
h = zeros(length(y), length(x));
sed_flux = nan(1, length(angles));
energy = sed_flux;
spread = sed_flux;

%% build bathy

hfig = figure();
set(hfig, 'position', [200, 50, 800, 900]);      
% set up shoreline axes
subplot(4, 1, [1, 2])
shoreline = 20;
slope = 0.01;
            
% build bathy grid
for r = 1:length(y)
    for col = 1:length(x)
        if r <= shoreline/2
            h(r, col) = nan; % land
        else
            h(r, col) = -(2 * slope) * (r - shoreline/2); % depth (m)
        end
    end
end
% plot
contourf(x, y, h, 20);hold on
shore = (shoreline) * ones(size(x));
plot(x, shore, 'k-', 'linewidth', 2);

%% add wave
wave_angle = 45;
wave_height = 2.5;

% initialize wave vector
break_depth = wave_height/slope + shoreline;
alpha = deg2rad(wave_angle);

left_y = break_depth - ((break_depth-shoreline)*sin(alpha));
right_y = left_y + (tan(alpha)*x(end));

% plot wave crest
plot([0, x(end)], [left_y, right_y], '-r', 'linewidth', 2);

% plot wave rays
w = 15;
center_x = (break_depth-left_y)/tan(alpha);
break_x = [center_x-(w*cos(alpha)), center_x+(w*cos(alpha))];
break_y = [break_depth-(w*sin(alpha)), break_depth+(w*sin(alpha))];


shore_x = break_x + ((break_y-shoreline)*tan(alpha));
plot([break_x(1), shore_x(1)], [break_y(1), shoreline],'r-.', 'linewidth', 2);
plot([break_x(2), shore_x(2)], [break_y(2), shoreline],'r-.', 'linewidth', 2);

% plot longshore energy component
E = ((1/8)*(1027)*(9.82)*(wave_height^2));
E_longshore = E*sin(alpha);
E_cross = E*cos(alpha);
plot([break_x(2), break_x(2) + E_longshore/25], [break_y(2), break_y(2)],...
    'w->', 'linewidth', 1.5, 'markersize', 5, 'markerfacecolor', 'w');
plot([break_x(2), break_x(2)], [break_y(2), break_y(2)-E_cross/25], ...
    'w-v', 'linewidth', 1.5, 'markersize', 5, 'markerfacecolor', 'w');
text(break_x(1) + E_longshore/25 - 50, break_y(1), ....
    '$\vec{E}_y = Esin(\alpha)\vec{n}_y$', 'interpreter', 'latex', 'fontsize', 16, 'color', 'w');
text(break_x(1)-10, break_y(1) - E_cross/25, ....
    '$\vec{E}_x = Ecos(\alpha)\vec{n}_x$', 'interpreter', 'latex', 'fontsize', 16, 'color', 'w', 'Rotation', 90);

% plot width
plot([break_x(1), break_x(2)], [break_y(1), break_y(2)], ...
    'b-+', 'linewidth', 1.5, 'markersize', 12, 'markerfacecolor', 'b');
text((break_x(1)-25), break_y(1)+15, '$W_{break}$', 'interpreter', 'latex', ...
    'fontsize', 16, 'color', 'w', 'rotation', wave_angle);

plot([shore_x(1), shore_x(2)], [shoreline, shoreline], ...
'b-+', 'linewidth', 1.5, 'markersize', 12, 'markerfacecolor', 'b');
text(shore_x(1)+1, 3, '$W_{shore}$', 'interpreter', 'latex', ...
    'fontsize', 16, 'color', 'b');

%% fix plot
set(gca, 'fontsize', 14, 'XAxisLocation', 'top', 'color', 'yellow');
colormap('winter');
ylabel('cross-shore pos. (m)');   
xlabel('long-shore pos. (m)');
axis('equal'); box on; grid on;
ylim([0 y(end)]);
xlim([0, x(end)]);

%% get values
wave_height = 0;
for j = (1:length(angles))
    alpha = deg2rad(angles(j));
    if alpha == 0
        wave_height = wave_height + 1;
        break_depth = wave_height/slope + shoreline;
    end
    % energy density
    energy(j) = abs(((1/8)*(1027)*(9.82)*(wave_height^2))*sin(alpha));
    % spread
    if sin(alpha) > 0 % anchor to left side
        left_y = break_depth - ((break_depth-shoreline)*sin(alpha));
        right_y = left_y + (tan(alpha)*x(end));
    else % anchor to right side
        right_y = break_depth + ((break_depth-shoreline)*sin(alpha));
        left_y = right_y - (tan(alpha)*x(end));
    end
    if alpha == 0
        break_x = [x(end)/2-w, x(end)/2+w];
        break_y = [break_depth, break_depth];
    else
        center_x = (break_depth-left_y)/tan(alpha);
        break_x = [center_x-(w*cos(alpha)), center_x+(w*cos(alpha))];
        break_y = [break_depth-(w*sin(alpha)), break_depth+(w*sin(alpha))];
    end

    shore_x = break_x + ((break_y-shoreline)*tan(alpha));
    
    spread(j) = (sqrt((break_x(2)-break_x(1))^2 + (break_y(2) - break_y(1))^2))/(shore_x(2) - shore_x(1));
    % sed flux
    sed_flux(j) = abs(0.4*(wave_height^(5/2))*cos(alpha)*sin(alpha));
end

%% create energy and spread plots
subplot(4, 1, 3);
yyaxis('left')
plot(i, energy, 'b*');
xticks([i(1:45:720), i(720)]);
xticklabels([angles(1:45:720), 0]);
xlim([1, length(angles)]);
ytickangle(90);
ylabel('|E_{y}| (J/m^2)');
ylim([0, 20000]);

yyaxis('right');
plot(i, spread, 'r*'); hold on;
text(i(45), 0.7, '$H_b=1m$', 'interpreter', 'latex', 'fontsize', 16);
text(i(225), 0.7, '$H_b=2m$', 'interpreter', 'latex', 'fontsize', 16);
text(i(405), 0.7, '$H_b=3m$', 'interpreter', 'latex', 'fontsize', 16);
text(i(585), 0.7, '$H_b=4m$', 'interpreter', 'latex', 'fontsize', 16);
plot([i(181), i(181)], [0, 1], 'k--', 'linewidth', 2);
plot([i(361), i(361)], [0, 1], 'k--', 'linewidth', 2);
plot([i(541), i(541)], [0, 1], 'k--', 'linewidth', 2);
ytickangle(90);
ylabel('w_{break}/w_{shore}');
ylim([0 1]);
set(gca, 'fontsize', 14);
box on; grid on;

%% creat sed flux plots
subplot(4, 1, 4)
plot(i, sed_flux, 'k*'); hold on;
text(i(45), 7, '$H_b=1m$', 'interpreter', 'latex', 'fontsize', 16);
text(i(225), 7, '$H_b=2m$', 'interpreter', 'latex', 'fontsize', 16);
text(i(405), 7, '$H_b=3m$', 'interpreter', 'latex', 'fontsize', 16);
text(i(585), 7, '$H_b=4m$', 'interpreter', 'latex', 'fontsize', 16);
plot([i(181), i(181)], [0, 8], 'k--', 'linewidth', 2);
plot([i(361), i(361)], [0, 8], 'k--', 'linewidth', 2);
plot([i(541), i(541)], [0, 8], 'k--', 'linewidth', 2);
box on; grid on;
xlim([1, length(angles)]);
xticks([i(1:45:720), i(720)]);
xticklabels([angles(1:45:720), 0]);
xlabel('breaking wave angle (deg)');
ylabel('sed. flux (m^3/s)');
ytickangle(90);
ylim([0, 8]);
set(gca, 'fontsize', 14);
