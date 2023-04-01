function [RoughPosition] = RoughPosition(Ascending_data,Dscending_data)
%Function�������н���������ͽ���֮��Ľ����Ĵ���λ��
%Input��ascending_data(��������)��descending_data(��������)
%Output��RoughPosition(�����Ĵ��λ��)


%% һ�������λ��
coefficient=[];           %��ϵõ��Ķ������ߵ�ϵ��
cor_A=Ascending_data.coordinate;
cor_D=Dscending_data.coordinate;
% ���� ��������������ǽŵ��ԭʼ�ֲ�
% hold on;
% scatter(cor_D(:,1),cor_D(:,2),0.5,'b');
% hold on;
% scatter(cor_A(:,1),cor_A(:,2),0.5,'r');
%�������
cor=Ascending_data.coordinate;
cor=cor(:,1:2);
x=cor(:,2);    %γ��
y=cor(:,1);    %����
p=polyfit(x,y,2);
y=p(1).*x.*x+p(2).*x+p(3);  %��Ϻ�ľ���
coefficient=[coefficient;p];
% % ����  ������Ϻ������
% hold on;
% plot(y,x,'r');
%�������
cor=Dscending_data.coordinate;
cor=cor(:,1:2);
x=cor(:,2);    %γ��
y=cor(:,1);    %����

p=polyfit(x,y,2);
y=p(1).*x.*x+p(2).*x+p(3);  %��Ϻ�ľ���
coefficient=[coefficient;p];
%���� ������Ϻ�Ľ���
% hold on;
% plot(y,x,'b');

%����Ϻ����ߵĽ���
func1=@(x)coefficient(1,1).*x.*x+coefficient(1,2).*x+coefficient(1,3);
func2=@(x)coefficient(2,1).*x.*x+coefficient(2,2).*x+coefficient(2,3);
func=@(x)func1(x)-func2(x);

latOfCrossPoint=fsolve(func,[-80 -83.5]);  %-80��-83���趨��������ֵ��һ���趨�ڽ⸽��
longofCrossPoint=coefficient(1,1).*latOfCrossPoint.*latOfCrossPoint+coefficient(1,2).*latOfCrossPoint+coefficient(1,3);

%�ж�1 
%���������������ͬ�Ľ�ʱ�������жϣ�ͨ������ͽ������������γ�ȵ���С��ֵ
if(latOfCrossPoint(1)~=latOfCrossPoint(2))
    min1=min(abs(cor_A(:,2)-latOfCrossPoint(1)))+min(abs(cor_D(:,2)-latOfCrossPoint(1)));
    min2=min(abs(cor_A(:,2)-latOfCrossPoint(2)))+min(abs(cor_D(:,2)-latOfCrossPoint(2)));
    if(min1<min2)
          CursoryCrossPoint=[longofCrossPoint(1),latOfCrossPoint(1)];  
    else
          CursoryCrossPoint=[longofCrossPoint(2),latOfCrossPoint(2)];  
    end 
else
    CursoryCrossPoint=[longofCrossPoint(1),latOfCrossPoint(1)];  
end

%�ж�2
%�жϴ���λ���Ƿ�λ�ڱ߽緶Χ�ڣ����ڱ߽���ʱ�����ý����
[in]= inpolygon(CursoryCrossPoint(1),CursoryCrossPoint(2),AdjustBoundary(:,1),AdjustBoundary(:,2));
if(not(in))       %����λ�ò��ڱ߽���ʱֱ�ӷ��ؿ�
%    CrossOverPointOutput=[];
%    return;
end

%�ж�3
%������λ������Ϊ���߹��̵��µĴ���⣬ͨ���õ����������γ�Ȳ�����޳�
 min1=min(abs(cor_A(:,2)-CursoryCrossPoint(2)))+min(abs(cor_D(:,2)-CursoryCrossPoint(2)));
if min1>1
    RoughPosition=[];
    return;
end
RoughPosition=CursoryCrossPoint;
%���� ������Ϻ�ĸ��Ե�λ��
% hold on;
% scatter(CursoryCrossPoint(1),CursoryCrossPoint(2),50,'x','k');
end

