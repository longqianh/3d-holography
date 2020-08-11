function U0=i_fft(U,M,N,lambda,z,xx0,yy0,xx,yy)

% Invert of Fresnel Diffraction Integral
% --------
% INPUT
% --------
% M,N: the number of pixels along, the respective x and y direction of the slm
% lambda: wavelength of the light
% z:distance between the diffracted plane(slm) and the observation plane
% xx0,yy0: points on the diffracted plane
% xx,yy: points on the observation plane
% U: complex amplitudes on the observation screen after Fresnel diffraction
% integral
% --------
% OUTPUT
% --------
% U0: complex amplitudes on the diffraction screen


    k=2*pi/lambda;
    G=(1i*lambda*z)*exp(-1i*k*z)*exp(-1i*k/2/z*(xx.^2+yy.^2));
    U0=ifft2(U.*G,N,M) .* ( exp(-1i*k/2/z*(xx0.^2+yy0.^2)));

end
