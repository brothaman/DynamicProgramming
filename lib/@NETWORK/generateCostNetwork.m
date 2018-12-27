function network = generateCostNetwork(parameters, transitionFunction, testValue)
	%GENERATE_NETWORK generate all possible states and state transitions
	%	generates a network of nodes for dynamic programming
	%	parameters
	%	-	States: an cell of nx1 arrays containing the discrete values of
	%		each state variable
	%	Transition Function should be the handle of a funciton that when
	%	given a state and an action returns a new state and a cost
	
	% initialize array containing the number of states 
	%	[ N_1 N_2 ... N_(n-1) N_n]
	S = zeros(size(parameters.states));
	for i = 1:length(parameters.states)
		S(i) = length(parameters.states{i});
	end
	parameters.S = S;
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% unit test 1 
	if testValue == 1
		network = S;
		return
	end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	% use the array of N_i states to generate a 
	%	{N_1 x N_2 x ... x N_(n-1) x N_n} network of nodes
	network = cell(S);
	network(:) = {NODE};
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% unit test 1 
	if testValue == 2
		return
	end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	% initialize each of the nodes with their state 
	network = initialize_nodes(parameters, network);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% unit test 3 
	if testValue == 3
		return
	end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	% evaluate each of the states to find connections to other states
	network = evaluateTransitions(network,parameters,transitionFunction);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% unit test 4 
	if testValue == 4
		return
	end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%% functions
function network = initialize_nodes(parameters, network)
	sz = size(network);
	for i = 1:prod(sz)
		network{i}.ID = ind2arrsub(sz,i);
        network{i}.state = extract_state(network{i}.ID, parameters.states);
	end
end

function network = evaluateTransitions( network, parameters, transitionFunction)
	for i = 1:numel(network)
		for j = 1:numel(parameters.actions)
			[new_state, J] = transitionFunction(network{i}.state, parameters.actions(j), parameters);
			connection = [new_state parameters.actions(j) J];
			
			index = getIndexForNewConnection(network{i}.connections, connection);
			if index
				network{i}.connections{index} = connection;
			else
				continue;
			end
		end
	end
end

%% Extra Functions
function index = getIndexForNewConnection(existingConnections, connection)
	if isempty(existingConnections)
		index = 1;
		return
	end
	for index = 1:length(existingConnections)
		conn = compareConnection(existingConnections{index}, connection);
		switch conn
			case -1
				% the connections reach the same state but the original
				% connection is better
				index = 0;
				return
			case 0
				% there is no match
				continue
			case 1
				% the connections reach the same state and the new
				% connection is better. return the current index
				return
			otherwise
				% the only values in con should be -1,0,1 if anything else 
				% return error
		end
	end
	% the loop will only make it this far if the new connection is unique
	% in that case create a new spot
	index = index+1;
end

function verdict = compareConnection(connection1, connection2)
	state1 = connection1(1:end-2);
	cost1  = connection1(end-1);
	state2 = connection2(1:end-2);
	cost2  = connection2(end-1);
	if sum(state1 - state2) == 0
		% then connection 1 and connection 2 reach the same state
		if cost1 < cost2
			verdict = -1;
		else 
			verdict = 1;
		end
	else
		verdict = 0;
	end
		
end

function arrsub = ind2arrsub(sz,index)
	asz = [1 sz(1:end-1)];
	arrsub = zeros(size(sz));
	for i = length(sz):-1:1
		arrsub(i) = floor((index-1)/prod(asz(1:i)))+1;
		index = index -  (arrsub(i)-1) * prod(asz(1:i));
	end
end

function index = arrsub2ind(sz,arrsub)
	alteredsize = [1 sz(1:end-1)];
	index=1;
	for i = 1:length(arrsub)
		index = index + (arrsub(i)-1)*prod(alteredsize(1:i));
	end
end

function arr = extract_state(arrsub, states)
	arr = nan(size(states));
	for i = 1:length(states)
		arr(i) = states{i}(arrsub(i));
	end
end