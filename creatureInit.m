function [randRoute,character] = creatureInit(num,step)
randRoute = rand(step,num);

character = rand(5,num)-0.5;
% for i=1:num
%     character(1:4,i) = (randperm(4)-2.5);
% end
% character(5,:) = rand(1,num)-0.5;
end
