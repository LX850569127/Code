
function [Output_Coordinates] = ScreenCoordinatasRegularly(Input_Coordinates,Longtitude_Range,Latitude_Range)
%Function��ɸѡ����Χ�ľ�γ������ 
%Input��1.Input_Coordinates(��ɸѡ������, the first column is longitude, the secend column is latitude.)��2.Longtitude_Range(����ɸѡ��Χ,[min,max])3.Latitude_Range(γ��ɸѡ��Χ[min,max])
%Output��Output_Coordinates(ɸѡ��ɺ������,û����������������ʱ����վ���)

Output_Coordinates=[];

%��ȡָ��γ��
temp=find(Input_Coordinates(:,2)>=Latitude_Range(:,1) & Input_Coordinates(:,2)<=Latitude_Range(:,2));  
if size(temp)~=0
  range_Coordinate=zeros(size(temp,1),size(Input_Coordinates,2));
  for i=1:size(temp,1)
     range_Coordinate(i,:)=Input_Coordinates(temp(i,:),:);
  end 
else
    return
end 

 %��ȡָ������(��Ҫ�ر�ע�ⶫ��������������)
 if (Longtitude_Range(:,2)>180)  %�������Ľ�ֹ���ȴ���180�ȣ�˵����ȡ��Χ������
     longtitude=range_Coordinate(:,1);
     longtitude(longtitude<0)=180+(180-abs(longtitude(longtitude<0)));  %�Ծ��Ƚ��й黯��������Ϊ�������ϵĶ���
     range_Coordinate(:,1)=longtitude;
 end 
 
temp1=find(range_Coordinate(:,1)>=Longtitude_Range(:,1) & range_Coordinate(:,1)<=Longtitude_Range(:,2));  
if size(temp1)~=0
  range_Coordinate1=zeros(size(temp1,1),size(Input_Coordinates,2));
  for i=1:size(temp1,1)
     range_Coordinate1(i,:)=range_Coordinate(temp1(i,:),:);
  end 
  Output_Coordinates=range_Coordinate1;  
end 
end

