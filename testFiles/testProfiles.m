close all; clear all;

h_dune = 3;
h_c = 12;

x = (-100:10:400);
A = 0.238;

z = -A.*(sign(x)).*(abs(x).^(2/3));
z(z<-h_c) = -h_c;
z2 = -A.*(sign(x+30)).*(abs(x+30).^(2/3));
z2 = z2+1;
i = find(z2>z & x <0);
z2(i) = z(i);
z2(z2<-h_c+1) = nan;


hfig = figure();
plot(x, z, 'color', [0.4 0.2 0.2], 'linewidth', 2);
hold on
box on
grid on
plot(x, z2, 'k--', 'linewidth', 2);

plot([0 x(end)], [0 0], 'b-', 'linewidth', 2);
plot([0 x(end)], [1 1], 'b--', 'linewidth', 1.5);
text(1, 1.5, '$S=1$m','fontsize', 16, 'interpreter', 'latex');
plot([330 360], [-9, -9], 'k-', 'linewidth', 1.5);
text(332, -9.5, '$R$','fontsize', 16, 'interpreter', 'latex');

patch([x, x(end), x(1)], [z, -h_c-1, -h_c-1], [0.4 0.2 0.2], 'facealpha', 0.2);
patch([0, x(end), fliplr(x(11:end))], [0, 0 fliplr(z(11:end))], [0 0.5 1], 'facealpha', 0.3);

plot([360 360], [-h_c 0], 'k--', 'linewidth', 1.5);
plot([330 330], [-h_c+1 0], 'k--', 'linewidth', 1.5);
text(375, -4, '$h_c = 12$m', 'rotation', -90, 'fontsize', 16, 'interpreter', 'latex');
text(345, -3, '$h_c = 11$m', 'rotation', -90, 'fontsize', 16, 'interpreter', 'latex');

plot([0, 360], [0.3 0.3], 'k-', 'linewidth', 1.5)
plot([0, 0], [0 0.6], 'k-', 'linewidth', 1.5)
plot([360, 360], [0 0.6], 'k-', 'linewidth', 1.5)
text(150, 0.7, '$L = 360$m', 'fontsize', 16, 'interpreter', 'latex');

ylabel('elevation (m)')
xlabel('cross-shore dist. (m)');
xlim([x(1), x(end)]);
ylim([-h_c-1, 3]);
yticks((-12:2:2));
set(gca, 'fontsize', 16, 'linewidth', 2);