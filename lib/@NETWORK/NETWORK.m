classdef NETWORK
	%NETWORK network is a network of NODEs that represent states in a dynamic programming problem 
	%   Detailed explanation goes here
	properties
		parameters;
		size = [];
		costNetwork = {};
		connectionNetwork = {};
		evaluatedNetwork = {};
	end
	
	methods (Static)
		network = generateCostNetwork(parameters, transitionFunction, testValue)
		network = generateConnectionNetwork(costNetwork,parameters)
		network = evaluateConnections(costNetwork,connectionNetwork,parameters)
	end
	methods
		function obj = NETWORK(parameters, transitionFunction, testValue)
			%NETWORK builds a blank network as described by the parameters
			%data structure
			%   NETWORK accepts the parameters data structure which should
			%   contain: states, actions
			obj.costNetwork = obj.generateCostNetwork(parameters, transitionFunction, testValue);
			obj.connectionNetwork = obj.generateConnectionNetwork(obj.costNetwork,parameters);
			obj.evaluatedNetwork = obj.evaluateConnections(parameters,obj.costNetwork,obj.connectionNetwork);
		end
	end
end

