% function Uf=i_fft(Phase,M,N,lambda,d,xx0,yy0,xx,yy)
% k=2*pi/lambda;
% U0=exp(1i*Phase-pi);
% Fresnel=exp(-1i*k/2/d*(xx.^2+yy.^2));
% f2=U0.*Fresnel;
% Uf=ifft2(f2,N,M);
% phase=exp(-1i*k*d)/(-1i*lambda*d)*exp(-1i*k/2/d*(xx0.^2+yy0.^2));
% Uf=Uf.*phase;
% end

function U0=i_fft(U,M,N,lambda,z,xx0,yy0,xx,yy)
% invert of Single Fast Fourier Transformation
    k=2*pi/lambda;
    G=(1i*lambda*z)*exp(-1i*k*z)*exp(-1i*k/2/z*(xx.^2+yy.^2));
    h=exp(-1i*k/2/z*(xx0.^2+yy0.^2));
    U0=ifft2(fftshift(U.*G),N,M).*h;

end
