function next_position = move(position,seed,num,nei)
global gridientMap;
global character;
global imx;
global imy;
a=position(1);
b=position(2);

grid = gridientMap(a,b,:);
grid = grid(:);
grid = grid.*character(1:4,num);
for i=1:4
    if(nei(i)==true)
        grid(i) = grid(i)*character(5,num);
    end
end

%grid = (grid-min(grid))/(max(grid)-min(grid));
if(min(grid)<0)
     grid = grid-2*min(grid);
end
%grid = grid/sum(grid);

grid(2) = grid(1)+grid(2);
grid(3) = grid(2)+grid(3);
grid(4) = grid(3)+grid(4);

seed = seed*grid(4);
if(seed>=grid(3))
    b = b+1;
elseif(seed>=grid(2))
    a = a+1;
elseif(seed>=grid(1))
    b = b-1;
else
    a = a-1;
end

if(a>1&a<imx&b>1&b<imy)
    next_position=[a,b];
else
    next_position=position;
end