function go_to_cell(hObject)
%%%centers on currently tracked cell--like the random generator, but for an
%%%already tracked cell
data=guidata(hObject);
axes(data.ax1)
w=size(data.num_stack{1,1},2);
h=size(data.num_stack{1,1},1);

%find the row of the current cell and sib ID
cell_row=intersect(find(data.cell_stats{data.val_t}(:,1)==data.current_id),find(data.cell_stats{data.val_t}(:,2)==data.current_sib));

if numel(cell_row)==1
    %if numel==0, no cell tracked with this id
    %numel should never be >1, if so, must be some error
    
%center the view on the cell in x, y, and z based on stat file
cy=data.cell_stats{data.val_t}(cell_row,4);
cx=data.cell_stats{data.val_t}(cell_row,3);
data.val_z=data.cell_stats{data.val_t}(cell_row,5);
data.zr1=data.val_z;
data.zr2=data.val_z;

w=size(data.num_stack{1,1},2);
h=size(data.num_stack{1,1},1);

%adding the lower value of current x and y zooms allows multiple zooms
x_arms=150;

if cx+x_arms<=w && cx-x_arms>0 %only runs if not the first time zooming
    x_new(1)=cx-x_arms;
    x_new(2)=cx+x_arms;
elseif cx+x_arms>w
    x_new(2)=w;
    x_new(1)=cx-(x_arms+x_arms-(w-cx));
elseif cx-x_arms<=0
    x_new(1)=1;
    x_new(2)=cx+(x_arms+x_arms-(cx-1));
end
x=x_new;
x_range=abs(x(2)-x(1));
x_rat=x_range/w;

y_arms=round(x_arms*h/w);
if cy+y_arms<=h && cy-y_arms>0 %only runs if not the first time zooming
    y_new(1)=cy-y_arms;
    y_new(2)=cy+y_arms;
elseif cy+y_arms>h
    y_new(2)=h;
    y_new(1)=cy-(y_arms+y_arms-(h-cy));
elseif cy-y_arms<=0
    y_new(1)=1;
    y_new(2)=cy+(y_arms+y_arms-(cy-1));
end
y=y_new;
y_range=abs(y(2)-y(1));
y_rat=y_range/h;

data.x_zoom=x;
data.y_zoom=y;


guidata(hObject,data);
load_img(hObject)

end

end
