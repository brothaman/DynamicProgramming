classdef NODE
	%NODE a component of a network that stores information about the model
	%   A node is a container that store information about the current
	%   state of the system as well as the future states in the form:
	%	ID - an array of values that correlate to the nodes reference
	%	state - a container store information about the current state of
	%		the system
	%	optimal_policy - the best next step
	%	optimal_value - store the total cost to go from the current state
	%		to the goal
	%	version - stores the number of updates the current node has
	%		recieved
	properties
		ID = [];
        state = [];
        connections = {};
        optimal_policy = {};
        optimal_value  = [];
        version = [];
	end
end

