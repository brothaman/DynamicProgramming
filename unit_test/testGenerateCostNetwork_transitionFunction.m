%% test generate node function - initialize nodes with IDs and States
testValue = 4;
parameters.states = {(1:100)'/100*pi-pi/2 (-6:.1:6)'};
parameters.actions = 1:10;
% values = generateCostNetwork(parameters, @transitionFunction, testValue);
% a = ones(100,121);
% for i = 1:100
% 	for j = 1:121
% 		a(i,j) = sum(values{i,j}.ID - [i,j]);
% 	end
% end
% if sum(sum(a)) == 0
% 	disp('Nodes properly initializing with IDs and States')
% end
net = NETWORK(parameters,@transitionFunction,testValue);
unit_test_network = net.costNetwork;

function [state,J] = transitionFunction(state0, action, parameters)
	state = [1 1];
	J = 10*(state - state0)*(state - state0)';
end