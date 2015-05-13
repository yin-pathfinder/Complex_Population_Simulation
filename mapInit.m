function [im,gridientMap] = mapInit()
%im = single(imread('1.jpeg'));
t=1:512;
% [x,y]=meshgrid(t/64);
[x,y]=meshgrid(t/256+3);

% im = 2000*sin(x.^2+y.^2)./(x.^2+y.^2);
% im = 50*ones(512);
 im = x+y;
sizeIm = size(im);
x = sizeIm(1);
y = sizeIm(2);

gridientMap = nan(x,y,4);
for dx = 2:x-1
    for dy = 2:y-1
        diff = [im(dx,dy+1),im(dx-1,dy),...
            im(dx,dy-1),im(dx+1,dy)];
        diff = diff/im(dx,dy);
        gridientMap(dx,dy,:) = diff;
    end
end
gridientMap = (gridientMap - 1)*10^4;