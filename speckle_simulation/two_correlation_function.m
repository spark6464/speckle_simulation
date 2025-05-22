%% 轴向和纵向的强度自相关系数根据公式画图
lambda = 532e-9;     % 波长 (m)
z = 0.1;             % 传播距离 (m)
D = 1e-3;            % 孔径 (m)
I_bar = 1;           % 平均光强


dx = 1e-6;                   % Δx 范围设置 % 采样间隔
x = -200e-6:dx:200e-6;              % Δx 取值范围，单位 m
r = abs(x);                         % Δy = 0 时，r = |x|

% 计算 Bessel 参数
k = pi * D / (lambda * z);
kr = k * r;

% 避免除以0
kr(kr==0) = eps;

% 自相关函数表达式
Gamma_I = I_bar^2 * (1 + (2 * besselj(1, kr) ./ kr).^2);

% 绘图
figure;
plot(x * 1e6, Gamma_I, 'LineWidth', 3);
xlabel('r ','FontSize', 24);
ylabel('\Gamma_I(r)', 'FontSize', 24);
grid off;
set(gca, 'FontSize', 22);
% 参数设置
lambda = 532e-9;     % 波长 (m)
z = 0.1;             % 成像距离 (m)
D = 1e-3;            % 孔径/光斑直径 (m)
% Δz 范围（单位：米）
dz = 1e-6;
delta_z = -2e-1:dz:2e-1;    % -1mm 到 1mm
% 计算参数 A = D^2 / (8λz^2)
A = D^2 / (8 * lambda * z^2);
% 计算 |μ_A(Δz)|^2
mu_A_squared = sinc(A * delta_z).^2;

% 绘图
figure;
plot(delta_z * 1e3, mu_A_squared, 'LineWidth', 3);
xlabel('\Delta z ','FontSize', 24);
ylabel('|\mu_A(\Delta z)|^2','FontSize', 24);
grid off;
set(gca, 'FontSize', 22);

