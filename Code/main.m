clear all
close all
clc

x = (linspace(0,10))';
y = sqrt(x);
N = randperm(100);  % Creates a vector of 100 randomly permuted evenly spaced points.f
train_data = [x(N(1:70)),y(N(1:70))];
test_data = [x(N(71:100)),y(N(71:100))];

for i=1:30
        cmac = map_cmac(x,35,i); % Creates a CMAC map
        figure
        plot(x,y);
        hold on
        [map,iterat(1,i),~,T(1,i)] = train_cmac(cmac,train_data,0,0); % Trains Discrete CMAC
        accuracy(1,i) = test_cmac(map,test_data,0);  %Tests Discrete CMAC
        hold off
        legend('Function','Discrete Output');
        title(['CMAC Overlap Area = ' num2str(i)]);
        figure
        plot(x,y);
        hold on
        [map,iterat(2,i),~,T(2,i)] = train_cmac(cmac,train_data,0,1);  % Trains Continuous CMAC
        accuracy(2,i) = test_cmac(map,test_data,1);  % Tests Continuous CMAC
        hold off
        legend('Function','Continuous Output');
        title(['CMAC Continuous Iteration = ' num2str(i)]);
end

t = 1:30;
figure()  % Plot Convergence Time of both CMAC
plot(t, T(1,:), t, T(2,:))
title('Convergence Time')
xlabel('No. of Iterations')
ylabel('Time')
legend('Discrete','Continuous')

figure()  % Plot Accuracy of both CMAC
plot(t, accuracy(1,:), t, accuracy(2,:))
title('Accuracy')
xlabel('No. of Iterations')
ylabel('Perentage')
legend('Discrete Accuracy', 'Continuous Accuracy')