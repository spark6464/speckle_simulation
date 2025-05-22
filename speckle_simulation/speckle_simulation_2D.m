%% 模拟生成散斑二维图像

%% 参数定义
N = 2048;  % 二维数组大小
W = 20;   % 圆形平滑滤波器直径
S = 2;    % 相位乘法因子
D =128;  % 光阑直径



%%创建卷积核（低通滤波器）
kernel = zeros(N, N);  % 初始化滤波器矩阵
[x, y] = meshgrid(1:N, 1:N);  % 生成网格坐标
radius = sqrt((x - N/2).^2 + (y - N/2).^2);  % 计算到中心的距离
kernel(radius < W/2) = 1 / sqrt(pi * (W/2)^2);  % 归一化滤波器

%低通滤波：在频域中乘以 fft2(uncorrelated_phase)，相当于对相位场做平滑处理，使其具有一定的空间相关性。
%模拟散射介质：散射介质往往具有一定的表面粗糙度，该操作使相位场的分布更符合实际物理情况。
%增大 W：滤波器半径增大，相位场的相关性增强，导致散斑变得更大、更平滑。
%减小 W：滤波器半径减小，相位场更加随机，散斑会变得更细腻。


%%生成无关相位数组（随机相位场）
uncorrelated_phase = S * pi * randn(N, N);  % 服从正态分布的随机相位

%%进行傅里叶变换卷积，得到相关相位场
correlated_phase = ifft2(fft2(uncorrelated_phase) .* fft2(kernel));

%%计算扩散器传输的场（复指数形式）
diffuser = exp(1i * correlated_phase);

%%创建圆形光阑（限制光束传播）
stop = zeros(N, N);  % 初始化光阑矩阵
stop(radius < D/2) = 1;  % 设置圆形光阑

%%计算入射光场（散射光的傅里叶变换）
incident_field = fftshift(fft2(diffuser));  % 计算傅里叶变换并居中
transmitted_field = incident_field .* stop;  % 通过光阑的光场

%%计算图像平面上的光强分布
image_field =1/N*ifft2(transmitted_field);  % 反变换回到空间域
image_intensity =abs(image_field).^2;  % 计算强度（幅度平方）

image_intensity =image_intensity/max(image_intensity(:));
%%绘制散斑图像
figure;
set(gcf, 'Position', [100, 100, 550, 550]);
imagesc( image_intensity);
colormap([zeros(256, 1), linspace(0, 1, 256)', zeros(256, 1)]);
caxis([0, 0.5]);
axis off;
colorbar  ;
c = colorbar; % 获取 colorbar 句柄
c.FontSize = 20; % 调整字体大小
%title('speckle image,光阑直径D=128', 'Interpreter', 'latex', 'FontSize', 26);

% ========================
% 添加 400 px 的标尺
scale_px = 400;                          % 标尺长度：400像素
x0 = 200;                                % 起点横坐标
y0 = size(image_intensity,1) - 200;    % 起点纵坐标（靠近下边）

% 绘制白色线段
line([x0, x0 + scale_px], [y0, y0], 'Color', 'w', 'LineWidth', 4);

% 添加注释文字
text(x0 + scale_px/2, y0 - 120, '400 pixels', ...
    'Color', 'w', 'FontSize', 30, 'HorizontalAlignment', 'center');


