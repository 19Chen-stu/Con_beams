function [xx,yy,xita,r,fxx,fyy] = C_parameter(N,Long)
ps=Long/N;
x=ps.*[-N/2:N/2-1];
[xx,yy]=meshgrid(x,x);
fx=1/Long.*[-N/2:N/2-1];
[fxx,fyy]=meshgrid(fx,fx);
fxx=ifftshift(fxx);
fyy=ifftshift(fyy);
[xita,r]=cart2pol(xx,yy);
end