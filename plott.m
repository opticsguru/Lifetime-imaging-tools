function plott(x,y,opt,varargin)


if nargin>4
    linetype=varargin{1};
else
    linetype='b';
end

all_colors = [1 0 0; 0 1 0; 0 0 1; 1 0 1; 0 1 1; 0.5 0 0.5; 0.5 0 1; 1 0 0.5; 1 0.2 0.7; 0.2 1 0.5; 1 0.5 0];

if str2double(varargin) == 1
    randomIndex = randi(length(all_colors), 1);
    if opt == 0
        plot(x,y,linetype,'Color',all_colors(randomIndex,:));
    else
        plot(x,log(y),linetype,'Color',all_colors(randomIndex,:));
    end
else
    if opt == 0
        plot(x,y,linetype,'Color',[0 0 0]);
    else
        plot(x,log(y),linetype,'Color',[0 0 0]);
    end
end
