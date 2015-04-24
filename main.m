function change_ayush

figure('Toolbar','none','Menubar','none','Name','Change Detection Application','NumberTitle','off','IntegerHandle','off','Position',[400,450,400,200]);

uicontrol('Style','text','String','Choose Change Detection Technique which you want to apply.',...
           'Position',[30,145,350,20]);                     % making text
       
       dropdown_value = uicontrol('Style','popupmenu','string',{'Choose','Manually', '2CMV', 'Image Differencing Change Detection - NDVI', 'Change Vector Analysis'},...
           'Position',[140,120,100,15],...              %making pop up menu
           'callback' , @selection);

    function selection(~,~)
        r = get(dropdown_value, 'Value');               % getting its value
                                            %closing of figure
        Untitled(r);                                    %calling function
        
    end
       
end