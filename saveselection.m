%%%for the radio button selection functions

function saveselection(hObject,callbackdata)
data=guidata(hObject);
data.save_pref=callbackdata.NewValue.String;
guidata(hObject,data);
end
