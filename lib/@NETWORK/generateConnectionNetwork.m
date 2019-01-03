function [connectionNetwork] = generateConnectionNetwork(costNetwork,parameters)
	%GENERATECONNECTIONNETWORK Summary of this function goes here
	%   Detailed explanation goes here
	allConnections = getConnectionsfromCostNetwork(costNetwork);
	connectionNetwork = build_connection_network( parameters, allConnections);
end
%% Functions
function connectionNetwork = build_connection_network( parameters, all_connections)
	storedConnections = [];
	for i = 1:size(parameters.goal,1)
		connections{i} = network_search(all_connections, parameters.goal(i,:), []);
	end
	
	newConnections = cell2mat(connections);
	connectionNetwork{1} = newConnections;
	storedConnections = [storedConnections; newConnections];
	L = (size(storedConnections,2))/2;
	
	troo = true;
	while troo
		[newConnections, storedConnections] = build_stage_for_connection_network(newConnections(:,1:L), all_connections, storedConnections);
		connectionNetwork{end+1} = newConnections;

		% stopping criteria
		% ---	if there are no new connections
		if size(newConnections,1) == 0 
			troo = false;
		end
		
		% ---	if the number of stored connections equals the number of connecitons
		if size(storedConnections,1) == size(all_connections,1)
			troo = false;
		end
	end
	
end

function [newConnections, storedConnections] = build_stage_for_connection_network(idsToSearch, all_connections, storedConnections)
	for i = 1:size(idsToSearch,1)
		connections{i} = network_search(all_connections, idsToSearch(i,:), storedConnections);
	end
	newConnections = cell2mat(connections');
	storedConnections = [storedConnections; newConnections];
end

function connections = network_search(all_connections, idToSearch, storedConnections)
	L = (length(all_connections(1,:))-2)/2;
	connections = all_connections(~any(all_connections(:,L+1:end-2) - idToSearch,2),:);
	connections = connections(:,1:end-2);
	
	for i = 1:size(connections,1)
		% check for duplicate connections in network
		if checkIfConnectionisinConnectionNetwork(connections(i,:), storedConnections)
			connections(i,:) = [];
		end
	end
end

function isit = checkIfConnectionisinConnectionNetwork(connection, storedConnections)
	isit = false;
	if isempty(storedConnections)
		return
	end
	
	if sum(~any(storedConnections - connection,2))
		isit = true;
		return
	end
end

function [all_connections] = getConnectionsfromCostNetwork(network)
	all_connections = [];
	for i = 1:numel(network)
		for j = numel(network{i}.connections)
			all_connections(end+1,:) = [network{i}.ID network{i}.connections{j}];
		end
	end
end