function dis  = SphereDist(P1,P2,R)
%��������ľ�γ�ȼ����Բ����(�����������ҹ�ʽ)
%P1ΪA��[����, γ��], P2ΪB��[����, γ��]
if nargin < 3
    R = 6371.393;
end
dis=distance(P2(2),P2(1),P1(2),P1(1))*pi/180*R;
end