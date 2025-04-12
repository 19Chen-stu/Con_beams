function [Uout] = Angular_diffraction(Uin,fxx,fyy,z,lambda)
H=exp(1i*2*pi*1*z*sqrt((1/lambda)^2-fxx.^2-fyy.^2));
Uout=ifft2(fft2(Uin).*H);
end