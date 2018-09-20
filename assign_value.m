%currently not in use. value is assigned at submit function to ensure old
%text of category can be erased accurately. may want to change based on how
%you develop the category tool
function assign_value(hObject,eventdata)
data=guidata(hObject);

line=intersect(find(data.cell_stats{data.val_t}(:,1)==data.current_id),find(data.cell_stats{data.val_t}(:,2)==data.current_sib));
%current cat+8 because first 7 rows are id, location, intensity values
%data.cell_stats{data.val_t}(line,data.current_cat+8)=data.current_value;

guidata(hObject,data);

%load_img(hObject);
end
