function rawdisplayselection(hObject,callbackdata)
data=guidata(hObject);
choice=callbackdata.NewValue.String;
data.rawd_switch=choice;

if strfind(choice,'R')
    data.r_raw_disp=1;
else
    data.r_raw_disp=0;
end

if strfind(choice,'G')
    data.g_raw_disp=1;
else
    data.g_raw_disp=0;
end

if strfind(choice,'B')
    data.b_raw_disp=1;
else
    data.b_raw_disp=0;
end

guidata(hObject,data);
load_img(hObject);
end
