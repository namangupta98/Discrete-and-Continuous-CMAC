function [ map, iterat, finalError, t ] = train_cmac( mapp, trainingData, E, state )
% Function to train CMAC
tic; % Starts the stopwatch

map = mapp;  % CMAC map stored in map variable
if isempty(map) || isempty(trainingData) || isempty(E)
    return  % if no map and no training data, then  exit
end

% Input w.r.t. input vectors
inpt  = zeros(length(trainingData),2);
for i=1:length(trainingData)
    if trainingData(i,1) > map{1}(end)
        inpt(i,1) = length(map{1});
    elseif trainingData(i,1) < map{1}(1)
        inpt(i,1) = 1;
    else
        temp = (length(map{1})-1)*(trainingData(i,1)-map{1}(1))/(map{1}(end)-map{1}(1)) + 1;
        inpt(i,1) = floor(temp);
        if (ceil(temp) ~= floor(temp)) && state
            inpt(i,2) = ceil(temp);
        end
    end
end

lr = 0.025; % learning rate
err = Inf;
iterat = 0;
cnt = 0;
while (err > E)&&(2*cnt <= iterat)
    old_err = err;
    iterat = iterat + 1;
    
    % Output for each input and adjusts weights accordingly
    for i=1:length(inpt)
        if inpt(i,2) == 0
            outpt = sum(map{3}(find(map{2}(inpt(i,1),:))));
            err = lr*(trainingData(i,2)-outpt)/map{4};
            map{3}(find(map{2}(inpt(i,1),:))) = map{3}(find(map{2}(inpt(i,1),:))) + err;
        else
            d1 = norm(map{1}(inpt(i,1))-trainingData(i,1));
            d2 = norm(map{1}(inpt(i,2))-trainingData(i,1));
            outpt = (d2/(d1+d2))*sum(map{3}(find(map{2}(inpt(i,1),:))))...
                    + (d1/(d1+d2))*sum(map{3}(find(map{2}(inpt(i,2),:))));
            err = lr*(trainingData(i,2)-outpt)/map{4};
            map{3}(find(map{2}(inpt(i,1),:))) = map{3}(find(map{2}(inpt(i,1),:)))...
                                                    + (d2/(d1+d2))*err;
            map{3}(find(map{2}(inpt(i,2),:))) = map{3}(find(map{2}(inpt(i,2),:)))...
                                                    + (d1/(d1+d2))*err;            
        end
    end

    % Final error
    num = 0;
    den = 0;
    for i=1:length(inpt)
        if inpt(i,2) == 0
            outpt = sum(map{3}(find(map{2}(inpt(i,1),:))));
            num = num + abs(trainingData(i,2)-outpt);
            den = den + trainingData(i,2) + outpt;
        else
            d1 = norm(map{1}(inpt(i,1))-trainingData(i,1));
            d2 = norm(map{1}(inpt(i,2))-trainingData(i,1));
            outpt = (d2/(d1+d2))*sum(map{3}(find(map{2}(inpt(i,1),:))))...
                   + (d1/(d1+d2))*sum(map{3}(find(map{2}(inpt(i,2),:))));
            num = num + abs(trainingData(i,2)-outpt);
            den = den + trainingData(i,2) + outpt;
        end
    end
    err = abs(num/den);
    if abs(old_err - err) < 0.00001
        cnt = cnt + 1;
    else
        cnt = 0;
    end
end
iterat = iterat - cnt;

% Final error
num = 0;
den = 0;
for i=1:length(inpt)
    if inpt(i,2) == 0
        Y(i) = sum(map{3}(find(map{2}(inpt(i,1),:))));
        num = num + abs(trainingData(i,2)-Y(i));
        den = den + trainingData(i,2) + Y(i);
    else
        d1 = norm(map{1}(inpt(i,1))-trainingData(i,1));
        d2 = norm(map{1}(inpt(i,2))-trainingData(i,1));
        Y(i) = (d2/(d1+d2))*sum(map{3}(find(map{2}(inpt(i,1),:))))...
               + (d1/(d1+d2))*sum(map{3}(find(map{2}(inpt(i,2),:))));
        num = num + abs(trainingData(i,2)-Y(i));
        den = den + trainingData(i,2) + Y(i);
    end
end
finalError = abs(num/den);
[X,I] = sort(trainingData(:,1));
Y = Y(I);
t = toc;

end
