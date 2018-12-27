classdef NETWORK
	%NETWORK network is a network of NODEs that represent states in a dynamic programming problem 
	%   Detailed explanation goes here
	properties
		parameters;
		size = [];
		costNetwork = {};
		connectionNetwork = {};
	end
	
	methods (Static)
% 		network = generateCostNetwork(parameters, transitionFunction, testValue)
		network = generateCostNetwork(parameters, transitionFunction, testValue)
	end
	methods
		function obj = NETWORK(parameters, transitionFunction, testValue)
			%NETWORK builds a blank network as described by the parameters
			%data structure
			%   NETWORK accepts the parameters data structure which should
			%   contain: states, actions
			obj.costNetwork = obj.generateCostNetwork(parameters, transitionFunction, testValue);
			obj.parameters = parameters;
		end
		
% 		function outputArg = method1(obj,inputArg)
% 			%METHOD1 Summary of this method goes here
% 			%   Detailed explanation goes here
% 			outputArg = obj.Property1 + inputArg;
% 		end
	end
end

