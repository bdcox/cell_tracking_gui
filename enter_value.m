function enter_value(hObject,eventdata)
data=guidata(hObject);
current_value=get(hObject,'string');
%display(['current id is: ',current_id])
data.current_value=str2num(current_value);

guidata(hObject,data);
end
