%% test generate node function - initialize nodes with IDs and States
testValue = 3;
parameters.States = {(1:100)'/100*pi-pi/2 (-6:.1:6)'};
net = NETWORK(parameters,1,testValue);
values = net.costNetwork;
a = ones(100,121);
for i = 1:100
	for j = 1:121
		a(i,j) = sum(values{i,j}.ID - [i,j]);
	end
end
if sum(sum(a)) == 0
	disp('Nodes properly initializing with IDs and States')
end