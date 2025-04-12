function [Pic_Output,energy] =TV_regularization2(Pic_input,AMP,time,scope,target_move)
%全变分正则化图像去噪（TV正则化）
%%%%%%需要考虑判断语句简化写法，然后他们的计算时间有没有优化空间
%%%%%%需要考虑有没有加速算法，回去看文献
%%%%%%裁剪图像，判断数据格式
%输入
% Pic_input:输入图像
% AMP:正则化强度
% time:循环次数
% scope:裁剪范围
%输出
% Pic_output:降噪后图像
% energy:能量

%裁剪
TF=isgpuarray(Pic_input);
[CCD_x,CCD_y]=size(Pic_input);
X=scope(1);
Y=scope(2);
Pic_Output=Pic_input;   %预生成输出,全大小
Pic_input=imcrop(abs(Pic_input),[(CCD_y-Y-target_move(2))/2 (CCD_x-X-target_move(1))/2 Y-1 X-1]);    %裁剪
Pic_output=Pic_input;
if TF %临时转换
    Pic_output=gather(Pic_output);
end

[~,locationXY1]=Spiral_index1(X,Y,1);   %产生螺旋坐标

[~,locationXY2]=Spiral_index1(X,Y,2);


locationXY=locationXY1;  %预生成坐标
% locationXYnext=locationXY2;%下一轮坐标
Top=2*(X+Y)-3;
End=X*Y;
% bottle=[];      %内外旋交换中介

for t=1:time
    
    for i=Top:End

            fx=(Pic_output(locationXY(i,1)+1,locationXY(i,2))-Pic_output(locationXY(i,1),locationXY(i,2)));
            fy=(Pic_output(locationXY(i,1),locationXY(i,2)+1)-Pic_output(locationXY(i,1),locationXY(i,2)-1))/2;
            grad=sqrt(fx^2+fy^2);
            if grad ~=0
                co1=1./grad;
            else
                co1 = grad;
            end

            fx=(Pic_output(locationXY(i,1),locationXY(i,2))-Pic_output(locationXY(i,1)-1,locationXY(i,2)));
            fy=(Pic_output(locationXY(i,1)-1,locationXY(i,2)+1)-Pic_output(locationXY(i,1)-1,locationXY(i,2)-1))/2;
            grad=sqrt(fx^2+fy^2);
            if grad ~=0
                co2=1./grad;
            else
                co2 = grad;
            end

            fx=(Pic_output(locationXY(i,1)+1,locationXY(i,2))-Pic_output(locationXY(i,1)-1,locationXY(i,2)))/2;
            fy=(Pic_output(locationXY(i,1),locationXY(i,2)+1)-Pic_output(locationXY(i,1),locationXY(i,2)));
            grad=sqrt(fx^2+fy^2);
            if grad ~=0
                co3=1./grad;
            else
                co3 = grad;
            end

            fx=(Pic_output(locationXY(i,1)+1,locationXY(i,2)-1)-Pic_output(locationXY(i,1)-1,locationXY(i,2)-1))/2;
            fy=(Pic_output(locationXY(i,1),locationXY(i,2))-Pic_output(locationXY(i,1),locationXY(i,2)-1));
            grad=sqrt(fx^2+fy^2);
            if grad ~=0
                co4=1./grad;
            else
                co4 = grad;
            end
            Pic_output(locationXY(i,1),locationXY(i,2))=(Pic_input(locationXY(i,1),locationXY(i,2))+(1/AMP)*(co1*Pic_output(locationXY(i,1)+1,locationXY(i,2))+co2*Pic_output(locationXY(i,1)-1,locationXY(i,2))+co3*Pic_output(locationXY(i,1),locationXY(i,2)+1)+co4*Pic_output(locationXY(i,1),locationXY(i,2)-1)))*(1/(1+(1/(AMP)*(co1+co2+co3+co4))));
    
    end

    Pic_output(2:end-1,1)=Pic_output(2:end-1,2);    %边缘行边缘列
    Pic_output(2:end-1,end)=Pic_output(2:end-1,end-1);
    Pic_output(1,2:end-1)=Pic_output(2,2:end-1);
    Pic_output(end,2:end-1)=Pic_output(end-1,2:end-1);

    Pic_output(1,1)=Pic_output(2,2);    %四角点
    Pic_output(end,end)=Pic_output(end-1,end-1);
    Pic_output(1,end)=Pic_output(2,end-1);
    Pic_output(end,1)=Pic_output(end-1,2);

    Pic_input=Pic_output;

    % bottle=Top; %交换内外旋转
    % Top=End;
    % End=bottle;
    if mod(t,2)==0
    locationXY=locationXY2; %lo1,lo2不变,lo变lo2
    locationXY2=locationXY1;    %lo2变lo1,lo1变lo2
    locationXY1=locationXY; %交换旋转方向（左？右？）
    end
end
energy=sum(sqrt(diff(Pic_output(2:end,2:end-1),1,1).^2+diff(Pic_output(2:end-1,2:end),1,2).^2)+AMP*(Pic_output(2:end-1,2:end-1)-Pic_input(2:end-1,2:end-1)).^2,"all");

Pic_Output(fix((CCD_x-X-target_move(1))/2)+1:fix((CCD_x-X-target_move(1))/2)+X,fix((CCD_y-Y-target_move(2))/2)+1:fix((CCD_y-Y-target_move(2))/2)+Y)=Pic_output;
if TF %临时转换
    Pic_Output=gpuArray(Pic_Output);
end
end