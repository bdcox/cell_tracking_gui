function enter_id(hObject,eventdata)
data=guidata(hObject);
current_id=get(hObject,'string');
%display(['current id is: ',current_id])
data.current_id=str2num(current_id);

if data.current_id>data.current_max
    data.current_max=current_id;
end

guidata(hObject,data);
display_current(hObject)
display_max(hObject)
display_sib(hObject)
end
