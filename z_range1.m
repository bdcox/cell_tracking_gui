function z_range1(hObject, eventdata)
data=guidata(hObject);

hObject.Type
data.zr1=eventdata.Source.Value;
%first value can't be larger than second
if data.zr2<data.zr1
    data.zr2=data.zr1;
     for chs=1:size(hObject.Parent.Children,1)
        if numel(hObject.Parent.Children(chs).Position)==4
            if hObject.Parent.Children(chs).Position==[259,41,51,18]
                set(hObject.Parent.Children(chs),'Value',data.zr2);
            end
        end
     end
end

end
