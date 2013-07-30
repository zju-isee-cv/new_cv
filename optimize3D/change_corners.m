function gridInfo = change_corners(gridInfo)
if(~isfield(gridInfo, 'manual'))
    gridInfo.manual  = 0;
     gridInfo.x_backup = gridInfo.x;
end
if(gridInfo.manual == 0)
    gridInfo.x = gridInfo.manual_x;
    gridInfo.manual = ~gridInfo.manual;
else
    gridInfo.x = gridInfo.x_backup;
    gridInfo.manual = ~gridInfo.manual;
end