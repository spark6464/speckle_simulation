%% 传播函数 - 菲涅耳衍射
function H_fresnel = fresnel_transfer_function(U_in,N, pixel_size, lambda, dz)
%该函数计算菲涅耳衍射
%  需要输出的参数有：二维数组大小，pixel尺寸，波长，步长dz
    [fx, fy] = meshgrid((-N/2:N/2-1) / (N * pixel_size));
    H_fresnel = exp(-1i * pi * lambda * dz * (fx.^2 + fy.^2));%传递函数
    U_out = ifft2(fft2(U_in) .* H_fresnel);%出射光场
end

%% 传播函数 - 角谱法
function H_angular = angular_spectrum_transfer_function(U_in,N, pixel_size, lambda, dz)
%该函数角谱法计算衍射
%  需要输出的参数有：二维数组大小，pixel尺寸，波长，步长dz   
    [fx, fy] = meshgrid((-N/2:N/2-1) / (N * pixel_size));
    k = 2 * pi / lambda;
    H_angular = exp(1i * dz * sqrt(k^2 - (2 * pi * fx).^2 - (2 * pi * fy).^2));%传递函数
    U_out = ifft2(fft2(U_in) .* H_angular);%出射光场
end


