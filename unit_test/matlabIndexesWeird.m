b = [3 4];
A = reshape(1:12,[3,4]);
disp('In Matlab for a 3 x 4 matrix:')
for i = 1:numel(A)
	[I,J] = ind2sub([3,4], i);
	fprintf('%i -> [%i,%i]\n',i,I,J)
end
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
	asz = [1 sz(1:end-1)]
	arrsub = zeros(size(sz))
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