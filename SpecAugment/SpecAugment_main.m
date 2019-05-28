clc
clear
filepath = 'D:\matlabproject\hmm\TRAIN1\0a.wav'; % ���԰��Լ���·������
[X, fs] = audioread(filepath);
x_mel_graph = mfcc_m(X,fs, 24, 160, 80);  % ��melϵ��
[R, C] = size(x_mel_graph); % ��ȡͼ���С
subplot(511);
image(x_mel_graph);
title('initial mel image');

% Time Warping
% ͼ��������λ,���ಿ��������������
% R:ʱ���� C:Ƶ����
X_Time_Warping = zeros(R, C); % ����һ����ԭͼ���С��ͬ�������
t = 30; % ʱ��ƽ����
dx = 0; % x��ƽ����
dy = t; % y��ƽ����
trans = [1, 0, 0; 0, 1, 0; dy, dx, 1]; % ƽ��ת�ƾ���
t = zeros(2, R);
randnum = -0.5 + rand(dy, C - dx); % ����-1��1��ĸ�˹�����,�������ͼ��ƽ��ȱʧ�飬�䵱����
for k = 1: R
    for m = 1: C
        init = [k, m, 1];   % ԭʼͼ����ÿ�����λ��
        init = init * trans;   % ƽ��֮���ͼ��ĵ��λ��
        
        x = init(1, 1);
        y = init(1, 2);
        % ��ֵ����
        if (x <= R) && (y <= C)  && (x >=1) && (y >= 1)  % �жϸõ��Ƿ��Ѿ�����ͼ����ʾ��Χ
            X_Time_Warping(x, y) = x_mel_graph(k, m);  % ��ԭͼ��ĵ�ת�Ƶ�����ͼ��ĵ�
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
Frequency_mask = [14, 19]; % Ƶ���ڱεķ�Χ
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
Time_masking = [20, 30]; % ʱ���ڱεķ�Χ
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
Time_Frequency_masking = [20, 30, 14, 18]; % ʱ���Ƶ���ڱεķ�Χ
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

