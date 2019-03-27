close all; clear all;

h_dune = 3;
h_c = 10;

x = (-100:10:400);
A = 0.2;

z = -A.*(sign(x)).*(abs(x).^(2/3));
z(z<-h_c) = -h_c;


hfig = figure();
plot(x, z, 'color', [0.4 0.2 0.2], 'linewidth', 2);
hold on
box on
grid on
plot([0 x(end)], [0 0], 'b-', 'linewidth', 2);
patch([x, x(end), x(1)], [z, -h_c-1, -h_c-1], [0.4 0.2 0.2], 'facealpha', 0.2);
patch([0, x(end), fliplr(x(11:end))], [0, 0 fliplr(z(11:end))], [0 0.5 1], 'facealpha', 0.3);

plot([350 350], [-h_c 0], 'k--', 'linewidth', 1.5);
text(370, -4, '$h_c = 10$m', 'rotation', -90, 'fontsize', 16, 'interpreter', 'latex');

plot([0, 352], [0.3 0.3], 'k-', 'linewidth', 1.5)
plot([0, 0], [0 0.6], 'k-', 'linewidth', 1.5)
plot([352, 352], [0 0.6], 'k-', 'linewidth', 1.5)
text(150, 0.7, '$L = 350$m', 'fontsize', 16, 'interpreter', 'latex');

ylabel('elevation (m)')
xlabel('cross-shore dist. (m)');
xlim([x(1), x(end)]);
ylim([-11, 3]);
set(gca, 'fontsize', 16, 'linewidth', 2);