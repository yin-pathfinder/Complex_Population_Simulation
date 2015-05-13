clear

global gridientMap;
global character;
global imx;
global imy;

%basic consts
step = 500;
numAll = 500;
reproduceRate = 15;
lifeLong = 300;
pubertyPeriod = [40,80];
%randReproduce = floor(rand(1,numAll)*4+2);
n = 5;

%map initialize
[im,gridientMap] = mapInit();

%position initialize
posInit=[];
px = 2:20:imx-1;
py = 2:20:imy-1;
sizepy = size(py);
for i=py
    posInit=[posInit,[px;repmat(i,1,sizepy(2))]];
end
sizePosition = size(posInit);

%scale of creatures
num = sizePosition(2);


%basic variables
sizeIm = size(im);
imx = sizeIm(1);
imy = sizeIm(2);
lifeAll = lifeLong*ones(1,num);
reproduceCD = 0*ones(1,num);

character = NaN(5,num);
neiMap = zeros(imx,imy);
neiJudge = neiMap;
hormoneMap = zeros(imx,imy);
hormoneJudge = hormoneMap;
hormoneChaMap = hormoneMap;
newNum = num;
countReproduce = 1;
numList = 1:num;


%creature random value initialize
[randRoute,character(:,1:num)] = creatureInit(num,step);
picJudge = ones(imx,imy);
picRoute = picJudge;
coord = nan(2,num);

%fist step
dstep = 1;
for dnum = 1:num
    x = posInit(1,dnum);y = posInit(2,dnum);
    picJudge(x,y) = 0;
    neiJudge(x,y) = dnum;
    nei = [neiJudge(x,y+1),neiJudge(x-1,y),...
        neiJudge(x,y-1),neiJudge(x+1,y)];
    nei((nei~=dnum)&(nei~=0)) = true;
    nei((nei==dnum)|(nei==0)) = false;
    coord(:,dnum)=move([x,y],randRoute(dstep,dnum),dnum,nei);
end
picRoute = picJudge.*picRoute;
picJudge = ones(imx,imy);

%next steps

for dstep = 2:step
    for dnum = numList
        
        %basic functions, including neighbour judging and moving.
        x = coord(1,dnum);y = coord(2,dnum);
        life = lifeAll(dnum);
        CD = reproduceCD(dnum);
        picJudge(x,y) = 0;
        neiMap(x,y) = dnum;
        nei = [neiJudge(x,y+1),neiJudge(x-1,y),...
            neiJudge(x,y-1),neiJudge(x+1,y)];
        nei((nei~=dnum)&(nei~=0)) = true;
        nei((nei==dnum)|(nei==0)) = false;
        %coord(:,dnum)=move(coord(:,dnum),randRoute(dstep,dnum),dnum,nei);
        coord(:,dnum)=move(coord(:,dnum),rand,dnum,nei);
        
        %death
        life = life - im(x,y)/5;
        lifeAll(dnum) = life;
        if(life <= 0)
            numList(numList==dnum)=[];
        else
            %reproduce
            if((life>(lifeLong - pubertyPeriod(2))) ...
                    && (life<(lifeLong - pubertyPeriod(1))) )
                
                if((hormoneJudge(x,y)~=0) ...
                        && (hormoneJudge(x,y)~=life) ...
                        && (CD >= reproduceRate))
                    newNum = newNum +1;
                    
                    character(:,newNum) = reproduce(...
                        character(:,dnum),...
                        characterJudge(:,hormoneChaJudge(x,y)),...
                        floor(rand*4+2));
                    %randReproduce(countReproduce));
                    
                    countReproduce = countReproduce+1;
                    coord(:,newNum) = [x;y];
                    lifeAll(:,newNum) = 60;
                    reproduceCD(:,newNum) = 60;
                    CD = 0;
                else
                    CD = 1+CD;
                end
                
                xMin = x-n;xMax = x+n;
                yMin = y-n;yMax = y+n;
                if(xMin<1) 
                    xMin=1;end
                if(yMin<1) 
                    yMin=1;end
                if(xMax>imx) 
                    xMax=imx;end
                if(yMax>imy) 
                    yMax=imy;end
                
                
                hormone = hormoneMap(xMin:xMax,yMin:yMax);
                hormoneC = hormoneChaMap(xMin:xMax,yMin:yMax);
                
                hormoneC(hormone < life) = dnum;
                hormone(hormone < life) = dnum;
                hormoneMap(xMin:xMax,yMin:yMax) = hormone;
                hormoneChaMap(xMin:xMax,yMin:yMax) = hormoneC;
            end
        end
        reproduceCD(dnum) = CD;
    end
    picRoute = picJudge.*picRoute+1;
    neiJudge = neiMap;
    hormoneJudge = hormoneMap;
    hormoneChaJudge = hormoneChaMap;
    hormoneMap = zeros(imx,imy);
    hormoneChaMap = zeros(imx,imy);
    neiMap = zeros(imx,imy);
    picJudge = ones(imx,imy);
    
    
    lifeAll = [lifeAll(numList),lifeAll(dnum+1:newNum)];
    if(length(lifeAll)>10000)
        fprintf('It is too many of them');
        break;
    else
        if(length(lifeAll)<4)
            fprintf('They are all dead, mourn for a while');
            break;
        end
    end
    
    
    reproduceCD = [reproduceCD(numList),reproduceCD(dnum+1:newNum)];
    characterJudge = character;
    character = [character(:,numList),character(:,dnum+1:newNum)];
    coord = [coord(:,numList),coord(:,dnum+1:newNum)];
    numList = 1:length(character);
    newNum = numList(end);
    
    
    pause(0.1);
    imshow(picRoute,[1,100]);
end
subplot(1,2,1)
imshow(picRoute,[1,100]);
subplot(1,2,2)
mesh(im);
