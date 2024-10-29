function image = plotRawImagenew(src1,det1,delay1,fileprefix,range,axhandle, rebinflag, brightestpixelsflag, varargin )
GG=waitbar(0,'Loading images...');

% if nargin > 6
%     normconst = varargin{1};
% else
normconst = 1;
% end
%figure
if nargin==9
    if ~isempty(varargin{1})
        grayimage=varargin{1};
    end
end

set(gcf, 'Doublebuff','off')
image = [];
ii = 0;
dark = 0;
%dark = loadimage([fileprefix,'.bin']);
%load srcpixpossep0803;


%############# new way with bin files  ########### ########################

if isequal (exist ([fileprefix,'_01.mat']), 2 ) %there is a matfile.
    
    %src1 is a range as is delay1
    filename1 = sprintf([fileprefix,'_%02d.mat'], 1);
    details = whos('-file', filename1', 'Image_matrix');
    num_sources_included=details.size(1); % tells us how many sources are in this matfile
    
    first_time=1;
    for src_pos = src1
        
        if isequal (src_pos, 0) %then there is only one image, usually a "freespace"
            filename1 = sprintf([fileprefix,'_%02d.mat'], 1);
            load (filename1, 'Image_matrix');
            load (filename1, 'delay'); %delay is a vector
            mat_file_to_open=0; %so the m
        else
            % which mat file is this source in?
            
            % if its the same one, dont open it again...
            if first_time
                mat_file_to_open=0;
            end
            
            
            %for each source, load the correct mat file
            if ~isequal(mat_file_to_open, ceil(src_pos/ num_sources_included))
                mat_file_to_open = ceil( src_pos/ num_sources_included );
                filename1 = sprintf([fileprefix,'_%02d.mat'], mat_file_to_open);
                load (filename1, 'Image_matrix');
                load (filename1, 'delay'); %delay is a vector
            end
        end
        
        for det = det1 % this is always 1
            % for delay = delay1 %for loop non needed
            
            [tf, loc]=ismember (delay1, delay); %loc are the indecies of dealy where you find the values of delay1
            
            for kk=1:size(loc,2) %sum up each image for each delay range
                if isequal(brightestpixelsflag, 1)
                    thresh=0.2;
                    if isequal( first_time,1)
                        first_time=0;
                        image= squeeze(Image_matrix( (src_pos-((num_sources_included*mat_file_to_open)-(num_sources_included-1)  )+1  ), :, :, loc(kk) ));
                        if size(image,1)==1024 & rebinflag==1
                            image = imresize(image,1/4,'bilinear') ;
                        end
                        image2=medfilt2(image,[2 2]);
                        mask=(image2 > thresh*max(max(image2))); %all the data above a threshold
                        image = (image .* mask);
                    else
                        image1= squeeze(Image_matrix( (src_pos-((num_sources_included*mat_file_to_open)-(num_sources_included-1)  )+1  ), :, :, loc(kk) ));
                        if size(image1,1)==1024 & rebinflag==1
                            image1 = imresize(image1,1/4,'bilinear') ;
                        end
                        image2=medfilt2(image1,[2 2]);
                        mask=(image2 > thresh*max(max(image2))); %all the data above a threshold
                        image1 = (image1 .* mask);
                        image= image+ image1;
                    end
                else
                    if isequal( first_time,1)
                        first_time=0;
                        image= squeeze(Image_matrix( (src_pos-((num_sources_included*mat_file_to_open)-(num_sources_included-1)  )+1  ), :, :, loc(kk) ));
                        if size(image,1)==1024 & rebinflag==1
                            image = imresize(image,1/4,'bilinear') ;
                        end
                    else
                        image1=squeeze(Image_matrix( (src_pos-((num_sources_included*mat_file_to_open)-(num_sources_included-1)  )+1  ), :, :, loc(kk) ));
                        
                        if size(image1,1)==1024 & rebinflag==1
                            image1 = imresize(image1,1/4,'bilinear') ;
                        end
                        image= image+ image1;
                    end
                end
                
                
            end
            
            
        end
    end
    
    
else
    %############# OLD way with bin files  sad sad sad ########################
    
    
    
    filename1 = sprintf([fileprefix,'_s%03d_%05dps.IMX'], round(src1(1)), round(delay1(1)));
    if exist(filename1)==2
        for src_pos = src1
            for det = det1
                for delay = delay1
                    ii = ii + 1;
                    filename1 = sprintf([fileprefix,'_s%03d_%05dps.IMX'], round(src_pos), round(delay));
                    if ii ==1
                        image =  readimx(filename1) ;
                        image = image.Data;
                        [foox,fooy] = find(image ~= max(max(image))/1);
                        image([foox,fooy]) = 0;
                        %         if isempty(range),range = [min(min(image-dark)),max(max(image-dark))];,end;
                        %	imagesc((image - dark)/normconst,range);colorbar;title(num2str(src_pos));pause(1);
                        TDimage(src_pos,:,:,ii)=image;
                    else
                        image1 = readimx(filename1);
                        image1 = image1.Data;
                        %	[foox,fooy] = find(image1  ~= max(max(image1))/1);
                        %	image1([foox,fooy]) = 0;
                        image = image + image1;
                        TDimage(src_pos,:,:,ii)=image1;%added by anand 12/22/12;line 145 exports current full TD image into workspace
                        %				imagesc((image1 - dark)/normconst,range);colorbar;title(num2str(src_pos));pause(1);
                    end
                    
                    %text(32,91,'X','FontSize',10,'FontWeight','Bold','Color',[ 0 0 0])
                end
            end
        end
        assignin('base','TDimage',squeeze(TDimage));
    else
        %check to see if user wants thresholded image instead of sum.
        %#####################################################################
        thresh=.2;
        if isequal(brightestpixelsflag, 1)
            for src_pos = src1
                for det = det1
                    for delay = delay1
                        ii = ii + 1;
                        filename1 = sprintf([fileprefix,'_s%03d_%05dps.bin'], round(src_pos), round(delay));
                        if ii ==1
                            image =  readbin(filename1) ;
                            if size(image,1)==1024 & rebinflag==1
                                image = imresize(readbin(filename1),1/4,'bilinear') ;
                            end
                            [foox,fooy] = find(image ~= max(max(image))/1);
                            image([foox,fooy]) = 0;
                            image2=medfilt2(image,[2 2]);
                            mask=(image2 > thresh*max(max(image2))); %all the data above a threshold
                            image = (image .* mask);
                            %         if isempty(range),range = [min(min(image-dark)),max(max(image-dark))];,end;
                            %	imagesc((image - dark)/normconst,range);colorbar;title(num2str(src_pos));pause(1);
                        else
                            image1 =  readbin(filename1);
                            if size(image1,1)==1024 & rebinflag==1
                                image1 = imresize(readbin(filename1),1/4,'bilinear') ;
                            end
                            % keep onlythe bright portion of images
                            image2=medfilt2(image1,[2 2]);
                            mask=(image2 > thresh*max(max(image2))); %all the data above a threshold
                            image = image + (image1 .* mask);
                            
                            
                        end
                    end
                end
            end
        else  %################################################################
            for src_pos = src1
                waitbar(src_pos/length(src1));
                for det = det1
                    for delay = delay1
                        ii = ii + 1;
                        filename1 = sprintf([fileprefix,'_s%03d_%05dps.bin'], round(src_pos), round(delay));
                        if ii ==1
                            image =  readbin(filename1) ;
                            if size(image,1)==1024 & rebinflag==1
                                image = imresize(readbin(filename1),1/4,'bilinear') ;
                            end
                            [foox,fooy] = find(image ~= max(max(image))/1);
                            image([foox,fooy]) = 0;
                            %         if isempty(range),range = [min(min(image-dark)),max(max(image-dark))];,end;
                            %	imagesc((image - dark)/normconst,range);colorbar;title(num2str(src_pos));pause(1);
                        else
                            image1 =  readbin(filename1);
                            if size(image1,1)==1024 & rebinflag==1
                                image1 = imresize(readbin(filename1),1/4,'bilinear') ;
                            end
                            %	[foox,fooy] = find(image1  ~= max(max(image1))/1);
                            %	image1([foox,fooy]) = 0;
                            image = image + image1;
                            %				imagesc((image1 - dark)/normconst,range);colorbar;title(num2str(src_pos));pause(1);
                        end
                        %text(32,91,'X','FontSize',10,'FontWeight','Bold','Color',[ 0 0 0])
                    end
                end
            end
        end
        
        
    end
    
    
end %#########################################################################
close (GG); %this is is for the waitbar

if isempty(range)| isequal( range, 0),range = [min(min(image-dark)),max(max(image-dark))];,end;
if nargin==9
    if ~isempty(varargin{1})
        figure(101); imagesc(grayimage);colormap gray;brighten(.8);colormapGray = colormap;close
        figure(101);imagesc(normconst*(image-dark),range);colormap default;colormapcolor = colormap;close
        axes(axhandle);overlayc(grayimage,normconst*(image-dark),colormapGray,colormapcolor,.4);refresh
    end
else
    imagesc(normconst*(image-dark),range);
    %     h = get(gcf);set(h.Children(1),'YDir','Normal');axis image % dont
    %     know why this syntax was used.. but was causing errors.
    set(axhandle,'YDir','Normal');axis image
    %    saveas(gcf,'curr_image','fig')
    %   save curr_im image
end




%colorbar;title([fileprefix,' at  ',num2str(delay)]);axis image
%for src_pos = src1
%    text(XY(src_pos,2),XY(src_pos,1),['*'],'FontSize',8,'FontWeight','Bold','Color',[ 0 0 0]);
%end
%to make a movie
% ll = 0,for ii = 2800 : 100 : 5100 ,ll = ll + 1,plotrawimagenew(4:11,1,[ii]*1e-12,'miniICG770ex830filtB',[0 6000]);,...
%        MM(ll) = getframe(gcf),pause(.01),end
