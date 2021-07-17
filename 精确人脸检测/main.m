clear;
clc;
close all;
format compact;
format long;

RGBImg = imread('./imgs/test3.jpg'); %��ȡͼƬ
grayImg = rgb2gray(RGBImg);
cb_scale = 2;
cr_scale = 1;

[cb_mean, cr_mean, cb_std, cr_std] = cbcrPlate(cb_scale, cr_scale) % ��ȡ������Ϣ

result = FaceBinarization(RGBImg, cb_mean, cr_mean, cb_std, cr_std, cb_scale, cr_scale); % ͼ���ֵ��

result = imfill(result,'holes'); % �����

result = bwareaopen(result, 500); % ȥ��������

result = imerode(result, ones(5)); % ͼ��ʴ������Ϊ��Ե������

edgeImg = edge(grayImg, 'roberts', 0.1); % Robert��Ե���
edgeImg = ~edgeImg;

result = 255*(double(result) & double(edgeImg)); % ���ϻ�ý��

% �ٴν��б�Ե��⴦�����ݿ�߱�ȥ��������������������
result = imerode(result, ones(5)); 

result = bwfill(result, 'holes');

result = bwareaopen(result, 500);

[segments, num_segments] = bwlabel(result);
status = regionprops(segments, 'BoundingBox');

width_all = []; height_all = [];
for i=1:num_segments
    width_all = [width_all; status(i).BoundingBox(3)];
    height_all = [height_all; status(i).BoundingBox(4)];
end
 figure;
 subplot(221), hist(width_all, 50), title('��������ķֲ�ͼ');
 subplot(222), hist(height_all, 50), title('�������ߵķֲ�ͼ');
 subplot(223), hist(height_all./width_all, 50), title('�������߿�ȵķֲ�ͼ');

% չʾ�����Ϣ
figure, imshow(RGBImg);
for i=1:num_segments
    width = status(i).BoundingBox(3);
    height = status(i).BoundingBox(4);
    ratio = height/width;
    if ratio > 3 || ratio < 0.75 || (width < 40 & height < 50) continue; end
    rectangle('position', status(i).BoundingBox, 'edgecolor', 'r');
end 