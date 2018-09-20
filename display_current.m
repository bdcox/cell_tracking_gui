function display_current(hObject)
data=guidata(hObject);

if strcmp(hObject.Type,'figure')
    for chs=1:size(hObject.Children,1)
        if numel(hObject.Children(chs).Position)==4
            if hObject.Children(chs).Position==[1055,849,40,20]
                %display('run')
                set(hObject.Children(chs),'String',num2str(data.current_id));
            end
        end
    end
elseif strcmp(hObject.Type,'uicontrol') || strcmp(hObject.Type,'uibuttongroup')
    for chs=1:size(hObject.Parent.Children,1)
        if numel(hObject.Parent.Children(chs).Position)==4
            if hObject.Parent.Children(chs).Position==[1055,849,40,20]
                set(hObject.Parent.Children(chs),'String',num2str(data.current_id));
            end
        end
    end
end

guidata(hObject,data);
end
