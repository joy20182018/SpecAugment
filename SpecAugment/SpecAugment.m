clc
clear
filepath = 'D:\matlabproject\hmm\TRAIN1\0a.wav'; % 可以按自己的路径设置
[X, fs] = audioread(filepath);
x_mel_graph = mfcc_m(X,fs, 24, 160, 80);  % 求mel系数
[R, C] = size(x_mel_graph); % 获取图像大小
subplot(511);
image(x_mel_graph);
title('initial mel image');

% Time Warping
% 图像向右移位,其余部分由随机噪声填充
% R:时间轴 C:频率轴
X_Time_Warping = zeros(R, C); % 创建一个与原图像大小相同的零矩阵
t = 30; % 时间平移量
dx = 0; % x的平移量
dy = t; % y的平移量
trans = [1, 0, 0; 0, 1, 0; dy, dx, 1]; % 平移转移矩阵
t = zeros(2, R);
randnum = -0.5 + rand(dy, C - dx); % 产生-1到1间的高斯随机数,用于填充图像平移缺失块，充当噪声
for k = 1: R
    for m = 1: C
        init = [k, m, 1];   % 原始图像中每个点的位置
        init = init * trans;   % 平移之后的图像的点的位置
        
        x = init(1, 1);
        y = init(1, 2);
        % 赋值操作
        if (x <= R) && (y <= C)  && (x >=1) && (y >= 1)  % 判断该点是否已经超出图像显示范围
            X_Time_Warping(x, y) = x_mel_graph(k, m);  % 将原图像的点转移到现在图像的点
        end
        
        if (k <= dy) && (m <= C - dx)
            X_Time_Warping(k, m) = randnum(k, m);
        end
    end
end
subplot(512);
image(X_Time_Warping');
title('Time Warping');


% Frequency masking
Frequency_mask = [14, 19]; % 频率掩蔽的范围
X_Frequency_masking = zeros(R, C);
for k = 1: R
    for m = 1: C
        if (m <= Frequency_mask(1)) || (m >= Frequency_mask(2))
            X_Frequency_masking(k, m) = x_mel_graph(k, m);
        end
    end
end
subplot(513);
image(X_Frequency_masking') 
title('Frequency masking');


% Time masking
Time_masking = [20, 30]; % 时间掩蔽的范围
X_Time_masking = zeros(R, C);
for k = 1: R
    for m = 1: C
        if (k <= Time_masking(1)) || (k >= Time_masking(2))
            X_Time_masking(k, m) = x_mel_graph(k, m);
        end
    end
end
subplot(514);
image(X_Time_masking')
title('Time masking');

% Time and Frequency masking
Time_Frequency_masking = [20, 30, 14, 18]; % 时间和频率掩蔽的范围
X_Time_Frequency_masking = zeros(R, C);
for k = 1: R
    for m = 1: C
        if ((k <= Time_Frequency_masking(1)) || (k >= Time_Frequency_masking(2))) && ((m <= Time_Frequency_masking(3)) || (m >= Time_Frequency_masking(4)))
            X_Time_Frequency_masking(k, m) = x_mel_graph(k, m);
        end
    end
end
subplot(515);
image(X_Time_Frequency_masking') 
title('Time and Frequency masking');

