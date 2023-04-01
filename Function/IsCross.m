function [ res ] = IsCross(A1,A2,B1,B2)
%Function���ж�P1,P2���㹹�ɵ��߶κ�Q1��Q2���㹹�ɵ��߶��Ƿ���ڽ���
%Input��P1��P2��Q1��Q2�ĵ������[x,y]��
%Output��res,���ڽ��������1�������ڽ��������0
res=0;
A1A2=A2-A1; A1B2=B2-A1; A1B1=B1-A1;
A1A2(:,3) = 0; A1B2(:,3) = 0; A1B1(:,3) = 0;  %�����Ƕ�άƽ�棬��������Z��0
cross_product1 = cross(A1A2,A1B2);cross_product2 = cross(A1A2,A1B1);

if cross_product1(3)*cross_product2(3)<=0        %����ķ����෴,˵��B1B2����ֱ��A1A2���࣬����0���ж˵�λ��A1A2�߶��ϵ����
    B1B2=B2-B1; B1A2=A2-B1; B1A1=A1-B1;
    B1B2(:,3) = 0; B1A2(:,3) = 0; B1A1(:,3) = 0;  %������ƽ�棬��������Z��0
    cross_product3 = cross(B1B2,B1A2);cross_product4 = cross(B1B2,B1A1);
    if cross_product3(3)*cross_product4(3)<=0  
        res=1;
    end   
end
end

