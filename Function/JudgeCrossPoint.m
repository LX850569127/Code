function [ cross_data ] = JudgeCrossPoint( ascending_data,descending_data )
%Function���ж��������ݺͽ������ݼ��Ƿ���ڽ����
%Input��ascending_data(��������)��descending_data(��������)
%Output��cross_data(���н���������ͽ�������,ͬһ�е������ṹ��)

index=1;   % counting the number of the combinations of CP

if isfield(ascending_data(1),'correctionPar')
  cross_data = struct('coordinate',[],'flag_AD',[],'orbitNum',[],'correctionPar',[]);
else
  cross_data = struct('coordinate',[],'flag_AD',[],'orbitNum',[]);
end

cross_data=repmat(cross_data,[size(ascending_data,1)*size(descending_data,1) 2]);

for i=1:size(ascending_data,1)
    cor_A=getfield(ascending_data(i),'coordinate');
    AMinX=min(cor_A(:,1));    %����������С����
    AMaxX=max(cor_A(:,1));    %����������󾭶�
    AMinY=min(cor_A(:,2));    %����������Сγ��
    AMaxY=max(cor_A(:,2));    %�����������γ��
    for j=1:size(descending_data,1)
        cor_D=getfield(descending_data(j),'coordinate');
        DMinX=min(cor_D(:,1));    %�½�������С����
        DMaxX=max(cor_D(:,1));    %�½�������󾭶�
        DMinY=min(cor_D(:,2));    %�½�������Сγ��
        DMaxY=max(cor_D(:,2));    %�½��������γ��
                
      %�����ཻ�����
      if  AMinX <= DMaxX && AMaxX >= DMinX && AMinY <= DMaxY && AMaxY >= DMinY
         temp_data=[ascending_data(i,:),descending_data(j,:)];
         cross_data(index,:)=temp_data; %����һ���µĴ洢���������ݵĽṹ��
         index=index+1;
      end 
    end
end

cross_data=cross_data(1:index-1,:);
end



