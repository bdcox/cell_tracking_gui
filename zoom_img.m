function zoom_img(hObject, eventdata)
data=guidata(hObject);
axes(data.ax1)
w=size(data.num_stack{1,1},2);
h=size(data.num_stack{1,1},1);

[x y P]=impixel;

%adding the lower value of current x and y zooms allows multiple zooms
if data.x_zoom(1)~=1 && data.x_zoom(2)~=size(data.num_stack{1,1},2) %only runs if not the first time zooming
    x_new(1)=data.x_zoom(1)+min(x)-1;
    x_new(2)=data.x_zoom(1)+min(x)+max(x)-1;
    x=x_new;
end
x_range=abs(x(2)-x(1));
x_rat=x_range/w;
if data.y_zoom(1)~=1 && data.y_zoom(2)~=size(data.num_stack{1,1},1)
    y_new(1)=data.y_zoom(1)+min(y)-1;
    y_new(2)=data.y_zoom(1)+min(y)+max(y)-1;
    y=y_new;
end
y_range=abs(y(2)-y(1));
y_rat=y_range/h;

if min(x)<0 || min(y)<0 || max(x) > size(data.num_stack{1,1},2) || max(y) > size(data.num_stack{1,1},1)
    fprintf('Improper coordinates. Please select new coordinates.\n')
    return
end

if x_rat<y_rat %makes the zoom window have the same aspect ratio as the original image
    data.x_zoom=x;
    new_y=[min(y) min(y)+floor(x_rat*h)];
    data.y_zoom=new_y;
else
    new_x=[min(x) min(x)+floor(y_rat*w)];
    data.x_zoom=new_x;
    data.y_zoom=y;
end

guidata(hObject,data);
load_img(hObject);
end
