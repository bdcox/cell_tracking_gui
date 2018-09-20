function [r_stack,g_stack,b_stack,num_stack,dot_stack,r_edit,g_edit,b_edit,cell_stats,r_use,g_use,b_use]=gui_input(hObject);
%%import uncompressed and compressed versions
%all_tracks=csvread(strcat(img_path,'all_tracks.csv'));
data=guidata(hObject);

data.base_dir=[];

if isempty(data.r_suffix)
    r_use=0;
    r_stack={};
    r_edit={};
else
    data.r_dir=dir(strcat(data.img_path,'*',data.r_suffix,'.tif'));
    data.r_edit_dir=dir(strcat(data.img_path,'*r_edit.tif'));
    r_use=1;
    data.base_dir=data.r_dir;
    %base dir will be used for getting file name prefixes, z max, t max,
    %etc.
end

if isempty(data.g_suffix)
    g_use=0;
    g_stack={};
    g_edit={};
else
    data.g_dir=dir(strcat(data.img_path,'*',data.g_suffix,'.tif'));
    data.g_edit_dir=dir(strcat(data.img_path,'*g_edit.tif'));
    g_use=1;
    if isempty(data.base_dir)
        data.base_dir=data.g_dir;
    end
    %base dir will be used for getting file name prefixes, z max, t max,
    %etc.
end

if isempty(data.b_suffix)
    b_use=0;
    b_stack={};
    b_edit={};
else
    data.b_dir=dir(strcat(data.img_path,'*',data.b_suffix,'.tif'));
    data.b_edit_dir=dir(strcat(data.img_path,'*b_edit.tif'));
    b_use=1;
    if isempty(data.base_dir)
        data.base_dir=data.b_dir;
    end
    %base dir will be used for getting file name prefixes, z max, t max,
    %etc.
end

data.num_dir=dir(strcat(data.img_path,'*numbered_cells.tif'));
data.dot_dir=dir(strcat(data.img_path,'*dot_cells.tif'));
data.stats_dir=dir(strcat(data.img_path,'*statistics.csv'));
t_max=numel(data.base_dir);


if numel(data.num_dir)==0 %if number, dot, and stats files don't exist, make them
    fprintf('creating masks\n')
    slice=uint8(imread(strcat(data.img_path,data.base_dir(1).name),1));
    header='Cell ID,Sibling Number,X Location,Y Location,Z Location,R Intensity,G Intensity,B Intensity,Category 1';
    
    for t=1:t_max
        t
        z_max=numel(imfinfo(strcat(data.img_path,data.base_dir(t).name)));
        base_name=data.base_dir(t).name;
        num_name=strcat(base_name(1:strfind(base_name,'_ch')-1),'_numbered_cells.tif');
        dot_name=strcat(base_name(1:strfind(base_name,'_ch')-1),'_dot_cells.tif');
        stats_name=strcat(base_name(1:strfind(base_name,'_ch')-1),'_statistics.csv');
        
        if r_use
        r_edit_name=strcat(base_name(1:strfind(base_name,'_ch')-1),'_r_edit.tif');
        end
        
        if g_use
        g_edit_name=strcat(base_name(1:strfind(base_name,'_ch')-1),'_g_edit.tif');
        end
        
        if b_use
        b_edit_name=strcat(base_name(1:strfind(base_name,'_ch')-1),'_b_edit.tif');
        end
        
        for z=1:z_max
           num_stack{z,t}=uint8(zeros(size(slice)));
            imwrite(num_stack{z,t},strcat(data.img_path,num_name),'WriteMode','append','Compression','lzw');
            dot_stack{z,t}=uint8(zeros(size(slice)));
            imwrite(dot_stack{z,t},strcat(data.img_path,dot_name),'WriteMode','append','Compression','lzw');
            
            if r_use
                r_edit{z,t}=uint8(zeros(size(slice)));
                imwrite(r_edit{z,t},strcat(data.img_path,r_edit_name),'WriteMode','append','Compression','lzw');
            end
            
            if g_use
                g_edit{z,t}=uint8(zeros(size(slice)));
                imwrite(g_edit{z,t},strcat(data.img_path,g_edit_name),'WriteMode','append','Compression','lzw');
            end
            
            if b_use
                b_edit{z,t}=uint8(zeros(size(slice)));
                imwrite(b_edit{z,t},strcat(data.img_path,b_edit_name),'WriteMode','append','Compression','lzw');
            end
            
        end
        %make a blank line to start out with
        cell_stats{t}(1,1:2)=1;
        cell_stats{t}(1,3:9)=0;
        
        %open file to write header
        fid=fopen(strcat(data.img_path,stats_name),'w');
        fprintf(fid,'%s\n',header);
        fclose(fid);
        
        dlmwrite(strcat(data.img_path,stats_name),cell_stats{t},'precision',8,'-append');
    end
    
else %if they do exist, read them in
    fprintf('reading in previously saved files\n')

    for t=1:t_max
        t
        cell_stats{t}=csvread(strcat(data.img_path,data.stats_dir(t).name),1,0);
        
        if size(cell_stats{t},2)<11
            num_cols=size(cell_stats{t},2);
            cell_stats{t}(:,num_cols+1:11)=0;
        end
        z_max=numel(imfinfo(strcat(data.img_path,data.r_dir(t).name)));
        for z=1:z_max
            num_stack{z,t}=imread(strcat(data.img_path,data.num_dir(t).name),z);
            dot_stack{z,t}=imread(strcat(data.img_path,data.dot_dir(t).name),z);
            
            if r_use
                r_edit{z,t}=imread(strcat(data.img_path,data.r_edit_dir(t).name),z);
            end
            if g_use
                g_edit{z,t}=imread(strcat(data.img_path,data.g_edit_dir(t).name),z);
            end
            if b_use
                b_edit{z,t}=imread(strcat(data.img_path,data.b_edit_dir(t).name),z);
            end
            
        end
    end
end


for t=1:t_max
    fprintf('reading in raw stack\n')
    t
    z_max=numel(imfinfo(strcat(data.img_path,data.base_dir(t).name)));
    % nuc_stats=csvread(strcat(data.img_path,nuc_stats_dir(t).name),1,0); %last two arguments are row, column to start reading (skip header)
    % all_nuc_stats(1:size(nuc_stats,1),1:size(nuc_stats,2),t)=nuc_stats;
    
    %  max_nuc=all_nuc_stats(max(find(all_nuc_stats(:,1,t))),1,t); %max cell id for this time point;
    
    for z=1:z_max
        %  z
        if r_use==1
        r_stack{z,t}=uint8(imread(strcat(data.img_path,data.r_dir(t).name),z));
        end
        
        if g_use==1
            g_stack{z,t}=uint8(imread(strcat(data.img_path,data.g_dir(t).name),z));
        end
        
        if b_use==1
            b_stack{z,t}=uint8(imread(strcat(data.img_path,data.b_dir(t).name),z));
        end

    end
    
end

guidata(hObject,data);

end
