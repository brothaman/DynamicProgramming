%% test generate node function - generate blank unfilled network
testValue = 2;
parameters.states = {(1:100)'/100*pi-pi/2 (-6:.1:6)'};
net = NETWORK(parameters, 1, testValue);