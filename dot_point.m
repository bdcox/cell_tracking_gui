function dot_point(hObject, eventdata)
data=guidata(hObject);

set(hObject,'CurrentAxes',data.ax1)

t_val=data.val_t;
z_val=data.val_z;

x_min=min(data.x_zoom);
x_max=max(data.x_zoom);
y_min=min(data.y_zoom);
y_max=max(data.y_zoom);

clear h

h=impoint;
coords=h.getPosition;
x=round(coords(1));
y=round(coords(2));
%adding the lower value of current x and y zooms allows multiple zooms
if data.x_zoom(1)~=1 && data.x_zoom(2)~=size(data.num_stack{1,1},2)
    x=data.x_zoom(1)+x-1;
end

if data.y_zoom(1)~=1 && data.y_zoom(2)~=size(data.num_stack{1,1},1)
    y=data.y_zoom(1)+y-1;
end
data.temp_img=1;
data.temp_t=data.val_t;
data.temp_z=data.val_z;


data.modified_ids{data.val_t}(data.current_id,1:4,data.current_sib)=[data.current_id,x,y,data.val_z];
guidata(hObject,data);

end
