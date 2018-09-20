function save_img(hObject, eventdata, handles)
data=guidata(hObject);
data.val_z=data.val_z;

if ~exist(strcat(data.img_path,'new_stacks\'),'dir')
    mkdir(strcat(data.img_path,'new_stacks\'));
end



if strcmp(data.save_pref,'Save Current Z, T')
    
    header='Cell ID,Sibling Number,X Location,Y Location,Z Location,R Intensity,G Intensity,B Intensity,';
    for idx=9:size(data.cell_stats{data.val_t},2)
        header=strcat(header,'Category ',num2str(idx-8),',');
    end

    dot_name=data.dot_dir(data.val_t).name;
    num_name=data.num_dir(data.val_t).name;
    leading_zeros=numel(num2str(size(data.num_stack,1)))-numel(num2str(data.val_z));
    dot_name=strcat(dot_name(1:strfind(dot_name,'.tif')-1),'_z',strcat(repmat('0',1,leading_zeros),num2str(data.val_z)),'.tif');
    num_name=strcat(num_name(1:strfind(num_name,'.tif')-1),'_z',strcat(repmat('0',1,leading_zeros),num2str(data.val_z)),'.tif');
    imwrite(data.dot_stack{data.val_z,data.val_t},strcat(data.img_path,'new_stacks\',dot_name),'Compression','lzw');
    imwrite(data.num_stack{data.val_z,data.val_t},strcat(data.img_path,'new_stacks\',num_name),'Compression','lzw');
    
    if data.r_use
        r_name=data.r_edit_dir(data.val_t).name;
        r_name=strcat(r_name(1:strfind(r_name,'.tif')-1),'_z',strcat(repmat('0',1,leading_zeros),num2str(data.val_z)),'.tif');
        imwrite(data.r_edit{data.val_z,data.val_t},strcat(data.img_path,'new_stacks\',r_name),'Compression','lzw');
    end
    
    if data.g_use
        g_name=data.g_edit_dir(data.val_t).name;
        g_name=strcat(g_name(1:strfind(g_name,'.tif')-1),'_z',strcat(repmat('0',1,leading_zeros),num2str(data.val_z)),'.tif');
        imwrite(data.g_edit{data.val_z,data.val_t},strcat(data.img_path,'new_stacks\',g_name),'Compression','lzw');
    end
    
    if data.b_use
        b_name=data.b_edit_dir(data.val_t).name;
        b_name=strcat(b_name(1:strfind(b_name,'.tif')-1),'_z',strcat(repmat('0',1,leading_zeros),num2str(data.val_z)),'.tif');
        imwrite(data.b_edit{data.val_z,data.val_t},strcat(data.img_path,'new_stacks\',b_name),'Compression','lzw');
    end
    
    stats_name=strcat(data.img_path,'new_stacks\',data.stats_dir(data.val_t).name);
    fid=fopen(stats_name,'w');
    fprintf(fid,'%s\n',header);
    fclose(fid);
    dlmwrite(stats_name,data.cell_stats{t},'precision',8,'-append');
    
elseif strcmp(data.save_pref,'Save Current T')
    
    header='Cell ID,Sibling Number,X Location,Y Location,Z Location,R Intensity,G Intensity,B Intensity,';
    for idx=9:size(data.cell_stats{data.val_t},2)
        header=strcat(header,'Category ',num2str(idx-8),',');
    end

    
    data.dot_dir(data.val_t).name
    data.img_path
    for z=1:size(data.num_stack,1)
        imwrite(data.dot_stack{z,data.val_t},strcat(data.img_path,'new_stacks\',data.dot_dir(data.val_t).name),'WriteMode','append','Compression','lzw');
        imwrite(data.num_stack{z,data.val_t},strcat(data.img_path,'new_stacks\',data.num_dir(data.val_t).name),'WriteMode','append','Compression','lzw');
        
        if data.r_use
            imwrite(data.r_edit{z,data.val_t},strcat(data.img_path,'new_stacks\',data.r_edit_dir(data.val_t).name),'WriteMode','append','Compression','lzw');
        end
        
        if data.g_use
            imwrite(data.g_edit{z,data.val_t},strcat(data.img_path,'new_stacks\',data.g_edit_dir(data.val_t).name),'WriteMode','append','Compression','lzw');
        end
        
        if data.b_use
            imwrite(data.b_edit{z,data.val_t},strcat(data.img_path,'new_stacks\',data.b_edit_dir(data.val_t).name),'WriteMode','append','Compression','lzw');
        end
        
    end
    
    stats_name=strcat(data.img_path,'new_stacks\',data.dot_dir(data.val_t).name(1:strfind(data.dot_dir(data.val_t).name,'.tif')-1),'_statistics.csv');
    fid=fopen(stats_name,'w');
    fprintf(fid,'%s\n',header);
    fclose(fid);
    dlmwrite(stats_name,data.cell_stats{data.val_t},'precision',8,'-append');
    
elseif strcmp(data.save_pref,'Save All')
    
    for t=1:size(data.num_stack,2)
        t
        
        header='Cell ID,Sibling Number,X Location,Y Location,Z Location,R Intensity,G Intensity,B Intensity,';
        for idx=9:size(data.cell_stats{t},2)
            header=strcat(header,'Category ',num2str(idx-8),',');
        end
    
        for z=1:size(data.num_stack,1)
            
            if size(data.num_stack{z,t},1)>0 %i.e. if slice exists. some stacks may have fewer slices
                imwrite(data.num_stack{z,t},strcat(data.img_path,'new_stacks\',data.num_dir(t).name),'WriteMode','append','Compression','lzw');
                imwrite(data.dot_stack{z,t},strcat(data.img_path,'new_stacks\',data.dot_dir(t).name),'WriteMode','append','Compression','lzw');
                
                if data.r_use
                    imwrite(data.r_edit{z,t},strcat(data.img_path,'new_stacks\',data.r_edit_dir(t).name),'WriteMode','append','Compression','lzw');
                end
                
                if data.g_use
                    imwrite(data.g_edit{z,t},strcat(data.img_path,'new_stacks\',data.g_edit_dir(t).name),'WriteMode','append','Compression','lzw');
                end
                
                if data.b_use
                    imwrite(data.b_edit{z,t},strcat(data.img_path,'new_stacks\',data.b_edit_dir(t).name),'WriteMode','append','Compression','lzw');
                end
                
            end
            stats_name=strcat(data.img_path,'new_stacks\',data.stats_dir(t).name);
            fid=fopen(stats_name,'w');
            fprintf(fid,'%s\n',header);
            fclose(fid);
            dlmwrite(stats_name,data.cell_stats{t},'precision',8,'-append');
            
        end
    end
    dlmwrite(strcat(data.img_path,'cell_lineages.csv'),data.cell_lineages);
end

end
