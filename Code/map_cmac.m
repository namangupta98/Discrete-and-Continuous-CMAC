function [ map ] = map_cmac( X, w, A )
% Function to associate all sensors cells of CMAC and assign weights to
% one.

if (A > w) || (A < 1) || (isempty(X))
    map = [];
    return
end

% Input Vector
x = linspace(min(X),max(X),w-A+1)';

% Look Up Table
look_table = zeros(length(x),w);
for i=1:length(x)
    look_table(i,i:A+i-1) = 1;
end

% Weights
W = ones(w,1);

% Map
map = cell(3,1);
map{1} = x;
map{2} = look_table;
map{3} = W;
map{4} = A;

end
