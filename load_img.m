function load_img(hObject)
%this version of load image shows compressed images and uses image
%instead of imshow

data=guidata(hObject);
x_min=min(data.x_zoom);
x_max=max(data.x_zoom);
y_min=min(data.y_zoom);
y_max=max(data.y_zoom);


y_size=y_max-y_min;
y_segments=y_size/10;
y_iter=y_segments-mod(y_segments,10);
if y_iter==0
    y_iter=5;
end
ytick_loc=[1:y_iter:y_size];
ytick_vals=[y_min:y_iter:y_max];

x_size=x_max-x_min;
x_segments=x_size/8;
x_iter=x_segments-mod(x_segments,8);
if x_iter==0
    x_iter=5;
end
xtick_loc=[1:x_iter:x_size];
xtick_vals=[x_min:x_iter:x_max];

overlay(:,:,1)=uint8(zeros(size(data.dot_stack{data.val_z,data.val_t})));
overlay(:,:,2)=uint8(zeros(size(data.dot_stack{data.val_z,data.val_t})));
overlay(:,:,3)=uint8(zeros(size(data.dot_stack{data.val_z,data.val_t})));

if data.display_ids
    overlay(:,:,1)=data.dot_stack{data.val_z,data.val_t}+data.num_stack{data.val_z,data.val_t};
    overlay(:,:,2)=data.dot_stack{data.val_z,data.val_t}+data.num_stack{data.val_z,data.val_t};
    overlay(:,:,3)=data.dot_stack{data.val_z,data.val_t}+data.num_stack{data.val_z,data.val_t};
end

if data.r_raw_disp
    overlay(:,:,1)=overlay(:,:,1)+data.r_stack{data.val_z,data.val_t};
end

if data.g_raw_disp
    overlay(:,:,2)=overlay(:,:,2)+data.g_stack{data.val_z,data.val_t};
end

if data.b_raw_disp
    overlay(:,:,3)=overlay(:,:,3)+data.b_stack{data.val_z,data.val_t};
end


if data.r_edit_disp
    r_edit_slice=data.r_edit{data.val_z,data.val_t};
    r_edit_slice(find(r_edit_slice))=85;
    overlay(:,:,1)=overlay(:,:,1)+r_edit_slice;
    overlay(:,:,2)=overlay(:,:,2)+r_edit_slice;
    overlay(:,:,3)=overlay(:,:,3)+r_edit_slice;
end

if data.g_edit_disp
    g_edit_slice=data.g_edit{data.val_z,data.val_t};
    g_edit_slice(find(g_edit_slice))=170;
    overlay(:,:,1)=overlay(:,:,1)+g_edit_slice;
    overlay(:,:,2)=overlay(:,:,2)+g_edit_slice;
    overlay(:,:,3)=overlay(:,:,3)+g_edit_slice;
end

if data.b_edit_disp
    b_edit_slice=data.b_edit{data.val_z,data.val_t};
    b_edit_slice(find(b_edit_slice))=255;
    overlay(:,:,1)=overlay(:,:,1)+b_edit_slice;
    overlay(:,:,2)=overlay(:,:,2)+b_edit_slice;
    overlay(:,:,3)=overlay(:,:,3)+b_edit_slice;
end
    
if numel(data.random_coord)>0
    %make a white dot where the random coordinate was generated
    
    r=overlay(:,:,1);
    r(data.random_coord(1)-3:data.random_coord(1)+3,data.random_coord(2)-3:data.random_coord(2)+3)=data.marker*255;
    overlay(:,:,1)=r;
    g=overlay(:,:,2);
    g(data.random_coord(1)-3:data.random_coord(1)+3,data.random_coord(2)-3:data.random_coord(2)+3)=data.marker*255;
    overlay(:,:,2)=g;
    b=overlay(:,:,3);
    b(data.random_coord(1)-3:data.random_coord(1)+3,data.random_coord(2)-3:data.random_coord(2)+3)=data.marker*255;
    overlay(:,:,3)=b;
end

overlay=overlay(y_min:y_max,x_min:x_max,:);

axes(data.ax1);
imagesc(overlay);
set(gca,'YTick',ytick_loc,'YTickLabel',arrayfun(@num2str,ytick_vals(:),'UniformOutput',false))
set(gca,'XTick',xtick_loc,'XTickLabel',arrayfun(@num2str,xtick_vals(:),'UniformOutput',false))
%toc
end

