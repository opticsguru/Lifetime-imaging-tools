%same as NLfit1 but with convolution
function [c]= NLfit1_conv( x1, t, dlyindrange, Data, irf, varargin)
global FitResults

if isequal (nargin,6)
    dlyrange_irf=varargin{1};
else
   dlyrange_irf=t(dlyindrange); 
end
x=x1(2:end);

if (isfield(FitResults,'Chisqold'))
cold=FitResults.Chisqold;
else
    cold=1e16;
end
% the irf and the current dataset may cover different time scales AND/or
% delay ranges. 
% make new time axis based on irf spacing from 0 to 12K (picoseceond)
t_new = 1e-3*[dlyrange_irf(1):(dlyrange_irf(2)-dlyrange_irf(1)):dlyrange_irf(1) + 12000]; 

basis = conv(exp(-(t_new - t_new(1))/x(2)), irf);

basis_new = interp1(t_new, basis(1:length(t_new)), t);

% basis = conv(exp(-(t)/x(2)), irf);
Phi0=0;
for ii = 1:size(x,2)/2
%    Phi0 = Phi0 + x(2*ii-1)*exp(-(t-x1(end))/x(2*ii));%variable t0
    Phi0 = Phi0 + x(2*ii-1)*basis_new(dlyindrange);%fixed t0
end
%add offset;
Phi0=x1(1)+Phi0;
% Data=Data(dlyindrange);
c = sum( (Phi0 - Data).^2 ./ Data);

%c = sum( (Phi0 - Data).^2);
%whos Phi0 Data
%c = sum( (Phi0 - Data).^2 );
% figure(10);subplot(2,1,1)
% set(gcf,'doublebuff','on');
% hold off
% semilogy(t(dlyindrange),Phi0,'b-')
% hold on
% semilogy(t(dlyindrange),Data,'ro')
% 
% subplot(2,1,2)
% plot(t,Phi0-Data,'ro');
% title(['Residuals, Chisq =  ', num2str(c)]);
% drawnow;
% % 
FitResults.Chisqold=c;
FitResults.x = x1;
FitResults.Phi0=Phi0;
if abs(c-cold)/cold<1e-4
    return;
end

