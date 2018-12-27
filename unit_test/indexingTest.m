b = [3 4];
c = {[1:3]' 3+[1:4]'};
% i -> n
% j -> m
% k -> p
% (i-1)*n + (j-1)*m
n=3;
m=8;
p=5;
A = rand (n,m);
sz = size(A);
arr = A(:);
B = zeros(sz);

for i = 1:numel(A)
	arrsub = ind2arrsub(sz,i)
	arrsub2ind(sz,arrsub(:))
	B(arrsub2ind(sz,arrsub(:))) = A(i);
end
sum(sum(sum(A==B))) == numel(A)

%% Functions
function arrsub = ind2arrsub(sz,index)
	alteredsize = [sz(2:end) 1];
	arrsub = zeros(size(sz));
	for i = 1:length(sz)
		arrsub(i) = floor((index-1)/prod(alteredsize(i:end)))+1;
		index = index -  (arrsub(i)-1) * prod(alteredsize(i:end));
	end
end
function index = arrsub2ind(size,arrsub)
	alteredsize = [size(2:end) 1];
	index=1;
	for i = 1:length(arrsub)
		index = index + (arrsub(i)-1)*prod(alteredsize(i:end));
	end
end