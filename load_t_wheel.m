function load_t_wheel(hObject, eventdata)
data=guidata(hObject);


if eventdata.VerticalScrollCount==-1 %first two options are for keyboard input
    data.val_t=data.val_t-1;
elseif eventdata.VerticalScrollCount==1
    if data.val_t<data.t_max
        data.val_t=data.val_t+1;
    end
else %last option is for slider selection
    if mod(hObject.Value,1)~=0
        hObject.Value=round(hObject.Value);
    end
    data.val_t=hObject.Value;
end

if data.val_z>data.ct_z_max(data.val_t)
    data.val_z=data.ct_z_max(data.val_t);
    data.zr1=data.val_z;
    data.zr2=data.val_z;
end


for chs=1:size(hObject.Children,1)
    if numel(hObject.Children(chs).Position)==4
        if hObject.Children(chs).Position==[433,42.9,866,18]
            set(hObject.Children(chs),'Value',data.val_z)
            set(hObject.Children(chs),'Max',data.ct_z_max(data.val_t))
            %      set(hObject.Children(chs),'String',num2str(data.val_t));
        end
        if hObject.Children(chs).Position==[207,41,51,18]
            set(hObject.Children(chs),'Value',data.val_z)
            set(hObject.Children(chs),'String',data.range_strs{data.val_t})
            %      set(hObject.Children(chs),'String',num2str(data.val_t));
        end
        if hObject.Children(chs).Position==[259,41,51,18]
            set(hObject.Children(chs),'Value',data.val_z)
            set(hObject.Children(chs),'String',data.range_strs{data.val_t})
            %      set(hObject.Children(chs),'String',num2str(data.val_t));
        end
    end
end
    

if data.display_track==1
    %if you have tracking on, immediately to go the center position in Z
    %of where the cell is. this saves time moving between Z stacks if
    %there's z drift in the stacks
    
    if data.current_id>0
        id_loc=find(data.cell_stats{data.val_t}(:,1)==data.current_id);
        sib_loc=find(data.cell_stats{data.val_t}(:,2)==data.current_sib);
        unique_loc=intersect(id_loc,sib_loc);
        
        if data.cell_stats{data.val_t}(unique_loc,5)>0
            data.val_z=data.cell_stats{data.val_t}(unique_loc,5);
        end
        
        data.zr1=data.val_z;
        data.zr2=data.val_z;
    end
    display_z(hObject);
    
    for chs=1:size(hObject.Children,1)
        if numel(hObject.Children(chs).Position)==4
            if hObject.Children(chs).Position==[433,42.9,866,18]
                set(hObject.Children(chs),'Value',data.val_z)
                %      set(hObject.Children(chs),'String',num2str(data.val_t));
            end
        end
    end
    
end


guidata(hObject,data);
load_img(hObject);
display_t(hObject);
display_z(hObject);

end
