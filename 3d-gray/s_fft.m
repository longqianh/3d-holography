function U=s_fft(U0,M,N,lambda,z,xx0,yy0,xx,yy)

% Fresnel Diffraction Integral
% Use single fft to calculate Fresnel diffraction integral
% --------
% INPUT
% --------
% M,N: the number of pixels along, the respective x and y direction of the slm
% lambda: wavelength of the light
% z:distance between the diffracted plane(slm) and the observation plane
% xx0,yy0: points on the diffracted plane
% xx,yy: points on the observation plane
% U0: complex amplitudes on the diffraction screen; [ type: slices*1 cell ]
% --------
% OUTPUT
% --------
% U: complex amplitudes on the observation screen after s-fft

    k=2*pi/lambda;
    U=fft2 ( U0.*( exp(1i*k/2/z*(xx0.^2+yy0.^2)) ) ,N,M ) ;
    U=( exp(1i*k*z) / (1i*lambda*z) * exp(1i*k/2/z*(xx.^2+yy.^2) ) ).*U;
end