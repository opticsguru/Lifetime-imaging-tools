function [Output] = lifetimemap_par(image2,dlyrange,threshold,bin,t0,dlyfitrange,rebinflag, varargin)


%threshold the image
Mimage=sum(image2,3);Sm=size(Mimage);
Mindx=find(Mimage>threshold*max(max(Mimage)));
L=length(Mindx);
[MI,MJ]=ind2sub(Sm, Mindx);

Output.ImCW=Mimage;
%first choose dlyfitrange
if isempty(dlyfitrange)
    dlystep=dlyrange(2)-dlyrange(1);
    figure(333)
    semilogy(dlyrange,squeeze(sum(sum(image2(MI,MJ,:),1),2)));
    disp('select range using two button clicks')
    
    junk=ginput(2);
    begindly=junk(1,1);
    enddly=junk(2,1);
    
    for ii = 1:length(dlyrange)
        if dlyrange(ii)>begindly
            startind=ii;
            dlystart1=dlyrange(ii);
            break
        end
    end
    
    for ii = 1:length(dlyrange)
        if dlyrange(ii)>enddly
            endind=ii;
            dlyend1=dlyrange(ii);
            break
        end
    end
    dlyrange1 = dlystart1:dlystep:dlyend1;
else
    dlyrange1=dlyrange(dlyfitrange);
    startind=dlyfitrange(1);endind=dlyfitrange(end);
end

Output.amap = zeros(size(image2,1),size(image2,2));
Output.lmap = zeros(size(image2,1),size(image2,2));
Output.chisq = zeros(size(image2,1),size(image2,2));

special_number_set= [5 10 20 30 40 50 60 70 80 90 100];
Chopped_up_image2=cell(L,1);
Chopped_up_fitresults=cell(L,1);
for ii = 1:L
    %     disp(sprintf('%d %complete', ii/L*100)); pause(.0001)
    % if ( ismember(round(ii/L*100), special_number_set))
    % title(sprintf('Processing:%% %d %complete', round(ii/L*100))); pause(.0001)
    % end
    II = MI(ii); JJ = MJ(ii);
    if II - bin < 0 || (II + bin) > size(image2, 1)  ||  JJ - bin < 0  ||  (JJ + bin)  > size(image2, 2)
        bin1 = 0;
    else
        bin1 = bin;
    end
    if II > bin1 && JJ > bin1
        Chopped_up_image2{ii} = image2(II-bin1:II+bin1,JJ-bin1:JJ+bin1,:);
    else
        Chopped_up_image2{ii} =0;
    end
end
for ii = 1:L
    data11(ii,:)=squeeze(mean(mean(Chopped_up_image2{ii,1})))+0.1;
    II = MI(ii); JJ = MJ(ii);
     decay1 = normalize(squeeze(mean(mean(Chopped_up_image2{ii},1),2)));
%______________for IRF conv 1/30/20
if strcmp(t0, 'irf')
    irf = varargin{1};irf_dly = varargin{2};
    %         FitResults= fminsearchbnd('NLfit1_conv',[1, 1, 1, 1, 1],[0, 0, 0, 0, 0],[], [],...
    %             dlyrange*1e-3, 1:length(startind:endind), dlyrange(startind:endind), irf, irf_dly);
    FitResults=fminsearch('NLfit1_conv1',[data11(end), 1, .5], [],...
        dlyrange*1e-3, startind:endind, data11, irf, irf_dly);
else
    if length(dlyfitrange) <= 5 %interpolat or assume its a fast lifetime fit
        %FitResults(3)=-1e-3*(dlyrange1(2)-dlyrange1(1))./log(decay1(3)/decay1(2));
        dlyrange2 = dlyrange1(1):50:dlyrange1(end);
        decay2 = interp1(dlyrange1, decay1(startind:endind), dlyrange2);
        FitResults=fminsearch('NLfit1',[.1, 1, 1], [], dlyrange2*1e-3-t0,decay2 );
    else
        FitResults=fminsearch('NLfit1',[.1, 1, 1], [], dlyrange1*1e-3-t0,decay1(startind:endind)' );
    end
end
    %__________________end IRF conv 1/30/20
    
    Chopped_up_fitresults{ii}=FitResults;
end
for ii = 1:L
    II = MI(ii); JJ = MJ(ii);
    Output.amap(II,JJ) = Chopped_up_fitresults{ii}(2);
    Output.lmap(II,JJ) = (Chopped_up_fitresults{ii}(3));;
    Output.chisq(II,JJ)= 1; %Chopped_up_fitresults{ii}.Chisqold;
end
Output.lmap=medfilt2(Output.lmap,[3 3]);
[Output.mean,Output.std]=lifetime_stats(Output);
