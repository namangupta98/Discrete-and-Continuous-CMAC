function [ accuracy ] = test_cmac( mapp, testingData, state )
% Function to test CMAC


if isempty(mapp) || isempty(testingData)
    accuracy = NaN;
    return
end

% Input w.r.t. input vectors
inpt  = zeros(length(testingData),2);
for i=1:length(testingData)
    if testingData(i,1) > mapp{1}(end)
        inpt(i,1) = length(mapp{1});
    elseif testingData(i,1) < mapp{1}(1)
        inpt(i,1) = 1;
    else
        temp = (length(mapp{1})-1)*(testingData(i,1)-mapp{1}(1))/(mapp{1}(end)-mapp{1}(1)) + 1;
        inpt(i,1) = floor(temp);
        if (ceil(temp) ~= floor(temp)) && state
            inpt(i,2) = ceil(temp);
        end
    end
end

% Accuracy
num = 0;
den = 0;
for i=1:length(inpt)
    if inpt(i,2) == 0
        outpt = sum(mapp{3}(find(mapp{2}(inpt(i,1),:))));
        num = num + abs(testingData(i,2)-outpt);
        den = den + testingData(i,2) + outpt;
    else
        d1 = norm(mapp{1}(inpt(i,1))-testingData(i,1));
        d2 = norm(mapp{2}(inpt(i,2))-testingData(i,1));
        outpt = (d2/(d1+d2))*sum(mapp{3}(find(mapp{2}(inpt(i,1),:))))...
               + (d1/(d1+d2))*sum(mapp{3}(find(mapp{2}(inpt(i,2),:))));
        num = num + abs(testingData(i,2)-outpt);
        den = den + testingData(i,2) + outpt;
    end
    Y(i) = outpt;
end
error = abs(num/den);
accuracy = 100 - error;

[X,I] = sort(testingData(:,1));
Y = Y(I);
plot(X,Y);


end
