function [ExactPosition] = ExactPosition2(AscendData,DescendData,RoughPosition,Boundary)
%Function���ڽ�������λ�õĻ�������⽻���ľ�ȷλ��
%Input��AscendData(��������)��DescendData(��������)��RoughPosition(����λ��)��Boundary(�߽�����)
%Output��ExactPosition(�����ľ�ȷλ��)

if size(AscendData,1)<=9||size(DescendData,1)<=9
    ExactPosition=[];
    return;
end
%% �������λ���ڱ߽����Ҿ���߽��Զʱ�����м���
[in]= inpolygon(RoughPosition(1),RoughPosition(2),Boundary(:,1),Boundary(:,2));
if(not(in))       %����λ�ò��ڱ߽���ʱ�Ž����ж�
    %��ѡ���ȷ�Χ���ӽ��ı߽�ֵ�����ټ�����
    Bound=Boundary(find(abs(Boundary(:,1)-RoughPosition(1))<5),:);
    boundDis=zeros(size(Bound,1),1);
    for i=1:size(Bound)
        boundDis(i)=SphereDist(RoughPosition,Bound(i,1:2));
    end
    % С��12kmʱ��������㾫ȷ���λ��
        if min(boundDis)>12
            ExactPosition=[];
             return;
        elseif min(boundDis)<8.2
            count1=14;  %������� ����߽�ӽ�ʱ���ݵ�ֲ���ɢ�������жϵ�ĸ���
        end
end
      
%     ���� ���Ʋ�ɸѡ��ı߽��
%     plot(Bound(:,1),Bound(:,2),'.r','MarkerSize',0.3 );  %���Ʊ��ܵı߽�ͼ
%     scatter(DescendData(P1_D_row,1),DescendData(P1_D_row,2),10,'b','d');




%% 1��Ѱ�Ҿ��뾫ȷλ����������ݵ����ڵ������кͽ�����
rowA=SearchClosestValue(AscendData(:,2),RoughPosition(2));   %�����������
if size(rowA,1)>1
    rowA=rowA(2,:);
end


rowD=SearchClosestValue(DescendData(:,2),RoughPosition(2));  %����Ľ�����
if size(rowD,1)>1
    rowD=rowD(2,:);
end





%���� �������������ͽ��������
% scatter(AscendData(rowA,1),AscendData(rowA,2),10,'r','d');
% scatter(DescendData(rowD,1),DescendData(rowD,2),10,'b','d');

%�������������һ�����̲������ж����λ�÷���ʱ����ָ��һ������
if size(AscendData,1)<=20||size(DescendData,1)<=20
      direction='up';
    
elseif rowA+15>size(AscendData,1)&&rowD+15>size(DescendData,1)  %����ĩ���뽵��ĩ��ʮ�ֽӽ������
    rowD=size(DescendData,1);
    rowA=SearchClosestValue(AscendData(:,2),DescendData(rowD,2));   
    direction='up';
else
%% 2���жϾ�ȷλ��λ�ڸ���λ�õķ��� 
dis1=SphereDist(AscendData(rowA,1:2),DescendData(rowD,1:2)); 
if dis1<0.65  %�����ͽ��������Ѿ�ʮ�ֽӽ�������£�������ʼ���жϵ�λ
    %��ֹ����Խ�� 
    if  rowA-10<=0||rowD+10>size(DescendData,1)
        if rowD+10>size(DescendData,1)
          rowA=rowA-(size(DescendData,1)-rowD);
          rowD=size(DescendData,1);
        else     
          rowD=rowD+rowA;  
          rowA=1;
        end
    else 
        rowD=rowD+10;  
        rowA=rowA-10;
    end
     count=7;  %ƽ�Ƶ���
else 
     count=7;
end
%���ø���ĵ�����һ�ξ��룬��ֹ�����жϴ�������
dis1=0;
if exist('count1')
    it=count1;
else
    it=7;
end
%��ֹ��������Խ��������Խ��������������ƽ��
if rowA-it<=0||rowD+it>size(DescendData,1)
    
    for i=1:it
    dis1_1=SphereDist(AscendData(rowA+i,1:2),DescendData(rowD-i,1:2));    %������ƽ��
    dis1=dis1+dis1_1;
    end
else
    for i=1:it
    dis1_1=SphereDist(AscendData(rowA-i,1:2),DescendData(rowD+i,1:2));    %������ƽ��
    dis1=dis1+dis1_1;
    end
end
dis1=dis1/i;


dis2=0;
%���ø���ĵ��������������ƽ�ƺ�ľ��룬��ֹ�����жϴ�������
%�������߽�ȽϽ������������ݵ�ֲ�ʮ����ɢ���������ֵ�ĵ���������

if exist('count1')
    it=count1;
else
    it=7;
end
%��ֹ����Խ������
if rowA+count+it>size(AscendData,1)||rowD-count-i<=0
    for i=1:3      %�����Ϸ���Խ�磬�����·�3�����ƽ���������·�7�����ƽ������Ƚ�
    dis2_1=SphereDist(AscendData(rowA-i,1:2),DescendData(rowD+i,1:2));  
    dis2=dis2+dis2_1;
    end
    dis2=dis2/i;
else
    for i=1:it
    dis2_1=SphereDist(AscendData(rowA+count+i,1:2),DescendData(rowD-count-i,1:2));  
    dis2=dis2+dis2_1;
    end
    dis2=dis2/i;
end





    if dis1<dis2      %��ȷ��λ��λ�ڸ��Ե�λ��֮��
       direction='down';
    else              %��ȷ��λ��λ�ڸ��Ե�λ��֮��
          direction='up';     
    end
end


%% 3���Ӿ��巽��Ѱ�ҽ���㾫ȷλ��

for it=1:2
    P1_A_row=rowA;
    P1_D_row=rowD;

%����ѭ���ж�   ��һ��ѭ����Ŀ�ģ�Ѱ�Ҿ���С��2km�������ͽ����
for i=1:100
    %��ֹ��������Խ��ı���
    if  strcmp(direction,'down')==1   
        if P1_A_row<=0||P1_D_row>size(DescendData,1)
            break;
        end   
    end
    
     if  strcmp(direction,'up')==1   
        if P1_A_row+1>size(AscendData,1)||P1_D_row<=0   %��1������㲻������ƽ�Ƶ����
            break;
        end   
    end
    
    P1_A=AscendData(P1_A_row,1:2);    
    P1_D=DescendData(P1_D_row,1:2);
    dis=SphereDist(P1_A,P1_D);
    
    if dis <3  %3km�ڲŽ����Ƿ��ཻ���ж�
        


        latitudeDif=abs(P1_A(2)-P1_D(2));
        if latitudeDif>0.02
         if  strcmp(direction,'up')==1    %����Ѱ�ҵ�������� 
            if P1_A(2)>P1_D(2)    %������γ��ֵ���ͣ����������
                P1_A_row=SearchClosestValue(AscendData(:,2),P1_D(2));   %�����������
                   P1_A=AscendData(P1_A_row,1:2); 

            else                   %������γ��ֵ���ͣ����������
                 P1_D_row=SearchClosestValue(DescendData(:,2),P1_A(2));   %�����������
                   P1_D=DescendData(P1_D_row,1:2); 
            end
         else                             %����Ѱ�ҵ��������
              if P1_A(2)>P1_D(2)    %������γ��ֵ���ͣ����������
               P1_D_row=SearchClosestValue(DescendData(:,2),P1_A(2));   %�����������
                   P1_D=DescendData(P1_D_row,1:2); 
              else                  %������γ��ֵ���ͣ����������
                    P1_A_row=SearchClosestValue(AscendData(:,2),P1_D(2));   %�����������
                   P1_A=AscendData(P1_A_row,1:2);   
              end
           end
        end
             %���� ��������С��2km�������ͽ����
        scatter(AscendData(P1_A_row,1),AscendData(P1_A_row,2),10,'r','d');
        scatter(DescendData(P1_D_row,1),DescendData(P1_D_row,2),10,'b','d');

        P1_D_row_start=P1_D_row;  %��¼��ʼ�Ľ����ƶ��㣬���㸴λ        
        
         %��ֹ������ƶ��Ĺ�����Խ��
          if  strcmp(direction,'up')==1 
            if (P1_A_row+50)>size(AscendData,1)
                maxK=size(AscendData,1)-P1_A_row;
            else
                 maxK=50;
            end
        else
            if (P1_A_row-50)<=0
                maxK=P1_A_row-1;
            else
                 maxK=50;
            end
          end
        
        %�������λ�����ж��Ƿ��ཻ���ڶ���ѭ����Ŀ�ģ�������ƶ�(�ڽ�����ƶ�һ�������ƶ���ɺ�)
        for k=1:maxK
        
        P1_A=AscendData(P1_A_row,1:2); %��һ��������ƶ�
        %�����ڶ��������
        if  strcmp(direction,'up')==1   
            P2_A=AscendData(P1_A_row+1,1:2);
            P1_A_row=P1_A_row+1;
        else                         
            P2_A=AscendData(P1_A_row-1,1:2);
            P1_A_row=P1_A_row-1;
        end
     
%          ���� �����ƶ��������        
         scatter(P2_A(1),P2_A(2),15,'r','d');
           plot([P1_A(1),P2_A(1)],[P1_A(2),P2_A(2)],'linewidth',3,'color','r');
           
                    P1_D_row=P1_D_row_start;  % ����㸴λ
                P1_D=DescendData(P1_D_row,1:2);
                %�����ڶ��������
       if  strcmp(direction,'up')==1   
            P2_D=DescendData(P1_D_row-1,1:2);
        else                         
            P2_D=DescendData(P1_D_row+1,1:2);
       end
       
%            %���� �����ཻ���������
           scatter(P1_A(1),P1_A(2),15,'r','d');
           scatter(P2_A(1),P2_A(2),15,'r','d');
           scatter(P1_D(1),P1_D(2),15,'b','d');
           scatter(P2_D(1),P2_D(2),15,'b','d');
                
            
        %��ֹ������ƶ�Խ��
        if  strcmp(direction,'down')==1 
            if (P1_D_row_start+50)>size(DescendData,1)
                maxIt=size(DescendData,1)-P1_D_row_start;
            else
                 maxIt=50;
            end
        else
            if (P1_D_row_start-50)<=0
                maxIt=P1_D_row_start-1;
            else
                 maxIt=50;
            end
        end
            for j=1:maxIt   %������ѭ����Ŀ�ģ�������ƶ�
                
                if IsCross(P1_A,P2_A,P1_D,P2_D)==1  %�ҵ��˽��������
                    
                    
                    
%                  ���� �������������������߶�                            
                 plot([P1_A(1),P2_A(1)],[P1_A(2),P2_A(2)],'linewidth',3);
                 plot([P1_D(1),P2_D(1)],[P1_D(2),P2_D(2)],'linewidth',3);
%                   
                    CP=getCrossOverPoint(P1_A,P2_A,P1_D,P2_D);
                    %�ж����󽻲���Ƿ��ڱ߽���
                   [in]= inpolygon(CP(1),CP(2),Boundary(:,1),Boundary(:,2));
                   if (in)
                    ExactPosition=CP;
                   else   %���ٱ߽���ʱ���ؿ�ֵ
                    ExactPosition=[];   
                   end
                    
%                     ���� ���������ľ�ȷλ��
                    scatter(CP(1),CP(2),88,'b','s');
                    return;
                else 
                    
%                ���� �����ƶ��Ľ����
 scatter(P2_D(1),P2_D(2),15,'b','d');
 plot([P1_D(1),P2_D(1)],[P1_D(2),P2_D(2)],'linewidth',3,'color','b');   %������ƶ�
                    P1_D=P2_D;
                    if  strcmp(direction,'up')==1
                        P1_D_row=P1_D_row-1;
                        P2_D=DescendData(P1_D_row,1:2);
                    else
                         P1_D_row=P1_D_row+1;
                        P2_D=DescendData(P1_D_row,1:2);
                    end                               
                end
            end

%               
%             %������ƶ�
%                P1_A=P2_A;
%                 if  strcmp(direction,'up')==1
%                      P1_A_row=P1_A_row+1;
%                     P2_A=AscendData(P1_A_row,1:2);
%                 else
%                      P1_A_row=P1_A_row-1;
%                     P2_A=AscendData(P1_A_row,1:2);
%                 end
                               
        end 
        
        
        break;
      
    else            %����1kmʱ�����ӽ��ĵ㿿��
        if dis>5    %�������ʱ���ٵ����Ĵ���
              epsilon=3;    %��С����ֵ
        else 
              epsilon=1;
        end
        
        if  strcmp(direction,'up')==1   %����Ѱ��
            P1_D_row=P1_D_row-epsilon;
            P1_A_row=P1_A_row+epsilon;
        else                            %����Ѱ��
            P1_D_row=P1_D_row+epsilon;
            P1_A_row=P1_A_row-epsilon;
        end   
    end
end
       if  strcmp(direction,'up')==1   
             direction='down';
        else                         
             direction='up';
       end
end
ExactPosition=[];
end

