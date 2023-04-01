function [ CrossOverPointOutput ] = PrecisePositionOfCrossOver( Ascending_data,Descending_data,AdjustBoundary,bof_flag)
%Function�����໥�����������֮��Ľ����ľ�ȷλ���Լ�������ͬʱ��ĸ߳�ֵ
%Input��ascending_data(��������)��Descending_data(��������)
% bof_flag �Ƿ�ʹ��ƽ���ĸ�������
%Output��CrossOverPoint(������λ���Լ�������ͬʱ��ĸ߳�ֵ)

%% һ�������λ��
cor_A=Ascending_data.coordinate;
cor_D=Descending_data.coordinate;
coefficient=[];           %��ϵõ��Ķ������ߵ�ϵ��

%�������
cor=Ascending_data.coordinate;
cor=cor(:,1:2);
xA=cor(:,2);    %γ��
yA=cor(:,1);    %����
p=polyfit(xA,yA,2);
yA=p(1).*xA.*xA+p(2).*xA+p(3);  %��Ϻ�ľ���
coefficient=[coefficient;p];

%�������
cor=Descending_data.coordinate;
cor=cor(:,1:2);
xD=cor(:,2);    %γ��
yD=cor(:,1);    %����

p=polyfit(xD,yD,2);
yD=p(1).*xD.*xD+p(2).*xD+p(3);  %��Ϻ�ľ���
coefficient=[coefficient;p];

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
%������λ������Ϊ���߹��̵��µĴ���⣬ͨ���õ����������γ�Ȳ�����޳�
min1=min(abs(cor_A(:,2)-CursoryCrossPoint(2)))+min(abs(cor_D(:,2)-CursoryCrossPoint(2)));
if min1>0.1  %γ�Ȳ����Сֵ
    CrossOverPointOutput=[];
    return;
end

%% ������ȷλ��

CrossOverPoint= AMT(cor_A,cor_D,CursoryCrossPoint,AdjustBoundary);

if isempty(CrossOverPoint)
    CrossOverPointOutput=[];
    return;
end 

%% �����󽻲��������߳��Լ���Ӧ��ʱ��

% ���Բ�ֵ 
 
    x=CrossOverPoint(1);  %longitude of the crossover 
    y=CrossOverPoint(2);  %latitude of the crossover 

    ind=find(cor_A(:,2)>=y);
    Top_Cor_A=cor_A(ind,:);       %�Ϸ������������
    ind=find(cor_A(:,2)<y);
    Bot_Cor_A=cor_A(ind,:);       %�·������������

    ind=find(cor_D(:,2)>=y);
    Top_Cor_D=cor_D(ind,:);       %�Ϸ������н����
    ind=find(cor_D(:,2)<y);
    Bot_Cor_D=cor_D(ind,:);       %�·������н���� 
    
    f=pi/180*6371.393;
    [dis1,row1]=min(distance([y,x],[Top_Cor_A(:,2),Top_Cor_A(:,1)]));
    [dis2,row2]=min(distance([y,x],[Bot_Cor_A(:,2),Bot_Cor_A(:,1)]));
    [dis3,row3]=min(distance([y,x],[Top_Cor_D(:,2),Top_Cor_D(:,1)]));
    [dis4,row4]=min(distance([y,x],[Bot_Cor_D(:,2),Bot_Cor_D(:,1)]));  
      
    A1=[Top_Cor_A(row1,:),dis1*f];
    A2=[Bot_Cor_A(row2,:),dis2*f];
    B1=[Top_Cor_D(row3,:),dis3*f];
    B2=[Bot_Cor_D(row4,:),dis4*f];
    
    A=[A1;A2];
    B=[B1;B2]; 

%     A( A(:,3)>2000| A(:,3)<-55.5|A(:,5)>2,:)=[];
%     B( B(:,3)>2000| B(:,3)<-55.5|B(:,5)>2,:)=[];
   
    A( A(:,5)>2,:)=[];
    B( B(:,5)>2,:)=[];
    
    if isempty(A)||isempty(B)
        CrossOverPointOutput=[];
        return;
    end
    
    PDOP=mean([ A(:,5);B(:,5)]);   %λ��ƫ��
    
    % �����ֵ
    if size(A,1)>1
        altitude_A=A1(3)+(A2(3)-A1(3))*(y-A1(2))/(A2(2)-A1(2));   %����γ��
    else
        altitude_A=A(3);  %Ψһֵ
    end
    
    % �����ֵ
     if size(B,1)>1
        altitude_D=B1(3)+(B2(3)-B1(3))*(y-B1(2))/(B2(2)-B1(2));   %����γ��
     else
        altitude_D=B(3);  %Ψһֵ
     end    
    
    %ʱ����ȡһ�����ɣ�������֮���ʱ����Ϊ0.1s
    
    time_A=A(1,4);
    time_D=B(1,4);   
    
     % caculating the correction value based on �������ƽ��  
     
    if strcmp(bof_flag,'AA')
        par=Ascending_data.correctionPar;   % parameters of the error model 
        sizeOfPar=size(par,2);
        s_t=min(cor_A(:,4));
        e_t=max(cor_A(:,4));
        d_t=time_A-s_t;
        w=2*pi/(e_t-s_t);
        if ~isempty(par)
            switch sizeOfPar
                case 1
                    ft_a=par;
                case 2
                    ft_a=par(1)+par(2)*d_t;
                case 4
                    ft_a=par(1)+par(2)*d_t+par(3)*cos(w*d_t)+par(4)*sin(w*d_t);
                case 6 
                    ft_a=par(1)+par(2)*d_t+par(3)*cos(w*d_t)+par(4)*sin(w*d_t)...
                       +par(5)*cos(2*w*d_t)+par(6)*sin(2*w*d_t);
                case 8
                    ft_a=par(1)+par(2)*d_t+par(3)*cos(w*d_t)+par(4)*sin(w*d_t)...
                       +par(5)*cos(2*w*d_t)+par(6)*sin(2*w*d_t)...
                       +par(7)*cos(3*w*d_t)+par(8)*sin(3*w*d_t);
            end
            altitude_A=altitude_A-ft_a;
        end

        par=Descending_data.correctionPar;   % parameters of the error model 
        sizeOfPar=size(par,2);
        s_t=min(cor_D(:,4));
        e_t=max(cor_D(:,4));
        d_t=time_D-s_t;
        w=2*pi/(e_t-s_t);
        if ~isempty(par)
            switch sizeOfPar
                case 1
                    ft_d=par;
                case 2
                    ft_d=par(1)+par(2)*d_t;
                case 4
                    ft_d=par(1)+par(2)*d_t+par(3)*cos(w*d_t)+par(4)*sin(w*d_t);
                case 6 
                    ft_d=par(1)+par(2)*d_t+par(3)*cos(w*d_t)+par(4)*sin(w*d_t)...
                       +par(5)*cos(2*w*d_t)+par(6)*sin(2*w*d_t);
                case 8
                    ft_d=par(1)+par(2)*d_t+par(3)*cos(w*d_t)+par(4)*sin(w*d_t)...
                       +par(5)*cos(2*w*d_t)+par(6)*sin(2*w*d_t)...
                       +par(7)*cos(3*w*d_t)+par(8)*sin(3*w*d_t);
            end
            altitude_D=altitude_D-ft_d;
        end
    end
    
%% �ġ��������
% ���� ���ƽ����ľ�ȷλ��
% Ϊ����Ƚ� �����γɽ��������������뽵������ 
orbitNum_A=Ascending_data.orbitNum;    %��������
orbitNum_D=Descending_data.orbitNum;   %��������

CrossOverPointOutput= struct('coordinate',CrossOverPoint, 'orbitNum_A',orbitNum_A, 'orbitNum_D',orbitNum_D,...
'altitude_A',altitude_A,'altitude_D',altitude_D,'time_A',time_A,'time_D',time_D,...
  'PDOP',PDOP); 

end

