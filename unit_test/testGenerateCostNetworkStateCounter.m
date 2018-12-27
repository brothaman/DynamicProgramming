%% test generate node function
testValue = 1;
parameters.States = {(1:100)'/100*pi-pi/2 (-6:.1:6)'};
net = NETWORK(parameters,1,testValue);