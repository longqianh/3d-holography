% ## function: calculate the Fresnel Diffraction Integral
% ### input 
% M,N: SLM length and width (px)
% lambda: wavelength of the light
% z:distance between the diffracted plane(SLM) and the observation plane
% xx0,yy0: points on the diffracted plane
% xx,yy: points on the observation plane
% U0: complex amplitudes on the diffraction screen, seeing as the same

% ### output
% U: complex amplitudes on the observation screen after Fresnel Diffraction Integral



function U = fresnel_int(M,N,lambda,z0,xx0,yy0,xx,yy,U0)
u=xx/(lambda*z0);
v=yy/(lambda*z0);
G=exp(2i*pi*z0/lambda)*exp(-i*lambda*z0*(u^2+v^2));
U=ifft(fft(U0*G));
end
