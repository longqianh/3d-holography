function [M1, M2] = checkerboard(N,M)
% �����������������̸�,N��,M��
switch nargin
    case 1
        M = N;
    otherwise
end
% �����������������̸�
M1 = zeros(N,M);
M2 = M1;
for n = 1:N
    for m = 1:M;
        if xor(mod(n,2),mod(m,2))
            M1(n,m) = 1; M2(n,m) = 0;
        else
            M1(n,m) = 0; M2(n,m) = 1;
        end
    end
end
