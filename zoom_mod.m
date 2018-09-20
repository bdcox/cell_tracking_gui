function zoom_mod(hObject, eventdata)
data=guidata(hObject);
axes(data.ax1)
w=size(data.num_stack{1,1},2);
h=size(data.num_stack{1,1},1);

x_rat=h/w;
x_mod=30;
y_mod=round(x_rat*x_mod);

%these modifiers allow you to keep changing the zoom even if the zoom
%location is close to one of the axis extremes
y_diff1=y_mod-data.y_zoom(1)+1;
y_diff2=y_mod+data.y_zoom(2)-size(data.num_stack{data.val_z,data.val_t},1);
x_diff1=x_mod-data.x_zoom(1)+1;
x_diff2=x_mod+data.x_zoom(2)-size(data.num_stack{data.val_z,data.val_t},2);
%eventdata

if strcmp(eventdata,'hyphen')
    %zoom out slightly
    if data.x_zoom(1)>x_mod && data.x_zoom(2)<(size(data.num_stack{data.val_z,data.val_t},2)-x_mod) && data.y_zoom(1)>y_mod && data.y_zoom(2)<(size(data.num_stack{data.val_z,data.val_t},1)-y_mod)
        x(1)=data.x_zoom(1)-x_mod;
        x(2)=data.x_zoom(2)+x_mod;
        y(1)=data.y_zoom(1)-y_mod;
        y(2)=data.y_zoom(2)+y_mod;
        data.x_zoom=x;
        data.y_zoom=y;
    elseif data.x_zoom(1)>x_mod && data.x_zoom(2)<(size(data.num_stack{data.val_z,data.val_t},2)-x_mod) && data.y_zoom(1)<=y_mod && data.y_zoom(2)<(size(data.num_stack{data.val_z,data.val_t},1)-(y_mod+y_diff1))
        x(1)=data.x_zoom(1)-x_mod;
        x(2)=data.x_zoom(2)+x_mod;
        y(1)=1;
        y(2)=data.y_zoom(2)+y_mod+y_diff1;
        data.x_zoom=x;
        data.y_zoom=y;
    elseif data.x_zoom(1)>x_mod && data.x_zoom(2)<(size(data.num_stack{data.val_z,data.val_t},2)-x_mod) && data.y_zoom(1)>y_mod+y_diff2 && data.y_zoom(2)>=(size(data.num_stack{data.val_z,data.val_t},1)-y_mod)
        x(1)=data.x_zoom(1)-x_mod;
        x(2)=data.x_zoom(2)+x_mod;
        y(1)=data.y_zoom(1)-y_mod-y_diff2;
        y(2)=size(data.num_stack{data.val_z,data.val_t},1);
        data.x_zoom=x;
        data.y_zoom=y;
    elseif data.x_zoom(1)<=x_mod && data.x_zoom(2)<(size(data.num_stack{data.val_z,data.val_t},2)-x_mod) && data.y_zoom(1)>y_mod && data.y_zoom(2)<(size(data.num_stack{data.val_z,data.val_t},1)-y_mod)
        x(1)=1;
        x(2)=data.x_zoom(2)+x_mod+x_diff1;
        y(1)=data.y_zoom(1)-y_mod;
        y(2)=data.y_zoom(2)+y_mod;
        data.x_zoom=x;
        data.y_zoom=y;
    elseif data.x_zoom(1)>x_mod && data.x_zoom(2)>=(size(data.num_stack{data.val_z,data.val_t},2)-x_mod) && data.y_zoom(1)>y_mod+x_diff2 && data.y_zoom(2)<(size(data.num_stack{data.val_z,data.val_t},1)-y_mod)
        x(1)=data.x_zoom(1)-x_mod-x_diff2;
        x(2)=size(data.num_stack{data.val_z,data.val_t},2);
        y(1)=data.y_zoom(1)-y_mod;
        y(2)=data.y_zoom(2)+y_mod;
        data.x_zoom=x;
        data.y_zoom=y;
    end
   
end

%eventdata
if strcmp(eventdata,'equal') %zoom in slightly
    if data.x_zoom(1)+x_mod<=data.x_zoom(2)-x_mod && data.y_zoom(1)+y_mod<=data.y_zoom(2)-y_mod
        x(1)=data.x_zoom(1)+x_mod;
        x(2)=data.x_zoom(2)-x_mod;
        y(1)=data.y_zoom(1)+y_mod;
        y(2)=data.y_zoom(2)-y_mod;
        data.x_zoom=x;
        data.y_zoom=y;
    end
    
end

guidata(hObject,data);
load_img(hObject);
end
