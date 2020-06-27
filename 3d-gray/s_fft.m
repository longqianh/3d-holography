% ## Single Fast Fourier Transform
% ### input 
% M,N: the number of pixels along, the respective x and y direction of the slm
% lambda: wavelength of the light
% z:distance between the diffracted plane(slm) and the observation plane
% xx0,yy0: points on the diffracted plane
% xx,yy: points on the observation plane
% U0: complex amplitudes on the diffraction screen, seeing as the same

% ### output
% U: complex amplitudes on the observation screen after s-fft


function U=s_fft(M,N,lambda,z,xx0,yy0,xx,yy,U0)
k=2*pi/lambda;
Fresnel=exp(1i*k/2/z*(xx0.^2+yy0.^2));
f2=U0.*Fresnel;
U=fftshift(fft2(f2,N,M));
phase=exp(1i*k*z)/(1i*lambda*z)*exp(1i*k/2/z*(xx.^2+yy.^2));
U=U.*phase;
end