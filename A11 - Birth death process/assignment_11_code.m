clear all;

% Initializing parameters
N=16;
N0=8;
l0=200;
% M is fixed for all time instants
m=100;


pn = zeros(1, N+1);
pd = zeros(1, N+1);

pn(1,1) = 0;
pd(1,1) = 0;

% Simulating the system as a bith death process
for i=1:N
	if i-1 < N0
		lim1 = l0;
	else
		lim1 = l0*((N-i)/(N-N0));
    end
	pn(1, i+1) = pn(1,i) + log(lim1);
	pd(1, i+1) = pd(1,i) + log(m);
end

% Determining and plotting the distribution of the buffer occupation
p = exp(pn(1:end-1) - pd(2:end));
p = p / sum(p);
plot([1:N], p, "-");