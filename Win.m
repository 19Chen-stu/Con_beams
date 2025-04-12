function [win] = Win(xx,yy,mod,N)

if mod==1   %矩形
    NA=(abs(xx)<max(xx,[],"all").*N)&(abs(yy)<max(yy,[],"all").*N);
    win=NA;

elseif mod==2   %圆形
    NA=sqrt(xx.^2+yy.^2)<(min(max(yy,[],"all"),max(xx,[],"all")).*N);
    win=NA;
    elseif mod==3   %十字沟道
    NA=(abs(xx)<max(xx,[],"all").*N)|(abs(yy)<max(yy,[],"all").*N);
    win=NA;
elseif mod==0
    win=ones(size(xx));
end
end