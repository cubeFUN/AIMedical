function mydialog2
    d = dialog('units','normalized','Position',[1/2-1/5,1/2-1/10,1/2.5,1/5],'Name','interative');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'units','normalized',...
               'Position',[1/10,1/5,8/10,2/5],...
               'String','	');

    btn1 = uicontrol('Parent',d,...
                'units','normalized',...
               'Position',[1/5,1/5,1/5,1/5],...
               'String','coronal',...
               'Callback','delete(gcf);Select_Value=1;');
           
   btn1 = uicontrol('Parent',d,...
                'units','normalized',...
               'Position',[3/5,1/5,1/5,1/5],...
               'String','sagittal',...
               'Callback','delete(gcf);Select_Value=2;');
end