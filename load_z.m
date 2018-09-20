%%%these functions control the sliders
function load_z(hObject, eventdata)
data=guidata(hObject);
if eventdata=='a'%first two options are for keyboard input
    if data.val_z>1 
    data.val_z=data.val_z-1;
    end
elseif eventdata=='d'
    if data.val_z<data.ct_z_max(data.val_t)
    data.val_z=data.val_z+1;
    end
else %last option is for slider selection
    if mod(hObject.Value,1)~=0
        hObject.Value=round(hObject.Value);
    end
    data.val_z=hObject.Value;
end

if data.zr1~=data.val_z
    data.zr1=data.val_z;
end

if data.zr2~=data.val_z
    data.zr2=data.val_z;
end

for chs=1:size(hObject.Children,1)
    if numel(hObject.Children(chs).Position)==4
        if hObject.Children(chs).Position==[433,42.9,866,18]
            set(hObject.Children(chs),'Value',data.val_z)
        end
        if hObject.Children(chs).Position==[207,41,51,18]%popup menu
            set(hObject.Children(chs),'Value',data.val_z)
        end
        if hObject.Children(chs).Position==[259,41,51,18]%popup menu
            set(hObject.Children(chs),'Value',data.val_z)
        end
    end
end

    
guidata(hObject,data);
load_img(hObject);
display_z(hObject);
end
