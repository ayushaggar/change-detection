function Untitled(j)
if j == 2
    o = menu('Choose Color Composite','true color','False color composite');                % choosing composite of colors 
    A = imread('envidata\tsunami_before_changevector.tif');                                 % loading before Tsunami image 
    B = imread('envidata\tsunami_after_changevector.tif');                                  % loading after Tsunami image 
   
    % Create the figure
    hFig = figure('Toolbar','none','Menubar','none','Name','My Image Compare Tool','NumberTitle','off','IntegerHandle','off');

    % Display left image
    subplot(121) 
    if o == 1                                                                               %checking which composite I choosed
        hImL = imshow(cat(3,imadjust(A(:,:,3)),imadjust(A(:,:,2)),imadjust(A(:,:,1))));     % showing first interactive image
    end
    if o == 2
        hImL = imshow(cat(3,imadjust(A(:,:,4)),imadjust(A(:,:,3)),imadjust(A(:,:,2))));
    end
    hp = impixelinfo;                                                                       %showing pixel value
    set(hp,'Position',[5 1 300 20]);                                                        
    
    
    % Display right image
    subplot(122)
    if o == 1
        hImR = imshow(cat(3,imadjust(B(:,:,3)),imadjust(B(:,:,2)),imadjust(B(:,:,1))));
    end
    if o == 2 
        hImR = imshow(cat(3,imadjust(B(:,:,4)),imadjust(B(:,:,3)),imadjust(B(:,:,2))));
    end
    hp2 = impixelinfo;
    set(hp2,'Position',[230 1 300 20]);
    
    
    % Create a scroll panel for left image
    hSpL = imscrollpanel(hFig,hImL);
    set(hSpL,'Units','normalized','Position',[0 0.1 .5 0.9]);
    api = iptgetapi(hSpL);
    api.setMagnification(0.5); % 2X = 200%
    
    % Create scroll panel for right image
    hSpR = imscrollpanel(hFig,hImR);
    set(hSpR,'Units','normalized','Position',[0.5 0.1 .5 0.9]);
    api = iptgetapi(hSpR);
    api.setMagnification(0.5); % 2X = 200%
    
    % Add a Magnification box 
    hMagBox = immagbox(hFig,hImR);
    pos = get(hMagBox,'Position');
    set(hMagBox,'Position',[500 2 pos(3) pos(4)]);

    %% Add an Overview tool
    imoverview(hImL) ;

    %% Get APIs from the scroll panels 
    apiL = iptgetapi(hSpL);
    apiR = iptgetapi(hSpR);

    %% Synchronize left and right scroll panels
    apiL.setMagnification(apiR.getMagnification());
    apiL.setVisibleLocation(apiR.getVisibleLocation());

    % When magnification changes on left scroll panel, 
    % tell right scroll panel
    apiL.addNewMagnificationCallback(apiR.setMagnification);

    % When magnification changes on right scroll panel, 
    % tell left scroll panel
    apiR.addNewMagnificationCallback(apiL.setMagnification);

    % When location changes on left scroll panel, 
    % tell right scroll panel
    apiL.addNewLocationCallback(apiR.setVisibleLocation);

    % When location changes on right scroll panel, 
    % tell left scroll panel
    apiR.addNewLocationCallback(apiL.setVisibleLocation);
end

if j==3
    M = imread('envidata\tsunami_before_changevector.tif');            % loading before Tsunami image 
    N = imread('envidata\tsunami_after_changevector.tif');             % loading after Tsunami image 
    A = single(M);                                                     %converting to single to bring its value in negative range if possible
    B = single(N);
    
    I1 = A(:,:,4);                                                    % using IR band which is 4th in my image
    I2 = B(:,:,4);
    Min = I1-I2;
    
    th = 250;                                                           % after sseing histogram made by Min and chcking different value
       
   
   % now comapring three images first before tsunami image and second after
   % Third color mask in which  red color show where large destruction took
   % place and blue where vegetation is increased in this time which is not
   % possible as tsunami occured so it mostly show error in our data it can
   % be by cloud and all so  useful for subtraction in our calculation.
   
    figure('units','normalized','outerposition',[0 0 1 1])

    % Display left image
    subplot(131) 
    imshow(cat(3,imadjust(M(:,:,3)),imadjust(M(:,:,2)),imadjust(M(:,:,1)))); %showing true befor image
    title('Before tsunami Image')
    hp = impixelinfo;                                                               % showing pixel info
    set(hp,'Position',[5 1 300 20]);
    
    % Display middle image
    subplot(132) 
    imshow(cat(3,imadjust(N(:,:,3)),imadjust(N(:,:,2)),imadjust(N(:,:,1)))); %showing true befor image
    title('After tsunami Image')
    hp = impixelinfo;                                                               % showing pixel info
    set(hp,'Position',[400 1 300 20]);
    
    % Display right image so as to superimpose my mask on it
    subplot(133)
    imshow(cat(3,imadjust(M(:,:,3)),imadjust(M(:,:,2)),imadjust(M(:,:,1))));
    title('Accumulated Red = destruction Accumulated Blue = vegetation  ')
    
    % checking index where our infrared band difference is more than
    % thershold
    Index = Min>th;                                                           
    [m,n] = size(Min);                              % taking Min Size                                                            
    
    % making red color to superimose on condition given by index
    c1=zeros(m,n);              
    c1(Index) = 255;
    c2=zeros(m,n);
    c3=zeros(m,n);
    hold on
    h = imshow(cat(3,c1,c2,c3));                    %showing red image on our previous image but 
    set(h,'AlphaData',0.5)                          %with some translucent value so that we can see what distruction has occured
    
    %Checking where Vegetation grown in years
    Index1 = Min<-th;
    [m,n] = size(Min);
    
    % making blue color to superimose on condition given by index
    d1=zeros(m,n);
    d1(Index1) = 255;
    d2=zeros(m,n);
    d3=zeros(m,n);
    h = imshow(cat(3,d2,d3,d1));                    %showing blue image on our previous image but
    set(h,'AlphaData',0.5)                          %with some translucent value so that we can see what was there befor.
    hold off
    hp2 = impixelinfo;                              % to calculating pixel value
    set(hp2,'Position',[700 1 300 20]);
  
end
 
if j==4
    A = imread('envidata\tsunami_before_changevector.tif');         % loading before Tsunami image 
    B = imread('envidata\tsunami_after_changevector.tif');          % loading after Tsunami image
    NIR1 =  im2single(A(:,:,4));                                    % using IR band which is 4th in my image
    Red1 =  im2single(A(:,:,3));
    NDVI1 = (NIR1 - Red1) ./ (NIR1 + Red1);                         %calculating NDVI
    
    
    % same for image 2
    NIR2 =  im2single(B(:,:,4));
    Red2 =  im2single(B(:,:,3));
    NDVI2 = (NIR2 - Red2) ./ (NIR2 + Red2);
    
    
    C = NDVI1 - NDVI2;                                          % difference of ndvi so as to get change vegetation area
    
    threshold = 0.4;                                            % after sseing histogram made by NDVI
    q1 = (NDVI1 > threshold);
    s1 = 100 * numel(NIR1(q1(:))) / numel(NIR1);                % computing pixels above this value mean vegetation
    
    
    % same for image 2
    threshold = 0.4;
    q2 = (NDVI2 > threshold);
    s2 = 100 * numel(NIR2(q2(:))) / numel(NIR2);
    
    % Create a figure with a 1-by-2 aspect ratio
    h = figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1,4,1)                                              %creating sub plot to fit our images in 1 window
    % Create the scatter plot
    plot(Red1, NIR1, '+b')
    hold on
    plot(Red1(q1(:)), NIR1(q1(:)), 'g+')                        %plotting above thershold value on it
    set(gca, 'XLim', [0 0.025], 'YLim', [0 0.025])
    axis square
    xlabel('red level')
    ylabel('NIR level')
    title('NIR vs. Red Scatter for Before Image')
       
    % Display the thresholded NDVI
    subplot(1,4,2)
    imshow(q1)
    set(h,'Colormap',[0 0 1; 0 1 0])                
    title('NDVI with Threshold Applied for Before Image')
    str2 = sprintf('Percentage = %f', s1);      
    text(2,1,str2)                                              % to show amount % on graph
    
    subplot(1,4,3)
    % Create the scatter plot
    plot(Red2, NIR2, '+b')
    hold on
    plot(Red2(q2(:)), NIR2(q2(:)), 'g+')
    set(gca, 'XLim', [0 0.025], 'YLim', [0 0.025])
    axis square
    xlabel('red level')
    ylabel('NIR level')
    title('NIR vs. Red Scatter for After Image')
    
    % Display the thresholded NDVI
    subplot(1,4,4)
    imshow(q2)
    set(h,'Colormap',[0 0 1; 0 1 0])
    title('NDVI with Threshold Applied for After Image')
    str4 = sprintf('Percentage = %f', s2);
    text(2,1,str4)
    
    % starting of interactive GUI to see result visually    
    
    % Create the figure
    hFig = figure('Toolbar','none','Menubar','none','Name','My Image Compare Tool','NumberTitle','off','IntegerHandle','off');
    
    % Display left image
    subplot(131)  
    hImL = imshow(NDVI1,'DisplayRange',[-1 1]);
    hp = impixelinfo;
    set(hp,'Position',[5 1 300 20]);
        
    % Display middle image
    subplot(132)
    hImM = imshow(NDVI2,'DisplayRange',[-1 1]);
    hp2 = impixelinfo;
    set(hp2,'Position',[180 1 300 20]);
    
    % Display right image
    subplot(133)
    hImR = imshow(C,'DisplayRange',[-1 1]);
    hp3 = impixelinfo;
    set(hp3,'Position',[350 1 300 20]);
    
    % Create a scroll panel for left image
    hSpL = imscrollpanel(hFig,hImL);
    set(hSpL,'Units','normalized','Position',[0 0.1 .33 0.9]);
    api = iptgetapi(hSpL);
    api.setMagnification(0.2); % 2X = 200%
    
    % Create scroll panel for middle image
    hSpM = imscrollpanel(hFig,hImM);
    set(hSpM,'Units','normalized','Position',[0.33 0.1 .33 0.9]);
    api = iptgetapi(hSpM);
    api.setMagnification(0.2); % 2X = 200%
    
    % Create scroll panel for right image
    hSpR = imscrollpanel(hFig,hImR);
    set(hSpR,'Units','normalized','Position',[0.66 0.1 .33 0.9]);
    api = iptgetapi(hSpR);
    api.setMagnification(0.2); % 2X = 200%
    
    % Add a Magnification box 
    hMagBox = immagbox(hFig,hImR);
    pos = get(hMagBox,'Position');
    set(hMagBox,'Position',[500 2 pos(3) pos(4)]);

    %% Add an Overview tool
    imoverview(hImL) ;

    %% Get APIs from the scroll panels 
    apiL = iptgetapi(hSpL);
    apiM = iptgetapi(hSpM);
    apiR = iptgetapi(hSpR);
    

    %% Synchronize  scroll panels
    apiL.setMagnification(apiR.getMagnification());
    apiL.setMagnification(apiM.getMagnification());
    apiL.setVisibleLocation(apiR.getVisibleLocation());
    apiL.setVisibleLocation(apiM.getVisibleLocation());
    

    % When magnification changes on left scroll panel, 
    % tell middle and right scroll panel
    apiL.addNewMagnificationCallback(apiR.setMagnification);
    apiL.addNewMagnificationCallback(apiM.setMagnification);

    % When magnification changes on right scroll panel, 
    % tell left and middle scroll panel
    apiR.addNewMagnificationCallback(apiL.setMagnification);
    apiR.addNewMagnificationCallback(apiM.setMagnification);
    
    % When magnification changes on middle scroll panel, 
    % tell left and right scroll panel
    apiM.addNewMagnificationCallback(apiL.setMagnification);
    apiM.addNewMagnificationCallback(apiR.setMagnification);

    % When location changes on left scroll panel, 
    % tell middle and right scroll panel
    apiL.addNewLocationCallback(apiR.setVisibleLocation);
    apiL.addNewLocationCallback(apiM.setVisibleLocation);

    % When location changes on right scroll panel, 
    % tell left and middle scroll panel
    apiR.addNewLocationCallback(apiL.setVisibleLocation);
    apiR.addNewLocationCallback(apiM.setVisibleLocation);
    
    % When location changes on middle scroll panel, 
    % tell left and right scroll panel
    apiM.addNewLocationCallback(apiR.setVisibleLocation);
    apiM.addNewLocationCallback(apiL.setVisibleLocation);

end

if j==5
  p =menu('Do you want to see masking map with five different color too with statical data? as it takes approx 5 min to load map ','Yes','No'); % choosing menu as it takes time
    A = imread('envidata\tsunami_before_changevector.tif');             % Loading before image
    B = imread('envidata\tsunami_after_changevector.tif');              % Loading after image
    NIR =  im2single(A(:,:,4));                                         % taking band of all
    Red =  im2single(A(:,:,3));
    Swir = im2single(A(:,:,2));
    Blue = im2single(A(:,:,1));
    NDVI1 =(NIR - Red) ./ (NIR + Red);                                  % computing NDVI Image
    BI1= ((Swir+Red)-(NIR+Blue)) ./ ((Swir+Red)+(NIR+Blue));            % computing BI change
   
    NIR =  im2single(B(:,:,4));
    Red =  im2single(B(:,:,3));
    Swir = im2single(B(:,:,2));
    Blue = im2single(B(:,:,1));
    NDVI2 =(NIR - Red) ./ (NIR + Red);
    BI2= ((Swir+Red)-(NIR+Blue))./((Swir+Red)+(NIR+Blue));

    s=sqrt(((NDVI2-NDVI1).^2)+((BI2-BI1).^2));                      % calculating change as a vector
    BIchange=BI2-BI1; 
    ndvichange=NDVI2-NDVI1;
       
    th = graythresh(s)  ;                                           % calculting thershold value
    
  
    
    % Starting to make bar chart by putting amount of pixels for each type particular change in l
    % susing c1 etc so as to fill mask.
  level=[0 0 0 0;0 0 0 0]; 
        
  ind = find((BIchange>0) & (ndvichange>0) & (s<th));               % It is finding indexes f matrix having all this
  s1 =  numel(ind);                                                 % to get amount of pixel for that chnage or no change
  [m,n] = size(s);                              % taking s Size                                                            
  c1=zeros(m,n);              
  c1(ind) = 255;
  c2=zeros(m,n);
  c3=zeros(m,n);
  level(1,1)=s1; 
                           
  ind = find((BIchange>0) & (ndvichange>0) & (s>th));
  s2 =  numel(ind);        
  [m,n] = size(s);                              % taking s Size 
  d1=zeros(m,n);
  d1(ind) = 255;
  d2=zeros(m,n);
  d2(ind) = 255;
  d3=zeros(m,n);
  d3(ind) = 255;
  level(2,1)= s2; 
           
  ind = find((BIchange>0) & (ndvichange<0) & (s<th));
  s3 =  numel(ind);
  [m,n] = size(s);                              % taking s Size  
  c1=zeros(m,n);              
  c1(ind) = 255;
  c2=zeros(m,n);
  c3=zeros(m,n);
  level(1,2)=s3; 
                            
  ind = find((BIchange>0) & (ndvichange<0) & (s>th));
  s4 =  numel(ind);       
  [m,n] = size(s);                              % taking s Size 
  e1=zeros(m,n);
  e1(ind) = 255;
  e2=zeros(m,n);
  e3=zeros(m,n);
  level(2,2)= s4; 
                         
  ind = find((BIchange<0) & (ndvichange<0) & (s<th));
  s5 =  numel(ind);
  [m,n] = size(s);                              % taking s Size  
  c1=zeros(m,n);              
  c1(ind) = 255;
  c2=zeros(m,n);
  c3=zeros(m,n);
  level(1,3)=s5; 
                          
  ind = find((BIchange<0) & (ndvichange<0) & (s>th));
  s6 =  numel(ind);       
  [m,n] = size(s);                              % taking s Size 
  f1=zeros(m,n);
  f1(ind) = 255;
  f2=zeros(m,n);
  f2(ind) = 255;
  f3=zeros(m,n);
  level(2,3)= s6; 
  
  ind = find((BIchange<0) & (ndvichange>0) & (s<th));
  s7 =  numel(ind);
  [m,n] = size(s);                              % taking s Size                                                            
  c1=zeros(m,n);              
  c1(ind) = 255;
  c2=zeros(m,n);
  c3=zeros(m,n);
  level(1,4)=s7; 
                           
  ind = find((BIchange<0) & (ndvichange>0) & (s>th));
  s8 =  numel(ind);     
  [m,n] = size(s);                              % taking s Size 
  g1=zeros(m,n);
  g1(ind) = 255;
  g2=zeros(m,n);
  g3=zeros(m,n);
  level(2,4)= s8; 
  
    % started to make bar chart
    figure('units','normalized','outerposition',[0 0 1 1])
    bar3(level,0.5);
    axis square
    xlabel('Showing conditions')
    ylabel('showing unchange or change giving thershold')
    zlabel('Amount of pixel corresponding to each')
    title('Bar Showing No of pixel unchange(1) and changed(2) and 1 to 4 showing condition which are represented in table respectfully ')
     
    % to show amount of pixels for each in near of bar
        u = level(2,1);
        v = level(2,2);
        w = level(2,3);
        x = level(2,4);
        y = level(1,4) + level(1,3)  + level(1,2) + level(1,1);
        str1 = sprintf('Amount of Net production is zero = %f', u);
        str2 = sprintf('Amount of Neglection of resources  = %f', v);
        str3 = sprintf('Amount of Non sustainable production = %f', w);
        str4 = sprintf('Amount of Sustainable production = %f', x);
        str5 = sprintf('Amount of no change = %f', y);
        text(7,0.9,str1)
        text(7,1.2,str2)
        text(6.9,1.4,str3)
        text(6.8,1.6,str4)
        text(6.7,1.8,str5)
           
    
        % figure to show all three map befor, after and masked Map
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(131)  
        imshow(cat(3,imadjust(A(:,:,3)),imadjust(A(:,:,2)),imadjust(A(:,:,1))));
        hp = impixelinfo;
        set(hp,'Position',[5 1 300 20]);
        subplot(132)  
        imshow(cat(3,imadjust(B(:,:,3)),imadjust(B(:,:,2)),imadjust(B(:,:,1))));
        hp = impixelinfo;
        set(hp,'Position',[300 1 300 20]);
  if(p==1)
    % Display right image so as to superimpose my mask on it
    subplot(133)
    imshow(cat(3,imadjust(A(:,:,3)),imadjust(A(:,:,2)),imadjust(A(:,:,1))));
    title('Colors as decribed in table in report no change green')
    
   
    % marking different colours as per different conditions given by report
    % green when no change,Net production is zero represented by white,Neglection of resources 
    % by red,Non sustainable production represented by yellow,Sustainable
    % production, would be represented by blue.
    hold on
    
    h = imshow(cat(3,c2,c1,c3));                    %showing green image on our previous image but 
    set(h,'AlphaData',0.5)                          %with some translucent value so that we can see what distruction has occured
   
    h = imshow(cat(3,d2,d3,d1));                    %showing white image on our previous image but
    set(h,'AlphaData',0.5)                          %with some translucent value so that we can see what was there befor.
   
    h = imshow(cat(3,e1,e2,e3));                    %showing red image on our previous image but
    set(h,'AlphaData',0.5)                          %with some translucent value so that we can see what was there befor.
    
    h = imshow(cat(3,f1,f2,f3));                    %showing yellow image on our previous image but
    set(h,'AlphaData',0.5)                          %with some translucent value so that we can see what was there befor.
    
    h = imshow(cat(3,g3,g2,g1));                    %showing blue image on our previous image but
    set(h,'AlphaData',0.5)                          %with some translucent value so that we can see what was there befor.
    
    
    hold off
    hp2 = impixelinfo;                              % to calculating pixel value
    set(hp2,'Position',[700 1 300 20]);
    end
        
end
     
 end


