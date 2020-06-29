function Uf=i_fft(M,N,lambda,d,xx0,yy0,xx,yy,Phase)
k=2*pi/lambda;
U0=exp(1i*Phase-pi);
Fresnel=exp(-1i*k/2/d*(xx.^2+yy.^2));
f2=U0.*Fresnel;
Uf=ifft2(f2,N,M);
phase=exp(-1i*k*d)/(-1i*lambda*d)*exp(-1i*k/2/d*(xx0.^2+yy0.^2));
Uf=Uf.*phase;
end
