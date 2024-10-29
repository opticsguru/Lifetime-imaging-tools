function TPSF = plotTPSFdata(fileprefix, src_pos, dlyrange, npix, rebinflag, varargin)

if isempty(varargin)
    pix = round(ginput(1));
else
    pix = varargin{1};
end
%pix = [65,110];
%pix = [60,77]
%DarkImage = loadimage(sprintf([fileprefix,'.bin']));
%######  NEW way with mat files #####################################
if isequal (exist ([fileprefix,'_01.mat']), 2 ) %there is a matfile.

    filename1 = sprintf([fileprefix,'_%02d.mat'], 1);
    details = whos('-file', filename1', 'Image_matrix');
    num_sources_included=details.size(1); % tells us how many sources are in this matfile

    %based on the given src_pos, which mat file should be opened?
    if isequal (src_pos, 0) %then there is only one source, open the first matfile
        mat_file_to_open=0;
        filename1 = sprintf([fileprefix,'_%02d.mat'],1);
    else

        mat_file_to_open = ceil( src_pos/ num_sources_included );

        filename1 = sprintf([fileprefix,'_%02d.mat'], mat_file_to_open);
    end
    load (filename1, 'Image_matrix');
    load (filename1, 'delay'); %delay is a vector



    [tf, loc]=ismember (dlyrange, delay); %loc are the indecies of dealy where you find the values of delay1

    for kk=1:size(loc,2) %sum up each image for each delay range
        image1= squeeze(Image_matrix( (src_pos-((num_sources_included*mat_file_to_open)-(num_sources_included-1)  )+1  ), :, :, loc(kk) ));
        if size(image1,1)==1024 & rebinflag==1
            image1 = imresize(image1,1/4,'bilinear') ;
        end

        TPSF(kk) = sum(sum(image1(pix(2) - npix : pix(2) + npix, pix(1) - npix : pix(1) + npix)));
    end

else
    % OLD way with bin files  #########################################


    ll=0;
    for delay = dlyrange;
        ll = ll+1;
        filename1 = sprintf([fileprefix,'_s%03d_%05dps.IMX'], round(src_pos), round(delay));
        %filename1 = sprintf([fileprefix,'_%05d.bin'],  round(1e12*delay));
        if exist(filename1)~=2
            filename1 = sprintf([fileprefix,'_s%03d_%05dps.bin'], round(src_pos), round(delay));
            image1 = readbin(filename1) ;%- DarkImage;
            if size(image1,1)==1024 & rebinflag==1
                image1 = imresize(readbin(filename1),1/4,'bilinear') ;
            end
        else
            image1 = readimx(filename1) ;%- DarkImage;
            image1 = image1.Data;
        end
        TPSF(ll) = sum(sum(image1(pix(2) - npix : pix(2) + npix, pix(1) - npix : pix(1) + npix)));
    end
    %figure

end % old vs new
if nargin > 6
    if (varargin{2})==1
%         plott(dlyrange*1e-12,TPSF/max(TPSF),varargin{3}, varargin{4});     %MK edites Varagin{4} doesnot exist
          plott(dlyrange*1e-12,TPSF/max(TPSF),varargin{3}); 
    else
%         plott(dlyrange*1e-12,TPSF,varargin{3}, varargin{4});  %MK edites Varagin{4} doesnot exist
         plott(dlyrange*1e-12,TPSF,varargin{3});
    end
end
save curr_tpsf  TPSF dlyrange
