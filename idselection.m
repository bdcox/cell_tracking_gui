function idselection(hObject,callbackdata)
data=guidata(hObject);
id_choice=callbackdata.NewValue.String;
if strcmp(id_choice,'IDs On')
    data.display_ids=1;
elseif strcmp(id_choice,'IDs Off')
    data.display_ids=0;
end
guidata(hObject,data);
load_img(hObject)
end
