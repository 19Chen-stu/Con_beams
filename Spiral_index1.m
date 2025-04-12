function [location,locationXY] = Spiral_index1(X,Y,type)
%给定矩阵参数，生成螺旋索引地址
%X、Y:给定矩阵参数
%type：正旋和反旋
%坐标点不用矩阵描述的原因是每次只读写矩阵的一部分，矩阵较大影响速度

%预生成,坐标位置
location=zeros(X,Y);
locationXY=zeros(X*Y,2);

%方向向量
direction1=[0,1;1,0;0,-1;-1,0];
direction2=[1,0;0,1;-1,0;0,-1];
%装填方向向量
direction=[];
%当前位置
locationNowX=1;
locationNowY=1;
%第一方向
directionNow=1;
%旋转方向
if type==1
    direction=direction1;
elseif type==2
    direction=direction2;
end
%迭代
for i=1:X*Y
    location(locationNowX,locationNowY)=i;
    locationXY(i,:)=[locationNowX,locationNowY];    %影响速度随着矩阵的维度增加而明显
    locationNextX=locationNowX+direction(directionNow,1);
    locationNextY=locationNowY+direction(directionNow,2);

    if (locationNextX<=X&&locationNextX>0)&&(locationNextY<=Y&&locationNextY>0)&&location(locationNextX,locationNextY)==0 %在不在里边
        locationNowX=locationNextX;
        locationNowY=locationNextY;
    else
        directionNow=mod(directionNow,4)+1;
        locationNowX=locationNowX+direction(directionNow,1);
        locationNowY=locationNowY+direction(directionNow,2);
    end
    
end



end