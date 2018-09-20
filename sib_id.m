function sib_id(hObject,eventdata)
data=guidata(hObject);
sib_id=get(hObject,'string');
data.current_sib=str2num(sib_id);

guidata(hObject,data);
display_sib(hObject);
end
