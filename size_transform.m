function [obj_x,obj_y] = size_transform(ps,obj,target_ps)
%制作为尺度转换，为了适应高低频分量，满足约束相位规则
% ps:输入分辨率
%obj:输入物体尺度参数
%obj_x:转换后x轴
%obj_y:转换后y轴
system_ps=target_ps;  %设定系统参数        
r=system_ps/ps;
obj_x=obj(1)*r;
obj_y=obj(2)*r;
end