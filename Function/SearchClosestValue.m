function [ indexOfRow ] = SearchClosestValue(array,reference)
%Function:Ѱ����������ӽ��ο�ֵ�������ڵ���
%Input:����(array)���ο�ֵ(reference)
%Output:indexOfRow(��ӽ���γ��ֵ���ڵ���)

difference=array-reference;       %��ֵ
minValue=min(abs(difference));    %��ֵ����Сֵ
indexOfRow=find(minValue==abs(difference));  %��ֵ����Сֵ���ڵ���
end

