%% test generate node function - initialize nodes with IDs and States
testValue = 4;
parameters.states = {(1:100)'/100*pi-pi/2 (-6:.1:6)'};
parameters.actions = 1:10;
net = NETWORK(parameters,@transitionFunction,testValue);
unit_test_network = net.costNetwork;

function [state,J] = transitionFunction(state0, action, parameters)
	state = [1 1];
	J = 10*(state - state0)*(state - state0)';
end