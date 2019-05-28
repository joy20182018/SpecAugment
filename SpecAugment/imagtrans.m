clc
clear
X = imread('C:\Users\Morpheus\Desktop\2019.jpg'); % 读取原始图像
X_gray = rgb2gray(X); % 将图像转为灰度图
[R, C] = size(X_gray); % 获取图像大小
% imshow(X_gray);
% Y = im2double(X_gray) * (-1) + 1;% im2double先将uint类型转换为double型才能计算，uint型是为了存储方便
% 线性变换
% 令r为变换前的灰度，s为变换后的灰度，则线性变换的函数：
% s=a?r+b
% 
% 其中，a为直线的斜率，b为在y轴的截距。选择不同的a，b值会有不同的效果：
% 
% a>1，增加图像的对比度
% a<1，减小图像的对比度
% a=1且b≠0，图像整体的灰度值上移或者下移，也就是图像整体变亮或者变暗，
% 不会改变图像的对比度。
% a<0且b=0，图像的亮区域变暗，暗区域变亮
% a=1且b=0，恒定变换，不变
% a=?1且b=255，图像反转。

% 对数变换的通用公式是：
% s=clog(1+r)
% 
% 其中，c是一个常数，，假设r≥0,根据上图中的对数函数的曲线可以看出：对数变换，
% 将源图像中范围较窄的低灰度值映射到范围较宽的灰度区间，
% 同时将范围较宽的高灰度值区间映射为较窄的灰度区间，从而扩展了暗像素的值，
% 压缩了高灰度的值，能够对图像中低灰度细节进行增强。；从函数曲线也可以看出，
% 反对数函数的曲线和对数的曲线是对称的，在应用到图像变换其结果是相反的，
% 反对数变换的作用是压缩灰度值较低的区间，扩展高灰度值的区间。
% 基于OpenCV的实现，其对数变换的代码如下：

% 伽马变换的公式为：
% s=crγ
% 其中c和γ为正常数。
% 伽马变换的效果与对数变换有点类似，
% 当γ>1时将较窄范围的低灰度值映射为较宽范围的灰度值，
% 同时将较宽范围的高灰度值映射为较窄范围的灰度值；当γ<1时，情况相反，
% 与反对数变换类似。其函数曲线如下：

% 图像向右循环移位
XX_gray = zeros(R, C); % 创建一个与原图像大小相同的零矩阵
dx = 200; % x的平移量
dy = 0; % y的平移量
trans = [1, 0, 0; 0, 1, 0; dy, dx, 1]; % 平移转移矩阵
t = zeros(2, R);
for k = 1: R
    for m = 1: C
        init = [k, m, 1];   % 原始图像中每个点的位置
        init = init * trans;   % 平移之后的图像的点的位置
        
        x = init(1, 1);
        y = init(1, 2);
        % 只有if就是只移位，但不补充空缺，else补充空缺，循环图像
        if (x <= R) && (y <= C)  && (x >=1) && (y >= 1)  % 判断该点是否已经超出图像显示范围
            XX_gray(x, y) = X_gray(k, m);  % 将原图像的点转移到现在图像的点
        else
            XX_gray(x- k + 1, y) = X_gray(k, m);
%            t(1, k) = x;
%            t(2, k) = y;
        end
    end
end
XX_gray = uint8(XX_gray);
% XX(1:R, 1: dx) = X_gray(1:R, C-dx + 1: C); % 循环平移
% se = translate(strel(1), [0 dx]);   % 
% Y = imdilate(X_gray,se); % 实现形态学膨胀操作
% % 因为图像是8位无符号数，计算时需要转换为double型数据
% Y = im2double(Y) + XX ./ 255;  % 255, 八位无符号数转换

subplot(221);
imshow(X);
subplot(222);
imshow(X_gray);
subplot(223);
imshow(XX_gray);
% subplot(224);
% imshow(X);


% 图像平移
% init = imread('Fig3.tif'); % 读取图像
% [R, C] = size(init); % 获取图像大小
% res = zeros(R, C); % 构造结果矩阵。每个像素点默认初始化为0（黑色）
% delX = 50; % 平移量X
% delY = 50; % 平移量Y
% tras = [1 0 delX; 0 1 delY; 0 0 1]; % 平移的变换矩阵 
% 
% for i = 1 : R
%     for j = 1 : C
%         temp = [i; j; 1];
%         temp = tras * temp; % 矩阵乘法
%         x = temp(1, 1);
%         y = temp(2, 1);
%         % 变换后的位置判断是否越界
%         if (x <= R) & (y <= C) & (x >= 1) & (y >= 1)
%             res(x, y) = init(i, j);
%         end
%     end
% end;
% 
% imshow(uint8(res)); % 显示图像


% 图像镜像
% init = imread('Fig3.tif');
% [R, C] = size(init);
% res = zeros(R, C);
% 
% for i = 1 : R
%     for j = 1 : C
%         x = i;
%         y = C - j + 1;
%         res(x, y) = init(i, j);
%     end
% end
% 
% imshow(uint8(res));