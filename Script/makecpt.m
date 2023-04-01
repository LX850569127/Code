%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% make cpt from other paper  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��1����colorbar��ͼ�洢��jpg��png��ʽ�ļ���
imread('color_test.png');  % �õ���һ��8*428*3�ľ�������23�ǿ��ߣ���189-long�ǳ���3��RGB��ά��
color=ans(15,:,:);    %  �õ��м�һ������ɫ��Ϣ
all_long =  size(ans,2);
colorfinal=reshape(color,493,3);   %  ���õ��м�һ��ÿ�����RGB
colormap(double(colorfinal)/255)    %  ��Ҫת����˫���ȣ�0-1֮�����ֵ
colorbar

%��3�����õ���colormap�е�rgb[0,1]��ֵת��Ϊ255���ƣ����ο�gmt��cpt�ĸ�ʽ���и�ʽ�任��
colormap(CustomColormap);
a=CustomColormap*255;
grav=colormap*255;
gr1=grav(1:2:end,1:3);
gr2=grav(2:2:end,1:3);
long = 256 - 2;
x=[-long:4:long];x=x';
y=[-(long-4):4:(long+4)];y=y';
g=[x gr1 y gr2];

% ����colorbar�Ժ�ʹ��
colorsave = double(colorfinal)/255;
% save colorsave colorsave -ASCII
% save('colorsave','colorsave');

% (4) ��g�����Ʋο�����cpt��ʽ�����mygrav.cpt��
% 
% mygrav.cptĩβ����
% % 
% B    0 0 0
% 
% F    255 255 255
% 
% N    128 128 128

% %%%   available for matlab to adjust cpt file and you can modify colormap
cpt=[g(:,2)/255 g(:,3)/255 g(:,4)/255];
colormap(cpt);
colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% plot vertical shear wave speed slice
[x y z] = textread('slice1_Vs.txt','%f %f %f%*[^\n]');
dep = max(y);
long = length(x)/dep;
Vs = zeros(long,dep);
for i = 1:long
   for j = 1:dep
       ind = (i-1)*dep+j;
      Vs(i,j) =  z(ind);
   end
end
% imagesc(Vs');
pcolor(Vs);
shading interp
% Vs = griddata(x,y,z,linspace(min(x),max(x),200),linspace(min(y),max(y),200),'v4'); %interpolation
% pcolor(Vs);
colormap(cpt);
colorbar
set(gca,'YDir','reverse');
axis equal
xlim([1 670])
ylim([0 300])
xlabel('Distance (km)')
ylabel('Depth (km)')
title('Vs slice (km/s)')
% (5) ��g����д�����ڻ�gmt��cpt�ļ���
fid = fopen('mycpt.cpt','w');
len = length(g);

Vs = [3 5.1];
vs_interval = (Vs(2)-Vs(1))/len;
Va = Vs(1);
for i = 1:len
   
%     Vb = Vs(2);
    fprintf(fid,'%f %d %d %d %f %d %d %d\n',Va,g(i,2),g(i,3),g(i,4),Va+vs_interval,g(i,6),g(i,7),g(i,8));
    Va = Va+vs_interval;
end
fprintf(fid,'B %d %d %d\n',0,0,0);
fprintf(fid,'F %d %d %d\n',255,255,255);
fprintf(fid,'N %d %d %d\n',128,128,128);
fclose(fid);