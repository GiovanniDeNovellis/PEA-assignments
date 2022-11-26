clear all;
% M/M/1/16
% Initializing parameters
K=16;
l=1200;
D=0.00125;
m=1/D;
r=l/m;
% Computing the average utilization
U_MM1=(r-r^(K+1))/(1-r^(K+1));
% Computing probability of having 14 jobs in the system
p0=(1-r)/(1-r^(K+1));
p14_MM1=p0*(r^14);
pk=(r^K-r^(K+1))/(1-r^(K+1));
% Computing the average number of packets in the system
N_MM1=r/(1-r)-((K+1)*r^(K+1))/(1-r^(K+1));
% Computing Throughput and Drop Rate
Dr_MM1=l*pk;
X_MM1=l-Dr_MM1;
% Computing the average response time
R_MM1=N_MM1/(l*(1-pk));
% Computing the average time spent in queue
TqAvg_MM1=R_MM1-D;

fprintf("M/M/1/16 \n");
fprintf("Average Utilization: %g \n", U_MM1);
fprintf("Probability of having 14 packets in the system: %g \n", p14_MM1);
fprintf("Average number of packets in the system: %g \n", N_MM1);
fprintf("Throughput: %g \n", X_MM1);
fprintf("Drop Rate: %g \n", Dr_MM1);
fprintf("Average Response Time: %g \n", R_MM1);
fprintf("Average Time spent in queue: %g \n", TqAvg_MM1);

% M/M/2/16
% Initializing parameters
r=l/(2*m);
c=2;
% Computing probabilities
% Computing p0
probs(1,1)=((((c*r)^c)/(factorial(c)))*((1-r^(K-c+1))/(1-r))+1+c*r)^(-1);
% Computing other probabilities
for i=1:K
    if i<=2
        probs(1,i+1)=(probs(1,1)/factorial(i))*((c*r)^i);
    else
        probs(1,i+1)=(probs(1,1)*(c^c)*(r^i))/factorial(c);
    end
end
% Computing the average utilization
U_MM2=0;
for i=1:K
    if i<=c
        U_MM2=U_MM2+i*probs(1,i+1);
    else
        U_MM2=U_MM2+c*probs(1,i+1);
    end
end
U_MM2=U_MM2/c;
% Computing the probability of having 14 jobs in the system
p14_MM2=probs(1,15);
% Computing the average number of packets in the system
N_MM2=0;
for i=1:K
    N_MM2=N_MM2+i*probs(1,i+1);
end
% Computing the Drop Rate and the Throughput
Dr_MM2=l*probs(1,K+1);
X_MM2=l*(1-probs(1,K+1));
% Computing the average response time
R_MM2=N_MM2/(l*(1-probs(1,K+1)));
% Computing the average time spent in queue
TqAvg_MM2=R_MM2-D;

fprintf("M/M/2/16 \n");
fprintf("Average Utilization: %g \n", U_MM2);
fprintf("Probability of having 14 packets in the system: %g \n", p14_MM2);
fprintf("Average number of packets in the system: %g \n", N_MM2);
fprintf("Throughput: %g \n", X_MM2);
fprintf("Drop Rate: %g \n", Dr_MM2);
fprintf("Average Response Time: %g \n", R_MM2);
fprintf("Average Time spent in queue: %g \n", TqAvg_MM2);









