%% test generate network search function - initialize nodes with IDs and States
testGenerateConnectionNetwork_networksearch 
testValue = 5;
parameters.states = {(1:100)'/100*pi-pi/2 (-6:.1:6)'};
parameters.actions = 1:10;
parameters.goal = [1 1];
net = NETWORK(parameters,@transitionFunction,testValue);
unit_test_network = net.costNetwork;



function [state,J] = transitionFunction(state0, action, parameters)
	% convert the state to locations
	[~,i] = nearest2(state0(1), parameters.states{1});
	[~,j] = nearest2(state0(2), parameters.states{2});
	state0loc = [i,j];
	
	if state0loc(1) == 1
		state(1) = 2;
	else
		state(1) = state0loc(1) - 1;
	end
	
	if state0loc(2) == 1
		state(2) = 2;
	else
		state(2) = state0loc(2) - 1;
	end
	
% 	state = [parameters.states{1}(state(1)) parameters.states{2}(state(2))];
	J = 10*(state - state0loc)*(state - state0loc)';
end

function [val, n] = nearest2(val,arr) 
	vec = abs(arr - val);
	[val,n] = min(vec);
	val = arr(val == vec);
end