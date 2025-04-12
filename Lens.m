function [Lens,NA] = Lens(xx,yy,f,lambda,mod,N)
Lens=exp(-1i*2*pi/lambda/(2*f).*(xx.^2+yy.^2));
if mod==1   %矩形
    NA=(abs(xx)<max(xx,[],"all").*N)&(abs(yy)<max(yy,[],"all").*N);
    Lens=Lens.*NA;

elseif mod==2   %圆形
    NA=sqrt(xx.^2+yy.^2)<(min(max(yy,[],"all"),max(xx,[],"all")).*N);
    Lens=Lens.*NA;
elseif mod==0
    
end
end