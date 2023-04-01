function [PreciseCorssPoint] = IterationOfCursoryLocation(cor_A,cor_D,CursoryCrossPoint,AdjustBoundary,Iterations,NumOfIterativePoints,Tangent,varargin)
%Function��ͨ��������⽻���ľ�ȷλ��
%Input��cor_A(��������)��cor_D(��������)��CursoryCrossPoint(������ʼ����λ��,����λ��)
%Input��AdjustBoundary(�����жϵı߽�����)��Iterations(��������)��NumOfIterativePoints(����������ѡȡ�ĵ�ĸ���)
%Input��Tangent(��ʼ����λ�ô����������������ߣ����ڼ������ݵ㵽���߾���)
%Output��PreciseCorssPoint(�����ľ�ȷλ��)

%% Set defaults: 

Update=false;      %Ĭ�ϲ��ڵ��������и��µ�������
limit=30;          %���ö��������һ����ϵķֽ���


%% Parse inputs: 

if ~isempty(varargin)   
    Update=varargin{1};   %�����Ƿ���µ��������Ĳ���
end

for i=1:Iterations                %ȷ����������
 
cursoryLocation=[CursoryCrossPoint(1),CursoryCrossPoint(2)];       %������һ�ε����ĸ��Ե�ο�λ��

%% һ��Ѱ�����ڶ�����ϵ�����������

%1.1 ������������
difference=cor_A(:,2)-cursoryLocation(1,2);                        %����γ�Ȳ�ֵ  
minValue=min(abs(difference));                                     %��С��ֵ
rowOfMin=find(minValue==abs(difference)) ;                         %γ����ӽ�ֵ���ڵ���

% ��ֹ�����γ�Ƚӽ����������
if size(rowOfMin,1)>1
    rowOfMin=rowOfMin(2,:);
end

% ��ֹ����󳬳�����Χ���������
if rowOfMin-NumOfIterativePoints<=0 
    floor=1;
    top=min(NumOfIterativePoints*4,size(cor_A,1));
elseif rowOfMin+NumOfIterativePoints>size(cor_A,1)
    top=size(cor_A,1);
    floor=max(1,top-NumOfIterativePoints*4);
else
    floor=rowOfMin-NumOfIterativePoints;
    top=rowOfMin+NumOfIterativePoints; 
end

% �����õ�����������
extendData_A=[cor_A(floor:top,1),cor_A(floor:top,2)];
x_A=extendData_A(:,2);    %γ��
y_A=extendData_A(:,1);    %����

if NumOfIterativePoints<limit
%1.2.1 �������������ݽ���һ�����
    coefficient1=polyfit(x_A,y_A,1);
    y_A=coefficient1(1).*x_A+coefficient1(2);  %��Ϻ�ľ���
    else
    %1.2.2 ���������õ����������ݽ��ж������
    coefficient1=polyfit(x_A,y_A,2);
    y_A=coefficient1(1).*x_A.*x_A+coefficient1(2).*x_A+coefficient1(3);  %��Ϻ�ľ���
end

%1.3 ������������
difference=cor_D(:,2)-CursoryCrossPoint(1,2);   %γ�Ȳ�ֵ    
minValue=min(abs(difference));
rowOfMin=find(minValue==abs(difference));  %γ����ӽ�ֵ���ڵ���

% ��ֹ�����γ�Ƚӽ����������
if size(rowOfMin,1)>1
    rowOfMin=rowOfMin(2,:);
end

%��ֹ����󳬳�����Χ���������

if rowOfMin-NumOfIterativePoints<=0 
    floor=1;
    top=min(NumOfIterativePoints*4,size(cor_D,1));
elseif rowOfMin+NumOfIterativePoints>size(cor_D,1)
    top=size(cor_D,1);
    floor=max(1,top-NumOfIterativePoints*4);
else
    floor=rowOfMin-NumOfIterativePoints;
    top=rowOfMin+NumOfIterativePoints; 
end

% �����õ��Ľ�������
extendData_D=[cor_D(floor:top,1),cor_D(floor:top,2)];
x_D=extendData_D(:,2);    %γ��
y_D=extendData_D(:,1);    %����



if NumOfIterativePoints<limit
    %1.4.1  ���������õ��Ľ������ݽ���һ�����
    coefficient2=polyfit(x_D,y_D,1);
    y_D=coefficient2(1).*x_D+coefficient2(2);  %��Ϻ�ľ���
    else 
    %1.4.2  ���������õ��Ľ������ݽ��ж������
    coefficient2=polyfit(x_D,y_D,2);
    y_D=coefficient2(1).*x_D.*x_D+coefficient2(2).*x_D+coefficient2(3);  %��Ϻ�ľ���
end

%     ֱ�����
%     y_A=coefficient1(1).*x_A+coefficient1(2);  %��Ϻ�ľ���
%     �������
%     y_A=coefficient1(1).*x_A.*x_A+coefficient1(2).*x_A+coefficient1(3);  %��Ϻ�ľ���
  

   
%     
%     x_D=linspace(-81,-78,20);
%         ֱ�����
%     y_D=coefficient2(1).*x_D+coefficient2(2);  %��Ϻ�ľ���
%     �������
%     y_D=coefficient2(1).*x_D.*x_D+coefficient2(2).*x_D+coefficient2(3);  %��Ϻ�ľ���






%% �����󽻲��ľ�ȷλ��

if NumOfIterativePoints<limit
%% ֱ�����
    func1=@(x)coefficient1(1).*x+coefficient1(2);
    func2=@(x)coefficient2(1).*x+coefficient2(2);
    func=@(x)func1(x)-func2(x);
    latOfCrossPoint=fsolve(func,[CursoryCrossPoint(2) CursoryCrossPoint(2)]);
    longofCrossPoint=coefficient1(1).*latOfCrossPoint+coefficient1(2);
    CrossOverPoint=[longofCrossPoint(1),latOfCrossPoint(1)];
    else 
%% �������
    func1=@(x)coefficient1(1).*x.*x+coefficient1(2).*x+coefficient1(3);
    func2=@(x)coefficient2(1).*x.*x+coefficient2(2).*x+coefficient2(3);
    func=@(x)func1(x)-func2(x);
    latOfCrossPoint=fsolve(func,[CursoryCrossPoint(2) CursoryCrossPoint(2)]);
    %��ֹ������ϵĹ��������ǽŵ������ɢ���ֶ������
    if(latOfCrossPoint(1)~=latOfCrossPoint(2))
       difference=abs(latOfCrossPoint-CursoryCrossPoint(2));
       [~,ind] =min(difference);
       latOfCrossPoint=latOfCrossPoint(ind);
    end
    longofCrossPoint=coefficient1(1).*latOfCrossPoint.*latOfCrossPoint+coefficient1(2).*latOfCrossPoint+coefficient1(3);
    CrossOverPoint=[longofCrossPoint(1),latOfCrossPoint(1)];

end
%% plot for debugging

% Extend coordinates
% x_A=linspace(min(x_A)-0.06,max(x_A)+0.01,10);
% x_D=linspace(min(x_D)-0.06,max(x_D)+0.01,10);
% y_A=coefficient1(1).*x_A+coefficient1(2); 
% y_D=coefficient2(1).*x_D+coefficient2(2); 

% Clip raw data
% rowA=SearchClosestValue(cor_A(:,2),CursoryCrossPoint(2));
% rowD=SearchClosestValue(cor_D(:,2),CursoryCrossPoint(2));

% Plot 
% scatter(CursoryCrossPoint(1),CursoryCrossPoint(2),80,'d','k','filled');
% scatter(CrossOverPoint(1),CrossOverPoint(2),100,'p','k','filled','HandleVisibility','off');
% scatter(cor_A(rowA-30:rowA+30,1),cor_A(rowA-30:rowA+30,2),8,[127 140 141]/255,'filled','HandleVisibility','off');
% scatter(cor_D(rowD-30:rowD+30,1),cor_D(rowD-30:rowD+30,2),8,[127 140 141]/255,'filled');
% scatter(extendData_D(:,1),extendData_D(:,2),20,'MarkerFaceColor','k','MarkerEdgeColor','k','HandleVisibility','off');
% scatter(extendData_A(:,1),extendData_A(:,2),20,'MarkerFaceColor','k','MarkerEdgeColor','k');
% plot(y_A,x_A,'--','Color',[0 0 0]/255,'LineWidth',1,'HandleVisibility','off');
% plot(y_D,x_D,'--','Color',[0 0 0]/255,'LineWidth',1,'HandleVisibility','off');

% Set
% set(gca,'fontsize',16);
% xlabel('����/(��)','FontSize',16);
% ylabel('γ��/(��)','FontSize',16);
% legend('����λ��','���ݵ�','��ϵ�');

%% 
% �����������Ƿ�ÿһ�ε���������ȷ�����������Ŀ��� 
% if Update && rem(i,3)==0
 if Update
    NumOfIterativePoints=DetermineNumberOfIterations(cor_A,cor_D,CursoryCrossPoint,Tangent);  %ȷ�����������Ĺ̶�ֵ
end

%����
% hold on;
% scatter(CrossOverPoint(1),CrossOverPoint(2),80,'d','k','filled','HandleVisibility','off');

%%

%�ж�ǰ�����ε����õ��ĵ��λ�õľ���
if i>3
  dis=distance(CursoryCrossPoint(2),CursoryCrossPoint(1),CrossOverPoint(2),CrossOverPoint(1))*pi/180*6371.393; %��λkm
%   �жϵ���ǰ������֮��ľ����Ƿ�С��60m
  if dis<0.04 %km 40m
      PreciseCorssPoint=CrossOverPoint;
%       �ж����һ�εľ�ȷλ���Ƿ�λ�ڱ߽緶Χ�ڣ����ڱ߽���ʱ�����ý����
      [in]= inross(CrossOverPoint(1),CrossOverPoint(2),AdjustBoundary);
      if(not(in))   
          %        ����
%             scatter(CrossOverPoint(1),CrossOverPoint(2),88,'p','c','filled');
          PreciseCorssPoint=[];
      end
      return;
  end
end

CursoryCrossPoint=CrossOverPoint;    %������һ�ε����ĳ�ʼλ��

%�ﵽ����������������Ȼ������ǰ��ľ����ж�����ʱ������һ�εĽ��
if i==Iterations
    PreciseCorssPoint=CrossOverPoint;
    %�ж����һ�ε����õ��ľ�ȷλ���Ƿ�λ�ڱ߽緶Χ�ڣ����ڱ߽���ʱ�����ý����
%    [in]= inpolygon(CrossOverPoint(1),CrossOverPoint(2),AdjustBoundary(:,1),AdjustBoundary(:,2));
     [in]= inross(CrossOverPoint(1),CrossOverPoint(2),AdjustBoundary);
   if(not(in))   
%          scatter(CrossOverPoint(1),CrossOverPoint(2),88,'p','c','filled');
       PreciseCorssPoint=[];
   end
end 
end

