%%create a gui that allows for renumbering of segmented cells
function seg_gui_base

recycle on

gui_width=floor(650*2.667);
gui_height=floor(951*.95);
hObject=figure('WindowScrollWheelFcn',@mouse_input,'Name','Segmentation GUI','Visible','off','Position',[100,50,gui_width,gui_height]);
data=guidata(hObject);
data.img_path=input('Please enter the image path: ','s');

data.r_suffix=input('Please enter the unique suffix to identify the red channel (press enter to leave red channel empty): ','s');
data.g_suffix=input('Please enter the unique suffix to identify the green channel (press enter to leave green channel empty): ','s');
data.b_suffix=input('Please enter the unique suffix to identify the blue channel (press enter to leave blue channel empty): ','s');

guidata(hObject,data);

[data.r_stack,data.g_stack,data.b_stack,data.num_stack,data.dot_stack,data.r_edit,data.g_edit,data.b_edit,data.cell_stats,data.r_use,data.g_use,data.b_use]=gui_input(hObject);

data.t_max=size(data.num_stack,2);
data.z_max=size(data.num_stack,1);

for t=1:data.t_max
    for z=1:data.z_max %if not all z stacks are the same size, they will have
        %different z maxes. store current t z max in a specific variable for
        %setting the max values of sliders and popup menus
        if size(data.num_stack{z,t})>0
            if z==data.z_max
                data.ct_z_max(t)=z;
            end
        else
            data.ct_z_max(t)=z-1;
            break
        end
    end
end

data.r_dir=dir(strcat(data.img_path,'*',data.r_suffix,'.tif'));
data.r_edit_dir=dir(strcat(data.img_path,'*r_edit.tif'));
data.g_dir=dir(strcat(data.img_path,'*',data.g_suffix,'.tif'));
data.g_edit_dir=dir(strcat(data.img_path,'*g_edit.tif'));
data.b_dir=dir(strcat(data.img_path,'*',data.b_suffix,'.tif'));
data.b_edit_dir=dir(strcat(data.img_path,'*b_edit.tif'));

data.num_dir=dir(strcat(data.img_path,'*numbered_cells.tif'));
data.dot_dir=dir(strcat(data.img_path,'*dot_cells.tif'));
data.stats_dir=dir(strcat(data.img_path,'*statistics.csv'));
data.cell_lineages=[];

%all pixels where scale is present in last time point. used to generate
%random cell location for 

%last_outline=imread(strcat(data.img_path,'outline_t115.tif'));
%out_fill=imfill(last_outline);
%data.last_loc=find(out_fill);
data.random_coord=[];

dimensions=size(data.num_stack{1,1});
%%%%slider settings

slider_width=floor(gui_width*0.5);
slider_height=floor(gui_height*.02);
slider_left=floor(gui_width*0.25);
slider_bottom=floor(gui_height*.025);
z_sld=uicontrol('Style','slider','Min',1,'Max',data.z_max,'Value',1,'Position',[slider_left,slider_bottom*1.95,slider_width,slider_height],'Callback',@load_z);%[433,42.9,866,18]
%set(z_sld,'Value',3);
z_label=uicontrol('Style','text','Position',[slider_left-90,slider_bottom*1.95,80,20],'String','Z Value');
t_sld=uicontrol('Style','slider','Min',1,'Max',data.t_max,'Value',1,'Position',[slider_left,slider_bottom,slider_width,slider_height],'Callback',@load_t);
t_label=uicontrol('Style','text','Position',[slider_left-90,slider_bottom,80,20],'String','T Value');
br_sld_ch00=uicontrol('Style','slider','Min',0.1,'Max',10,'Value',1,'Position',[slider_left,slider_bottom*3.9,slider_width,slider_height],'Callback',@brightness_ch00);
br_label_ch00=uicontrol('Style','text','Position',[slider_left-100,slider_bottom*3.9,100,20],'String','Ch00 Brightness');
exposure_sld=uicontrol('Style','slider','Min',1,'Max',3,'Value',2,'Position',[slider_left,slider_bottom*2.9,slider_width,slider_height],'Callback',@exposure);
exposure_label=uicontrol('Style','text','Position',[slider_left-100,slider_bottom*2.9,100,20],'String','Exposure Level');

if data.z_max>1
    z_sld.SliderStep=[1/(data.z_max-1) 1/(data.z_max-1)];
else %prevents error if you're loading a 2d image
    z_sld.SliderStep=[1 1];
end

if data.t_max>1
    t_sld.SliderStep=[1/(data.t_max-1) 1/(data.t_max-1)];
else
    t_sld.SliderStep=[1 1];
end

%%%%button settings
button_ystart=floor(gui_height*0.93)+10;
button_xstart=50;
button_spacing=95;
button_width=85;
button_height=25;
draw_button=uicontrol('Style','pushbutton','String','Draw Cell','Position',[button_xstart,button_ystart,button_width,button_height],'Callback',@draw);
merge_button=uicontrol('Style','pushbutton','String','Merge Cells','Position',[button_xstart+button_spacing,button_ystart,button_width,button_height],'Callback',@merge);
erase_button=uicontrol('Style','pushbutton','String','Free Erase','Position',[button_xstart+button_spacing*2,button_ystart,button_width,button_height],'Callback',@erase);
erase_click_button=uicontrol('Style','pushbutton','String','Click Erase','Position',[button_xstart+button_spacing*3,button_ystart,button_width,button_height],'Callback',@erase_click);
%erase_thru_button=uicontrol('Style','pushbutton','String','Click Erase Thru Z','FontSize',7,'Position',[button_xstart+button_spacing*4,button_ystart,button_width,button_height],'Callback',@erase_click);
%replace_button=uicontrol('Style','pushbutton','String','Replace Number','FontSize',7,'Position',[button_xstart+button_spacing*5,button_ystart,button_width,button_height],'Callback',@replace);

split_button=uicontrol('Style','pushbutton','String','Split Cells','Position',[button_xstart,button_ystart-(1.1*button_height),button_width,button_height],'Callback',@split_cells);
submit_button=uicontrol('Style','pushbutton','String','Submit','Position',[button_xstart+button_spacing,button_ystart-(1.1*button_height),button_width,button_height],'Callback',@submit);
undo_button=uicontrol('Style','pushbutton','String','Undo','Position',[button_xstart+button_spacing*2,button_ystart-(1.1*button_height),button_width,button_height],'Callback',@undo);
zoom_button=uicontrol('Style','pushbutton','String','Zoom','Position',[button_xstart+button_spacing*3,button_ystart-(1.1*button_height),button_width,button_height],'Callback',@zoom_img);

correct_button=uicontrol('Style','pushbutton','String','Correct Track','Position',[button_xstart,button_ystart-(2.2*button_height),button_width,button_height],'Callback',@correct_track);
track_button=uicontrol('Style','pushbutton','String','Retrack','Position',[button_xstart+button_spacing,button_ystart-(2.2*button_height),button_width,button_height],'Callback',@track_cell);
save_track_button=uicontrol('Style','pushbutton','String','Save Track','Position',[button_xstart+button_spacing*2,button_ystart-(2.2*button_height),button_width,button_height],'Callback',@save_track);
new_track_button=uicontrol('Style','pushbutton','String','New Track','Position',[button_xstart+button_spacing*3,button_ystart-(2.2*button_height),button_width,button_height],'Callback',@new_track);

save_button=uicontrol('Style','pushbutton','String','Save','Position',[floor(0.285*gui_width),floor(0.83*gui_height),75,30],'Callback',@save_img);
reload_button=uicontrol('Style','pushbutton','String','Reload','Position',[floor(0.605*gui_width),floor(0.83*gui_height),75,30],'Callback',@reload_img);
renumber_button=uicontrol('Style','pushbutton','String','Renumber','Position',[floor(0.905*gui_width),floor(0.83*gui_height),75,30],'Callback',@renumber);
%%%%radio buttons
radio_height=floor(gui_height*0.8);
save_width=0.25*gui_width;

save_options=uibuttongroup('Visible','off','Position',[0.03 0.82 0.25 0.045],'SelectionChangedFcn',@saveselection);
save1=uicontrol(save_options,'Style','radiobutton','String','Save Current Z, T','Position',[floor(save_width*.05),5,150,30],'HandleVisibility','off');
save2=uicontrol(save_options,'Style','radiobutton','String','Save Current T','Position',[floor(save_width*.35),5,150,30],'HandleVisibility','off');
save3=uicontrol(save_options,'Style','radiobutton','String','Save All','Position',[floor(save_width*.65),5,150,30],'HandleVisibility','off');
save_options.Visible='on';

segment_options=uibuttongroup('Visible','off','Position',[0.03 0.77 0.15 0.045],'SelectionChangedFcn',@segselection);
seg1=uicontrol(segment_options,'Style','radiobutton','String','Chan-Vese','Position',[floor(save_width*.05),5,150,30],'HandleVisibility','off');
seg2=uicontrol(segment_options,'Style','radiobutton','String','Edge','Position',[floor(save_width*.35),5,150,30],'HandleVisibility','off');
segment_options.Visible='on';

overwrite_options=uibuttongroup('Visible','off','Position',[0.30 0.77 0.15 0.045],'SelectionChangedFcn',@ovwselection);
ovw_label=uicontrol(overwrite_options,'Style','text','Position',[floor(save_width*.01),1,105,25],'String','Allow Overwriting:');%[133,82,100,20]
ovw1=uicontrol(overwrite_options,'Style','radiobutton','String','Yes','Position',[floor(save_width*.25),5,150,30],'HandleVisibility','off');
ovw2=uicontrol(overwrite_options,'Style','radiobutton','String','No','Position',[floor(save_width*.35),5,150,30],'HandleVisibility','off');
overwrite_options.Visible='on';


reload_options=uibuttongroup('Visible','off','Position',[0.35 0.82 0.25 0.045],'SelectionChangedFcn',@reloadselection);
reload1=uicontrol(reload_options,'Style','radiobutton','String','Reload Z, T','Position',[floor(save_width*.05),5,100,30],'HandleVisibility','off');
reload2=uicontrol(reload_options,'Style','radiobutton','String','Reload T','Position',[floor(save_width*.30),5,100,30],'HandleVisibility','off');
reload3=uicontrol(reload_options,'Style','radiobutton','String','Reload All','Position',[floor(save_width*.55),5,100,30],'HandleVisibility','off');
reload4=uicontrol(reload_options,'Style','radiobutton','String','Reload Saved','Position',[floor(save_width*.75),5,100,30],'HandleVisibility','off');
reload_options.Visible='on';

renumber_options=uibuttongroup('Visible','off','Position',[0.65 0.82 0.25 0.045],'SelectionChangedFcn',@renumberselection);
renumber1=uicontrol(renumber_options,'Style','radiobutton','String','Renumber Current Z, T','FontSize',8,'Position',[floor(save_width*.05),5,165,30],'HandleVisibility','off');
renumber2=uicontrol(renumber_options,'Style','radiobutton','String','Renumber Current T','FontSize',8,'Position',[floor(save_width*.38),5,165,30],'HandleVisibility','off');
renumber3=uicontrol(renumber_options,'Style','radiobutton','String','Renumber Auto','FontSize',8,'Position',[floor(save_width*.71),5,165,30],'HandleVisibility','off');
set(renumber_options,'SelectedObject',renumber3');
renumber_options.Visible='on';

retrack_options=uibuttongroup('Visible','off','Position',[0.3 0.87 0.11 0.045],'SelectionChangedFcn',@retrackselection);
rt1=uicontrol(retrack_options,'Style','radiobutton','String','Forward','Position',[floor(save_width*.05),5,100,30],'HandleVisibility','off');
rt2=uicontrol(retrack_options,'Style','radiobutton','String','Reverse','Position',[floor(save_width*.25),5,100,30],'HandleVisibility','off');
set(retrack_options,'SelectedObject',rt2)
retrack_options.Visible='on';

track_options=uibuttongroup('Visible','off','Position',[0.42 0.87 0.11 0.045],'SelectionChangedFcn',@trackselection);
tr1=uicontrol(track_options,'Style','radiobutton','String','Track Off','Position',[floor(save_width*.05),5,100,30],'HandleVisibility','off');
tr2=uicontrol(track_options,'Style','radiobutton','String','Track On','Position',[floor(save_width*.25),5,100,30],'HandleVisibility','off');
track_options.Visible='on';

draw_options=uibuttongroup('Visible','off','Position',[0.48 0.92 0.080 0.045],'SelectionChangedFcn',@drawselection);
dr1=uicontrol(draw_options,'Style','radiobutton','String','Add','Position',[floor(save_width*.05),5,75,30],'HandleVisibility','off');
dr2=uicontrol(draw_options,'Style','radiobutton','String','Replace','Position',[floor(save_width*.15),5,75,30],'HandleVisibility','off');
draw_options.Visible='on';

default_edit_options=uibuttongroup('Visible','off','Position',[0.65 0.92 0.140 0.045],'SelectionChangedFcn',@defaultselection);
default1=uicontrol(default_edit_options,'Style','radiobutton','String','Next Available','Position',[floor(save_width*.05),5,100,30],'HandleVisibility','off');
default2=uicontrol(default_edit_options,'Style','radiobutton','String','Current Tracked','Position',[floor(save_width*.27),5,100,30],'HandleVisibility','off');
default_edit_options.Visible='on';

raw_disp_label=uicontrol('Style','text','Position',[0.66*gui_width,0.915*gui_height,200,20],'String','Raw Display');
raw_disp_options=uibuttongroup('Visible','off','Position',[0.65 0.87 0.16 0.045],'SelectionChangedFcn',@rawdisplayselection);
raw1=uicontrol(raw_disp_options,'Style','radiobutton','String','R','Position',[floor(save_width*.05),5,100,30],'HandleVisibility','off');
raw2=uicontrol(raw_disp_options,'Style','radiobutton','String','G','Position',[floor(save_width*.12),5,100,30],'HandleVisibility','off');
raw3=uicontrol(raw_disp_options,'Style','radiobutton','String','B','Position',[floor(save_width*.19),5,100,30],'HandleVisibility','off');
raw4=uicontrol(raw_disp_options,'Style','radiobutton','String','RG','Position',[floor(save_width*.26),5,100,30],'HandleVisibility','off');
raw5=uicontrol(raw_disp_options,'Style','radiobutton','String','RB','Position',[floor(save_width*.35),5,100,30],'HandleVisibility','off');
raw6=uicontrol(raw_disp_options,'Style','radiobutton','String','GB','Position',[floor(save_width*.44),5,100,30],'HandleVisibility','off');
raw7=uicontrol(raw_disp_options,'Style','radiobutton','String','RGB','Position',[floor(save_width*.53),5,100,30],'HandleVisibility','off');

edit_disp_label=uicontrol('Style','text','Position',[0.82*gui_width,0.915*gui_height,200,20],'String','Segmentation Display');
edit_disp_options=uibuttongroup('Visible','off','Position',[0.82 0.87 0.16 0.045],'SelectionChangedFcn',@editdisplayselection);
edit1=uicontrol(edit_disp_options,'Style','radiobutton','String','R','Position',[floor(save_width*.05),5,100,30],'HandleVisibility','off');
edit2=uicontrol(edit_disp_options,'Style','radiobutton','String','G','Position',[floor(save_width*.12),5,100,30],'HandleVisibility','off');
edit3=uicontrol(edit_disp_options,'Style','radiobutton','String','B','Position',[floor(save_width*.19),5,100,30],'HandleVisibility','off');
edit4=uicontrol(edit_disp_options,'Style','radiobutton','String','RG','Position',[floor(save_width*.26),5,100,30],'HandleVisibility','off');
edit5=uicontrol(edit_disp_options,'Style','radiobutton','String','RB','Position',[floor(save_width*.35),5,100,30],'HandleVisibility','off');
edit6=uicontrol(edit_disp_options,'Style','radiobutton','String','GB','Position',[floor(save_width*.44),5,100,30],'HandleVisibility','off');
edit7=uicontrol(edit_disp_options,'Style','radiobutton','String','RGB','Position',[floor(save_width*.53),5,100,30],'HandleVisibility','off');

%id_label=uicontrol('Style','text','Position',[0.60*gui_width,0.915*gui_height,200,20],'String','Display Cell IDs');
id_options=uibuttongroup('Visible','off','Position',[0.54 0.87 0.11 0.045],'SelectionChangedFcn',@idselection);
id1=uicontrol(id_options,'Style','radiobutton','String','IDs Off','Position',[floor(save_width*.05),5,100,30],'HandleVisibility','off');
id2=uicontrol(id_options,'Style','radiobutton','String','IDs On','Position',[floor(save_width*.25),5,100,30],'HandleVisibility','off');
id_options.Visible='on';

%match_id_label_1=uicontrol('Style','text','Position',[0.76*gui_width,0.955*gui_height,100,20],'String','Match IDs');
%match_id_label_2=uicontrol('Style','text','Position',[0.785*gui_width,0.935*gui_height,100,20],'String','Membrane ID:');
%match_id_label_3=uicontrol('Style','text','Position',[0.725*gui_width,0.935*gui_height,100,20],'String','Nuclear ID:');

%seg_disp_label=uicontrol('Style','text','Position',[0.705*gui_width,0.915*gui_height,300,20],'String','Segmentation Display/Save (Mask and IDs)');


%default to displaying the first available channel. user can change
%combinations from there

data.r_raw_disp=0;
data.g_raw_disp=0;
data.b_raw_disp=0;
data.r_edit_disp=0;
data.g_edit_disp=0;
data.b_edit_disp=0;

if data.r_use
    set(raw_disp_options,'SelectedObject',raw1)
    set(edit_disp_options,'SelectedObject',edit1)
    data.r_raw_disp=1;
    data.r_edit_disp=1;
elseif data.g_use
    set(raw_disp_options,'SelectedObject',raw2)
    set(edit_disp_options,'SelectedObject',edit2)
    data.g_raw_disp=1;
    data.g_edit_disp=1;
else
    set(raw_disp_options,'SelectedObject',raw3)
    set(edit_disp_options,'SelectedObject',edit3)
    data.b_raw_disp=1;
    data.b_edit_disp=1;
end

raw_disp_options.Visible='on';
edit_disp_options.Visible='on';

%saved_msg=uicontrol('Style','text','Position',[50,50,150,20],'String','test msg','FontName','FixedWidth');
%%keyboard/char input

cat_input=uicontrol('Style','edit','Units','normalized','Position',[0.33,0.93,0.03,0.03],'String','','Callback',@enter_cat);
cat_label=uicontrol('Style','text','Position',[570,button_ystart+20,55,20],'String','Category');

value_input=uicontrol('Style','edit','Units','normalized','Position',[0.36,0.93,0.03,0.03],'String','','Callback',@enter_value);
value_label=uicontrol('Style','text','Position',[620,button_ystart+20,55,20],'String','Value');

id_input=uicontrol('Style','edit','Units','normalized','Position',[0.39,0.93,0.03,0.03],'String','1','Callback',@enter_id);
id_label=uicontrol('Style','text','Position',[670,button_ystart+20,55,20],'String','Edit Cell');

max_caption=uicontrol('Style','text','Position',[975,button_ystart+20,100,20],'String','Max Cell: ');
current_caption=uicontrol('Style','text','Position',[975,button_ystart,100,20],'String','Current Cell: ');
sib_caption=uicontrol('Style','text','Position',[975,button_ystart-20,100,20],'String','Sibling: ');

sib_input=uicontrol('Style','edit','Units','normalized','Position',[0.445,0.93,0.03,0.03],'String','1','Callback',@sib_id);
sib_input_label=uicontrol('Style','text','Position',[730,button_ystart-7,40,20],'String','Sibling ID');


seg_iter_input=uicontrol('Style','edit','Units','normalized','Position',[0.185 0.77 0.03 0.03],'String','25','Callback',@seg_iter);
seg_iter_label=uicontrol('Style','text','Position',[0.185*gui_width,.807*gui_height,55,10],'String','Iterations');

tp_track_input=uicontrol('Style','edit','Units','normalized','Position',[0.23 0.77 0.03 0.03],'String','All','Callback',@tp_track);
tp_track_label=uicontrol('Style','text','Position',[0.22*gui_width,.807*gui_height,100,10],'String','Timepoints to Track');

%displays current time, z, cells--will update with user interactions
t_label=uicontrol('Style','text','Position',[slider_left-22,slider_bottom,25,20],'String',''); %[411,22,25,20]
z_label=uicontrol('Style','text','Position',[slider_left-22,round(slider_bottom*1.95),25,20],'String','');%[411,43,25,20]
current_number=uicontrol('Style','text','Position',[1055,button_ystart,40,20],'String','');
sib_number=uicontrol('Style','text','Position',[1055,button_ystart-20,40,20],'String','');%[1055,829,40,20]
max_number=uicontrol('Style','text','Position',[1055,button_ystart+20,40,20],'String','');%[1055,849,40,20]
selected_cells=uicontrol('Style','text','Position',[slider_left-300,slider_bottom+60,100,20],'String','');%[133,82,100,20]
disc_warning=uicontrol('Style','text','Position',[floor(0.80*gui_width),floor(0.76*gui_height),200,20],'String','');%[1386,686,200,20]

data.default_t=1;
data.default_z=1;
data.val_z=data.default_z;
data.val_t=data.default_t;
data.val_br_ch00=1;
data.exposure=2;
data.temp_z=1;
data.temp_t=1;
data.seg_iter=25;
data.zr1=1;
data.zr2=1;

data.tp_track=data.t_max; %by default, track entire time course. user can
%change how long they want tracking to go
data.button_ystart=button_ystart;
data.slider_left=slider_left;
data.slider_bottom=slider_bottom;
%start out with the current edit and max ids the same--the max cell.
%determine this by going 1 above the last stats file entry with real data
%(column 2 is cell volume)

max_line=size(data.cell_stats{data.t_max},1);
if data.cell_stats{data.t_max}(max_line,3)>0
data.current_max=data.cell_stats{data.t_max}(max_line,1)+1;
else %if the line is empty except for ID, it's probably the first time
    %tracking this file--start at ID 1
    data.current_max=data.cell_stats{data.t_max}(max_line,1);
end

data.current_id=data.current_max;
data.current_sib=1;
data.current_value=[];
data.current_cat=[];

data.modified_ids=[];
data.multiz_loc=[];
data.multiz_ids=[];
data.ran_undo=0;
data.selected_ids=zeros(data.z_max,1);
data.selected_loci=zeros(data.z_max,1);
data.full_track=[zeros(1,data.t_max)];
data.tracking_result=[zeros(1,data.t_max)];
data.current_track_id=data.full_track(1);
data.ax1=axes('Position',[0.02,0.15,0.31,0.60]);
%data.ax2=axes('Position',[0.26,0.15,0.22,0.60]);
%data.ax3=axes('Position',[0.50,0.15,0.22,0.60]);
%data.ax4=axes('Position',[0.74,0.15,0.22,0.60]);
%data.rect_ax=axes('Position',[0.029,0.79,0.8,0.01]);
%data.val_c=0.11;
data.display_ids=0;

%%%default selections for radio buttons
data.save_pref='Save Current Z, T';
data.reload_pref='Reload Z, T';
data.renumber_pref='Renumber Auto';
data.seg_ovw='Yes';
data.seg_method='Chan-Vese';
data.def_edit_method='Next Available';
data.marker=[0 0 1 1 1 0 0
    0 1 1 1 1 1 0
    1 1 1 1 1 1 1
    1 1 1 1 1 1 1
    1 1 1 1 1 1 1
    0 1 1 1 1 1 0
    0 0 1 1 1 0 0];
data.marker_sm=uint8([0 1 1 1 0 
     1 1 1 1 1 
     1 1 1 1 1 
     1 1 1 1 1 
    0 1 1 1 0]);
% if nuc_use==1 %defaults to display and edit nuc unless only mem is loaded
%     data.segd_switch='nuc';
%     data.sege_switch='nuc';
% else
%     data.segd_switch='mem';
%     data.segd_switch='mem';
% end

data.replace_draw=0;
data.thru_z=0; %if on, tells renumbering to go thru end of z stack/to beginning (depending on if rev is on)
data.multi_z=0;
data.rev=1;
data.display_track=0;
data.track_id=1;
data.gui_width=gui_width;
data.gui_height=gui_height;
%%%reads in previously saved tracks
%data.script_tracks=csvread(strcat(data.img_path,'all_tracks.csv')); %tracks created by the first run of tracking script
data.saved_tracks=[];
data.iso_tracks=[];

saved_track_dir=dir(strcat(data.img_path,'saved_tracks\','*.csv'));
iso_track_dir=dir(strcat(data.img_path,'isolated_tracks\','*.csv'));

for idx=1:numel(saved_track_dir)
    import_track=csvread(strcat(data.img_path,'saved_tracks\',saved_track_dir(idx).name));
    data.saved_tracks(idx,:)=import_track;
end

for idx=1:numel(iso_track_dir)
    import_track=csvread(strcat(data.img_path,'isolated_tracks\',iso_track_dir(idx).name));
    data.iso_tracks(idx,:)=import_track;
end

data.x_zoom=[1 dimensions(2)];
data.y_zoom=[1 dimensions(1)]; %start displaying whole image. will change if using zoom button
data.x_size=dimensions(2);
data.y_size=dimensions(1);

data.xm=[];
data.ym=[];
data.zm_start=[];
data.zm_end=[];

%eventually data.original_stack should replace temp_img
data.original_stack=[];
data.orig_stack_t=[];
data.temp_img=0;
data.figPos=hObject.Position;
data.first_width=0;
data.track_row=1;
data.current_start=0;
data.last_start=0;
data.last_width=0;
data.current_match=[0,0];

guidata(hObject,data);
%display_current(hObject);
%display_track(base);
%display_max(hObject);
%display_sib(hObject);
%display_match(base);
%display_z(hObject);
%display_t(hObject);
load_img(hObject);
hObject.Visible='on';

    function mouse_input(src,callbackdata)
        t_val=t_sld.Value;
        if t_val>1 && callbackdata.VerticalScrollCount==-1
            set(t_sld,'Value',t_val-1); %don't go below t=1
            load_t_wheel(hObject,callbackdata);
        elseif t_val<size(data.num_stack,2) && callbackdata.VerticalScrollCount==1 %don't go past t max
            set(t_sld,'Value',t_val+1); %don't go below t=1
            load_t_wheel(hObject,callbackdata);
        end
    end
%%get keyboard inputs
set(hObject,'KeyPressFcn',{@keyboard_input,hObject});

    function keyboard_input(varargin) %nested within figure initialization
        %uses keyboard input instead of clicking buttons/moving sliders
        %   varargin{2}.Character
        %   varargin{2}.Modifier
        switch varargin{2}.Key %varargin{1} is the figure number
            %non-alphanumeric keys
            case 'leftarrow'
                if br_sld_ch00.Value>1
                    set(br_sld_ch00,'Value',br_sld_ch00.Value-1);
                    % data.val_br_ch00=data.val_br_ch00-1; %don't go below 0.1
                    brightness_ch00(hObject,varargin{2}.Key);
                end
            case 'rightarrow'
                if br_sld_ch00.Value<10 %don't go past max brightness
                    set(br_sld_ch00,'Value',br_sld_ch00.Value+1);
                    % data.val_br_ch00=data.val_br_ch00+1;
                    brightness_ch00(hObject,varargin{2}.Key);
                end
            case 'uparrow'
                if exposure_sld.Value<3 %don't go past max brightness
                    set(exposure_sld,'Value',exposure_sld.Value+1);
                    exposure(hObject,varargin{2}.Key);
                end
            case 'downarrow'
                if exposure_sld.Value>1
                    set(exposure_sld,'Value',exposure_sld.Value-1);
                    exposure(hObject,varargin{2}.Key);
                end
                %             case 'b'
                %                 data.save_pref='Save Current Z, T';
                %                 set(save_options,'SelectedObject',save1');
                %                 save_img(base);
           case 'control'
               zoom_img(hObject)
            case 'escape'
                reset_zoom(hObject)
            case 'space'
                submit(hObject)
            case 'tab'
                next_cell(hObject)
            case 'hyphen'
                zoom_mod(hObject,varargin{2}.Key)
            case 'equal'
                zoom_mod(hObject,varargin{2}.Key)
                %%alpha row 1
            case 'q'
                erase_current(hObject)
            case 'w' %increase t
                t_val=t_sld.Value;
                if t_sld.Value<size(data.num_stack,2) %don't go past t max
                    set(t_sld,'Value',t_sld.Value+1);
                    load_t(hObject,varargin{2}.Key);
                end
                
            case 'e'
                assign_lineage(hObject)
            case 'r'
                dot_point(hObject)
            case 't'
                random_pixel(hObject)
            case 'y'
                merge2_lasso(hObject)
            case 'u'
                exposure(hObject,varargin{2}.Key)
            %    bisect_cell(hObject)
            case 'i'
                move_view(hObject,varargin{2}.Key)
            case 'o'
                exposure(hObject,varargin{2}.Key)
              %  segment_cell(hObject);
            case 'p'
                replace_lasso(hObject)
                %%alpha row 2
            case 'a' %decrease z
                z_val=z_sld.Value;
                if z_val>1
                    set(z_sld,'Value',z_val-1); %don't go below z=1
                    load_z(hObject,varargin{2}.Key);
                end
            case 's' %decrease t
                t_val=t_sld.Value;
                if t_val>1
                    set(t_sld,'Value',t_val-1); %don't go below t=1
                    load_t(hObject,varargin{2}.Key);
                end
            case 'd' %increase z
                if z_sld.Value<size(data.num_stack,1) %don't go past z max
                    set(z_sld,'Value',z_sld.Value+1);
                    load_z(hObject,varargin{2}.Key);
                end
            case 'f'
                erase_key(hObject)
            case 'g'
                go_to_cell(hObject)
            case 'h'
                merge_lasso(hObject)
            case 'j'
                move_view(hObject,varargin{2}.Key);
            case 'k'
                move_view(hObject,varargin{2}.Key);
            case 'l'
                move_view(hObject,varargin{2}.Key);
                
                %%alpha row 3
            case 'z'
                
                if strcmp(varargin{2}.Modifier,'shift')
                    dilate_merge_single_plane(hObject);
                else
                    dilate_merge(hObject);
                end
                %   clear_selection(base)
            case 'x'
                undo(hObject)
            case 'c'
                replace(hObject)
            case 'v'
                select_cell(hObject)
            case 'b'
                correct_track(hObject)
                %clear_match(base)
            case 'n'
                if strcmp(varargin{2}.Modifier,'shift')
                    split_thru_current(hObject)
                else
                    split_brush(hObject)
                end
                %                confirm_match(base)
            case 'm'
                categorize_cells(hObject)
                %match(base)
        end
    end

end
