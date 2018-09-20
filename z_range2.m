function z_range2(hObject, eventdata)
data=guidata(hObject);

data.zr2=eventdata.Source.Value;

%first value can't be greater than second for start:end of stack
if data.zr1>data.zr2
    data.zr1=data.zr2;
     for chs=1:size(hObject.Parent.Children,1)
        if numel(hObject.Parent.Children(chs).Position)==4
            if hObject.Parent.Children(chs).Position==[207,41,51,18]
                set(hObject.Parent.Children(chs),'Value',data.zr1);
            end
        end
     end
end


guidata(hObject,data);
load_img(hObject);
display_t(hObject);
display_z(hObject);
end
