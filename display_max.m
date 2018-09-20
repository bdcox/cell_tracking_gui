function display_max(hObject)
data=guidata(hObject);

found=0;
if strcmp(hObject.Type,'figure')
    for chs=1:size(hObject.Children,1)
    if numel(hObject.Children(chs).Position)==4
        if hObject.Children(chs).Position==[1055,869,40,20]
            set(hObject.Children(chs),'String',num2str(data.current_max));
            found=1;
        end
    end
    end
elseif strcmp(hObject.Type,'uicontrol')
    for chs=1:size(hObject.Parent.Children,1)
        if numel(hObject.Parent.Children(chs).Position)==4
            if hObject.Parent.Children(chs).Position==[1055,869,40,20]
                set(hObject.Parent.Children(chs),'String',num2str(data.current_max));
                found=1;
            end
        end
    end
end

if found==0
    fprintf('object not found \n')
end
guidata(hObject,data);
end
