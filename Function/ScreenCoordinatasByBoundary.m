function [ OutputTrackInfo ] = ScreenCoordinatasByBoundary(InputTrackInfo,Boundary)
%Function��ɸѡ��λ�ڲ�����߽��ڵ�����
%Input��1��InputTrackInfo(��ɸѡ�Ĺ������)2��Boundary(�߽�ľ�γ�����ݣ���һλΪ���ȣ��ڶ�λΪγ��)
%Output��OutputTrackInfo(ɸѡ��Ĺ������)

OutputTrackInfo=[];  %�������ɸѡ�������ݣ�ÿ�д���һ������Ľ�ȡ����  

 h = waitbar(0,'Please wait...');    
for i=1:size(InputTrackInfo,1)
   s=sprintf('Simulation in process:%d',i);
     waitbar(i/size(InputTrackInfo,1),h,s );
  % computation here %
            
neededCor=[];
temp=InputTrackInfo(i);
cor=getfield(temp,'coordinate');   

% hold on;
% plot(cor(:,1),cor(:,2));

rectangleCor=ScreenCoordinatasRegularly(cor,[166,199.7],[-82.6,-78.75]);
if (size(rectangleCor)~=0)
logc1 = ismember(cor,rectangleCor,'rows')
index=find(logc1==1);
cor(index,:)=[];
end
longtitude=cor(:,1);      %�ù�����еľ�������
latitude=cor(:,2);        %�ù�����е�γ������
height=cor(:,3);
time=cor(:,4);
%%
  for  j=1:size(longtitude)       %����ж��Ƿ�λ�ڱ߽��ڣ������ڱ߽��ڵĵ�
    %Ϊ�����ӳ����ִ���ٶȣ����ж��Ƿ��ھ��ο���
%       if(longtitude(j)>=166&&longtitude(j)<=199.7&&latitude(j)>=-82.6&&latitude(j)<=-78.75)
%            neededCor=[neededCor;longtitude(j),latitude(j),height(j),time(j)];   %������ɸѡ��ͬһ���������
%       else 

        [in,on]= inpolygon(longtitude(j),latitude(j),Boundary(:,1),Boundary(:,2));
        if (in==1||on==1)
        neededCor=[neededCor;longtitude(j),latitude(j),height(j),time(j)];   %������ɸѡ��ͬһ���������
        end
        
%       end
  end 
%%  
  if (size(neededCor)~=0|size(rectangleCor)~=0)
      neededCor=[neededCor;rectangleCor];
      neededCor=sortrows(neededCor,4); %��ʱ������������ٱ���
    trackInfo = struct('coordinate',neededCor);
    OutputTrackInfo=[OutputTrackInfo;trackInfo];
  end 
      %�жϳ����ִ���ٶ�
end


