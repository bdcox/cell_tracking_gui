function submit(hObject, eventdata)
data=guidata(hObject);
track_edit=0;
for t=1:size(data.modified_ids,2)
    %  t
    % data.modified_ids{t}
    if numel(data.modified_ids{t})==0
        continue
    end
    
    for id=1:size(data.modified_ids{t},1)
        for sib=1:size(data.modified_ids{t},3)
            if data.modified_ids{t}(id,1,sib)==0
                continue
            else
                %since there may be multiple siblings with the same
                %starting ID, ID will not necessarily equal line of the
                %stats matrix find the line of the matrix that has both the
                %initial cell id and sibling ID you're looking for
                line=intersect(find(data.cell_stats{t}(:,1)==id),find(data.cell_stats{t}(:,2)==sib));
                if numel(line)==0 %if no line number is found, cell hasn't
                    %been tracked before, so create new line
                    line=size(data.cell_stats{t},1)+1;
                elseif numel(line)==1 && data.cell_stats{t}(line,3)>0
                    %if this isn't the first
                    %ID assignment. i.e., if the track is being edited
                    %rather than created OR if cell has been erased
                    % track_edit=1;
                    old_x=data.cell_stats{t}(line,3);
                    old_y=data.cell_stats{t}(line,4);
                    old_z=data.cell_stats{t}(line,5);
                    %erases old dot and number label
                    dot_slice=data.dot_stack{old_z,t};
                    dot_slice(old_y-3:old_y+3,old_x-3:old_x+3)=0;
                    data.dot_stack{old_z,t}=dot_slice(:,:);
                    data.cell_stats{t}(line,10)
                    blank_slice=zeros(size(data.num_stack{old_z,t}));
                    blank_slice=insertText(blank_slice,[old_x,old_y],strcat(num2str(id),'_',num2str(sib)),'TextColor','green','BoxOpacity',0,'FontSize',10);
                    blank_slice=insertText(blank_slice,[data.cell_stats{t}(line,3),data.cell_stats{t}(line,4)+10],strcat('C2: ',num2str(data.cell_stats{t}(line,10))),'TextColor','green','BoxOpacity',0,'FontSize',10);
                    old_num_loc=find(blank_slice(:,:,2));
                    num_slice=data.num_stack{old_z,t};
                    num_slice(old_num_loc)=0;
                    data.num_stack{old_z,t}=num_slice;
                    
                end
                
                if data.modified_ids{t}(id,2,sib)>0 && data.modified_ids{t}(id,2,sib)>0
                    data.cell_stats{t}(line,1)=id;
                    data.cell_stats{t}(line,2)=sib;
                    data.cell_stats{t}(line,3)=data.modified_ids{t}(id,2,sib); %x
                    data.cell_stats{t}(line,4)=data.modified_ids{t}(id,3,sib);%y
                    data.cell_stats{t}(line,5)=data.modified_ids{t}(id,4,sib);%z
                    data.cell_stats{t}(line,10)=data.current_value;
                    
                    
                    for ch=1:3
                        if ch==1
                            if data.r_use==1
                                raw_slice=data.r_stack{data.cell_stats{t}(line,5),t};
                            else
                                continue
                            end
                        elseif ch==2
                            if data.g_use==1
                                raw_slice=data.g_stack{data.cell_stats{t}(line,5),t};
                            else
                                continue
                            end
                        elseif ch==3
                            if data.b_use==1
                                raw_slice=data.b_stack{data.cell_stats{t}(line,5),t};
                            else
                                continue
                            end
                        end
                        %get the 5x5 square with the dot at the center
                        %get intensity values in a circle/dot shape
                        
                        intensity_area=(raw_slice(data.cell_stats{t}(line,4)-2:data.cell_stats{t}(line,4)+2,data.cell_stats{t}(line,3)-2:data.cell_stats{t}(line,3)+2));
                        intensity_vals=intensity_area.*data.marker_sm;
                        nonzero_vals=find(intensity_vals);
                        mean_intensity=mean(intensity_vals(nonzero_vals));
                        
                        %first 5 rows are id, sib, xyz. intensities start at 6
                        data.cell_stats{t}(line,ch+5)=mean_intensity;
                    end
                    
                    num_slice=data.num_stack{data.cell_stats{t}(line,5),t};
                    num_slice=insertText(num_slice,[data.cell_stats{t}(line,3),data.cell_stats{t}(line,4)],strcat(num2str(id),'_',num2str(sib)),'TextColor','green','BoxOpacity',0,'FontSize',10);
                    %edit this if you want to make the category
                    %customizable
                    num_slice=insertText(num_slice,[data.cell_stats{t}(line,3),data.cell_stats{t}(line,4)+10],strcat('C2: ',num2str(data.cell_stats{t}(line,10))),'TextColor','green','BoxOpacity',0,'FontSize',10);
                    data.num_stack{data.cell_stats{t}(line,5),t}=num_slice(:,:,2);
                    
                    dot_slice=data.dot_stack{data.cell_stats{t}(line,5),t};
                    dot_slice(data.cell_stats{t}(line,4)-3:data.cell_stats{t}(line,4)+3,data.cell_stats{t}(line,3)-3:data.cell_stats{t}(line,3)+3)=data.marker*255;
                    % dot_slice=insertText(dot_slice,[floor(data.cell_stats{t}(line,3)),floor(data.cell_stats{t}(line,4))],'o','AnchorPoint','Center','TextColor','blue','BoxOpacity',0,'FontSize',10);
                    data.dot_stack{data.cell_stats{t}(line,5),t}=dot_slice(:,:);
                else %if the x and y values have been set to zero, it is because the
                    %cell was erased. delete the line from the stats
                    data.cell_stats{t}(line,:)=[];
                end
            end
            
        end
    end
    
end
%need to update max cell display if one of the edited cells submitted is a
%new cell

data.modified_ids=[];
guidata(hObject,data);
display_max(hObject);
load_img(hObject);
end
