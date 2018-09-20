function segdisplayselection(hObject,callbackdata)
data=guidata(hObject);
choice=callbackdata.NewValue.String;
data.editd_switch=choice;

if strfind(choice,'R')
    data.r_edit_disp=1;
else
    data.r_edit_disp=0;
end

if strfind(choice,'G')
    data.g_edit_disp=1;
else
    data.g_edit_disp=0;
end

if strfind(choice,'B')
    data.b_edit_disp=1;
else
    data.b_edit_disp=0;
end


guidata(hObject,data);
load_img(hObject);
end
