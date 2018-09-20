function next_cell(hObject, eventdata, handles)
global all_nuc_max all_mem_max
data=guidata(hObject);

if strcmp(data.def_edit_method,'Next Available')

    data.current_id=data.current_id+1;
    if data.current_id>data.current_max
        data.current_max=data.current_id;
    end


elseif strcmp(data.def_edit_method,'Current Tracked')

    data.current_id=data.current_max+1;
        if data.current_id>data.current_max
        data.current_max=data.current_id;
    end
end
guidata(hObject,data);
display_current(hObject)
display_max(hObject)
end
