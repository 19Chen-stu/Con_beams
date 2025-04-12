function [SUP,value] = Df(RE_Pic,SUP,Type,num1,num2,value1,value2,TV)
%TV正则化+迭代边缘软阈值稀疏化
%RE_PicSUP:输入图像
% SUP:支撑约束
% i: 功能选择
% num1:横向筛选速度
% num2:纵向筛选速度
% value1:稀疏化筛选阈值
% value2:正则化筛选阈值
% scope:TV去噪范围
% move:正则化区域移动
%TV2:迭代路径为左右旋螺线，方向为正反旋
        value=mean(abs(RE_Pic(SUP==1)));
        if Type==1
         Point1=find((abs(RE_Pic)<value1*value)&SUP);
         Point2=find(rot90((abs(RE_Pic)<value1*value)&SUP));

         SUP(Point1(1:num1(1)))=0;
         SUP(Point1(end-num1(2):end))=0;
         SUP=imrotate(SUP,90);
         SUP(Point2(1:num2(1)))=0;
         SUP(Point2(end-num2(2):end))=0;
         SUP=imrotate(SUP,-90);

        elseif Type==2
          [RE_Pic,~] =TV_regularization2(abs(RE_Pic),TV.range,TV.time,TV.scope,TV.move);
          SUP=abs(RE_Pic)>=(value2*mean(abs(RE_Pic(SUP==1))));
        end
end