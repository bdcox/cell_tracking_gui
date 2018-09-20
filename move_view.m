function move_view(hObject,eventdata)
data=guidata(hObject);

if eventdata=='k'
    if data.y_zoom(2)+30<=data.y_size
        data.y_zoom=[data.y_zoom(1)+30 data.y_zoom(2)+30];
    else
        movement=data.y_size-data.y_zoom(2);
        data.y_zoom=[data.y_zoom(1)+movement data.y_zoom(2)+movement];
    end
end
if eventdata=='i'
    if data.y_zoom(1)-30>=1
        data.y_zoom=[data.y_zoom(1)-30 data.y_zoom(2)-30];
    else
        movement=data.y_zoom(1)-1;
        data.y_zoom=[data.y_zoom(1)-movement data.y_zoom(2)-movement];
    end
end
if eventdata=='j'
    if data.x_zoom(1)-30>=1
        data.x_zoom=[data.x_zoom(1)-30 data.x_zoom(2)-30];
    else
        movement=data.x_zoom(1)-1;
        data.x_zoom=[data.x_zoom(1)-movement data.x_zoom(2)-movement];
    end
end
if eventdata== 'l'
    if data.x_zoom(2)+30<=data.x_size
        data.x_zoom=[data.x_zoom(1)+30 data.x_zoom(2)+30];
    else
        movement=data.x_size-data.x_zoom(2);
        data.x_zoom=[data.x_zoom(1)+movement data.x_zoom(2)+movement];
    end
end
guidata(hObject,data);
load_img(hObject);
end
