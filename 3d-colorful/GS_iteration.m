function Retrieved_Phase=GS_iteration(A0,M,N,lambda,z0,xx0,yy0,xx,yy)
% A0: source ampitude
    Phase=rand(N,M)*2*pi;
    while sum(abs(abs(A0)-1),'all')>0.01
        sum(abs(abs(A0)-1),'all')
        U0=A0.*Phase;
        U=s_fft(U0,M,N,lambda,z0,xx0,yy0,xx,yy);
        U1=i_fft(exp(1i.*angle(U)),M,N,lambda,z0,xx0,yy0,xx,yy); % target amplitude = 1
        Phase=angle(U1);
    end
       
    Retrieved_Phase=angle(A0);

end