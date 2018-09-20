function enter_cat(hObject,eventdata)
data=guidata(hObject);
current_cat=get(hObject,'string');
%display(['current id is: ',current_id])
data.current_cat=str2num(current_cat);

guidata(hObject,data);
end
