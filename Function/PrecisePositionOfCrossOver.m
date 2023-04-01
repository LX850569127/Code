function [ CrossOverPointOutput ] = PrecisePositionOfCrossOver( Ascending_data,Dscending_data,AdjustBoundary)
%Function�����໥�����������֮��Ľ����ľ�ȷλ���Լ�������ͬʱ��ĸ߳�ֵ
%Input��ascending_data(��������)��descending_data(��������)
%Output��CrossOverPoint(������λ���Լ�������ͬʱ��ĸ߳�ֵ)

% hold on;   %������ԭ��ͼ���ϻ�ͼ
%% һ�������λ��
coefficient=[];           %��ϵõ��Ķ������ߵ�ϵ��
cor_A=Ascending_data.coordinate;
cor_D=Dscending_data.coordinate;

%�������
cor=Ascending_data.coordinate;
cor=cor(:,1:2);
xA=cor(:,2);    %γ��
yA=cor(:,1);    %����
p=polyfit(xA,yA,2);
yA=p(1).*xA.*xA+p(2).*xA+p(3);  %��Ϻ�ľ���
coefficient=[coefficient;p];

%�������
cor=Dscending_data.coordinate;
cor=cor(:,1:2);
xD=cor(:,2);    %γ��
yD=cor(:,1);    %����

p=polyfit(xD,yD,2);
yD=p(1).*xD.*xD+p(2).*xD+p(3);  %��Ϻ�ľ���
coefficient=[coefficient;p];


% ���� ��������������ǽŵ��ԭʼ�ֲ�
% scatter(cor_A(:,1),cor_A(:,2),4,[241 64 64]/255,'filled','HandleVisibility','off');
% scatter(cor_D(:,1),cor_D(:,2),4,[26 111 223]/255,'filled');
%  ���� ������Ϻ���������ߺͽ�������
% plot(yA,xA,'Color',[241 64 64]/255,'LineWidth',3);
% plot(yD,xD,'Color',[26 111 223]/255,'LineWidth',3);

%���� ������ϵ��������ߺͽ������ߵ�һ����
% yA1=yA(find(yA>204&yA<207));
% xA1=xA(find(yA>204&yA<207));
% plot(yA1,xA1,'Color',[241 64 64]/255,'LineWidth',2);
% yD1=yD(find(yD>204&yD<207));
% xD1=xD(find(yD>204&yD<207));
% plot(yD1,xD1,'Color',[241 64 64]/255,'LineWidth',2);

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
% [in]= inpolygon(CursoryCrossPoint(1),CursoryCrossPoint(2),AdjustBoundary(:,1),AdjustBoundary(:,2));
% if(not(in))       %����λ�ò��ڱ߽���ʱֱ�ӷ��ؿ�
% %    CrossOverPointOutput=[];
% %    return;
% end

%�ж�3
%������λ������Ϊ���߹��̵��µĴ���⣬ͨ���õ����������γ�Ȳ�����޳�
 min1=min(abs(cor_A(:,2)-CursoryCrossPoint(2)))+min(abs(cor_D(:,2)-CursoryCrossPoint(2)));
if min1>0.06  %γ�Ȳ����Сֵ
    CrossOverPointOutput=[];
    return;
end

%���� ������Ϻ�ĸ��Ե�λ��
% scatter(CursoryCrossPoint(1),CursoryCrossPoint(2),100,'d','k','filled','HandleVisibility','off');



%% ������ȷλ��

%����һ ������
% Tangent=SolveTangent(CursoryCrossPoint,coefficient);    %���һ�δ���λ�õ���������
% [NumOfIterativePoints]=DetermineNumberOfIterations(cor_A,cor_D,CursoryCrossPoint,Tangent);  %���һ�ε����ĵ�������
CrossOverPoint5=IterationOfCursoryLocation(cor_A,cor_D,CursoryCrossPoint,AdjustBoundary,10,5);
CrossOverPoint35=IterationOfCursoryLocation(cor_A,cor_D,CursoryCrossPoint,AdjustBoundary,10,35);
% %���� Ϊ�˶Ա����ֲ�ͬ�����ľ�ȷλ�ý��
% if ~isempty(CrossOverPoint)
%     scatter(CrossOverPoint(1),CrossOverPoint(2),150,'p','k','filled');
%     CrossOverPoint=IterationOfCursoryLocation(cor_A,cor_D,CursoryCrossPoint,AdjustBoundary,10,5);
%     scatter(CrossOverPoint(1),CrossOverPoint(2),150,'p','b','filled');
% end
%������ �������淨
CrossOverPoint=ExactPosition2(cor_A,cor_D,CursoryCrossPoint,AdjustBoundary);

%������ �Ľ��ĵ�����
% Tangent=SolveTangent(CursoryCrossPoint,coefficient);    %���һ�δ���λ�õ���������
% [NumOfIterativePoints]=DetermineNumberOfIterations(cor_A,cor_D,CursoryCrossPoint,Tangent);  %���һ�ε����ĵ�������
% CrossOverPoint=IterationOfCursoryLocation(cor_A,cor_D,CursoryCrossPoint,AdjustBoundary,10,NumOfIterativePoints,Tangent);


%������ؽ����λ�õľ���Ϊ�գ�˵���ý����λ�ڱ߽�֮�⣬ֱ�ӷ���
if isempty(CrossOverPoint)
    CrossOverPointOutput=[];
    return;
end 

if ~isempty(CrossOverPoint)&&~isempty(CrossOverPoint5)
   PDOP1=distance([CrossOverPoint(2),CrossOverPoint(1)],[CrossOverPoint5(2),CrossOverPoint5(1)])*pi/180*6371.393;
else 
    PDOP1=0;
end

if ~isempty(CrossOverPoint)&&~isempty(CrossOverPoint35)
   PDOP2=distance([CrossOverPoint(2),CrossOverPoint(1)],[CrossOverPoint35(2),CrossOverPoint35(1)])*pi/180*6371.393;
   else 
    PDOP2=0;
end

%ģ�����ĵ���
CrossOverPointOutput= struct('coordinate',CrossOverPoint,'PDOP1',PDOP1,'PDOP2',PDOP2);
return;

%% �����󽻲��������߳��Լ���Ӧ��ʱ��
%3.1 ���������̼߳���
% rowOfCloset=SearchClosestValue(cor_A(:,2),CrossOverPoint(2));
% 
% %����EnviSat���ݵ�ʱ������γ�Ƚӽ���ֵ̫��ʹ�þ��Ƚ��м���
% % rowOfCloset=SearchClosestValue(cor_A(:,1),CrossOverPoint(1));
% 
% %�ҵ��̲߳�ֵ��
%  % ��ֹ����󳬳�����Χ���������
%         if(rowOfCloset-2<=0)  
%             floor=1;
%         else
%             floor=rowOfCloset-2;
%         end
%         if(rowOfCloset+2>size(cor_A))
%             top=size(cor_A);
%         else
%             top=rowOfCloset+2;
%         end
% interpolationPointOfA=cor_A(floor:top,:);
% % hold on;
% % scatter(interpolationPointOfA(:,1),interpolationPointOfA(:,2),30,'r');
% 
% %���з������Ȩ���㾫ȷ�����ĸ̲߳�ֵ
% %�������
% for i=1:size(interpolationPointOfA,1)
% dis=distance([interpolationPointOfA(i,2),interpolationPointOfA(i,1)],[CrossOverPoint(2),CrossOverPoint(1)])*pi/180*6371.393;
% interpolationPointOfA(i,5)=dis;   %����(��λΪkm)
% end
% 
% %�޳��������ĵ�
% interpolationPointOfA(interpolationPointOfA(:,5)>2,:)=[];
% 
% %�޳��߳�ֵ�쳣�ĵ㣬�߳�>2000&&<-55
% interpolationPointOfA(interpolationPointOfA(:,3)>2000,:)=[];
% interpolationPointOfA(interpolationPointOfA(:,3)<-55,:)=[];
% 
% 
% %�����������߽��������ڶԽ����߳̽��в�ֵ�ĵ���뽻����λ�þ���Զ�������ý����
% if isempty(interpolationPointOfA)
%     CrossOverPointOutput=[];
%     return;
% end 
% 
% %ͨ�������Ȩ�õ��߳�
% %Ȩ�ؼ���
% denominator=0;
% for i=1:size(interpolationPointOfA,1)
%     denominator=denominator+interpolationPointOfA(i,5)^-2;
% end 
% 
% for i=1:size(interpolationPointOfA,1)
%     weightFactor=interpolationPointOfA(i,5)^-2/denominator;
%     interpolationPointOfA(i,6)=weightFactor; 
% end 
% 
% 
% 
% %�̲߳�ֵ����
% altitude_A=0;
% for i=1:size(interpolationPointOfA,1)
%     altitude_A=altitude_A+interpolationPointOfA(i,3)*interpolationPointOfA(i,6);
% end 
% 
% time_A=0;
% % time_A=cor_A(rowOfCloset,4);
% 
% 
% %3.2 ����㽵��̼߳���
% rowOfCloset=SearchClosestValue(cor_D(:,2),CrossOverPoint(2));
% 
% 
% % %����EnviSat���ݵ�ʱ������γ�Ƚӽ���ֵ̫��ʹ�þ��Ƚ��м���
% % rowOfCloset=SearchClosestValue(cor_D(:,1),CrossOverPoint(1));
% 
% %�ҵ��̲߳�ֵ��
%  % ��ֹ����󳬳�����Χ���������
%         if(rowOfCloset-2<=0)
%             floor=1;
%         else
%             floor=rowOfCloset-2;
%         end
%         if(rowOfCloset+2>size(cor_D))
%             top=size(cor_D);
%         else
%             top=rowOfCloset+2;
%         end
% interpolationPointOfD=cor_D(floor:top,:);
% 
% %���з������Ȩ���㾫ȷ�����ĸ̲߳�ֵ
% 
% %�������
% for i=1:size(interpolationPointOfD,1)
% dis=distance(interpolationPointOfD(i,2),interpolationPointOfD(i,1),CrossOverPoint(2),CrossOverPoint(1))*pi/180*6371.393;
% interpolationPointOfD(i,5)=dis;   %����(��λΪkm)
% end
% 
% %�޳��������ĵ�
% interpolationPointOfD(interpolationPointOfD(:,5)>2,:)=[];
% 
% %�޳��߳�ֵ�쳣�ĵ㣬�߳�>2000&&<-55
% interpolationPointOfD(interpolationPointOfD(:,3)>2000,:)=[];
% interpolationPointOfD(interpolationPointOfD(:,3)<-55,:)=[];
% 
% %�����������߽��������ڶԽ����߳̽��в�ֵ�ĵ���뽻����λ�þ���Զ�������ý����
% if isempty(interpolationPointOfD)
%     CrossOverPointOutput=[];
%     return;
% end 
% 
% %���� �������ڸ̲߳�ֵ�������ͽ����
% % hold on;
% % scatter(interpolationPointOfA(:,1),interpolationPointOfA(:,2),30,'r');
% % scatter(interpolationPointOfD(:,1),interpolationPointOfD(:,2),30,'b');
% 
% 
% %ͨ�������Ȩ�õ��߳�
% %Ȩ�ؼ���
% denominator=0;
% for i=1:size(interpolationPointOfD,1)
%     denominator=denominator+interpolationPointOfD(i,5)^-2;
% end 
% 
% for i=1:size(interpolationPointOfD,1)
%     weightFactor=interpolationPointOfD(i,5)^-2/denominator;
%     interpolationPointOfD(i,6)=weightFactor; 
% end 
% 
% %�̲߳�ֵ����
% altitude_D=0;
% for i=1:size(interpolationPointOfD,1)
%     altitude_D=altitude_D+interpolationPointOfD(i,3)*interpolationPointOfD(i,6);
% end 
% time_D=0;
% % time_D=cor_D(rowOfCloset,4);
% 
% % hold on;
% % scatter(CrossOverPoint(1),CrossOverPoint(2),100,'p','k','filled');
% %% ����
% 
% %�ֱ��ҵ�����ͽ������뽻��㾫ȷλ�þ�����ӽ���������
% A=sortrows(interpolationPointOfA,5);
% D=sortrows(interpolationPointOfD,5);
% if size(A,1)>=2&&size(D,1)>=2
%    PDOP=A(2,5)-A(1,5)+D(2,5)-D(1,5);
% else 
%    PDOP=-1;  
% end
% % scatter(A(1:2,1),A(1:2,2),30,'r');
% % scatter(D(1:2,1),D(1:2,2),30,'b');
% %% 
% 
% 
% 
% %% �ġ��������
% 
% % ���� ���ƽ����ľ�ȷλ��
% altitude=[altitude_A,time_A;altitude_D,time_D];
% CrossOverPointOutput= struct('coordinate',CrossOverPoint,'altitude',altitude,'PDOP',PDOP);
% 
%%
end

