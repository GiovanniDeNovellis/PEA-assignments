clear all;

% MM1
% Initializing parameters
l=50;
D=0.015;
m=1/D;
fprintf("MM1 \n");
% Computing total utilization
p_mm1=l*D;
fprintf("Total utilization: %g \n", p_mm1);
% Computing the probability of having exactly one job in the system
pi1_mm1=p_mm1*(1-p_mm1);
fprintf("Prob exactly one job: %g \n", pi1_mm1);
% Computing the probability of having less than four jobs in the system
piMoreThan3_mm1=p_mm1^4;
piLessThan4_mm1=1-piMoreThan3_mm1;
fprintf("Prob less than four jobs: %g \n", piLessThan4_mm1);
% Computing the average queue length
Qlen_mm1=(p_mm1^2)/(1-p_mm1);
fprintf("Average queue length: %g \n", Qlen_mm1);
% Computing the average response time
R_mm1=D/(1-p_mm1);
fprintf("Average response time: %g \n", R_mm1);
% Computing the probability that the response time is > than 0.5s
pt05_mm1=exp(-0.5/R_mm1);
fprintf("Prob of response time >0.5 s: %g \n", pt05_mm1);
% Computing the 90th percentile of the response time distribution
theta90=-log(1-9/10)*R_mm1;
fprintf("90th percentile of response time: %g \n", theta90);


fprintf("MM2 \n");
% MM2
l=85;
c=2;
p_mm2=l/(2*m);
% Computing the utilization
U=l/m;
fprintf("Total utilization: %g \n", U);
% Computing the average utilization
Uavg=U/2;
fprintf("Average utilization: %g \n", Uavg);
% Computing the probability of having exactly one job in the system
pi0_mm2=(1-p_mm2)/(1+p_mm2);
pi1_mm2=2*pi0_mm2*p_mm2;
fprintf("Prob exactly one job: %g \n", pi1_mm2);
% Computing the probability of having less than four jobs in the system
pi2_mm2=2*pi0_mm2*p_mm2^2;
pi3_mm2=2*pi0_mm2*p_mm2^3;
pi4_mm2=pi0_mm2+pi1_mm2+pi2_mm2+pi3_mm2;
fprintf("Prob less than four jobs: %g \n", pi4_mm2);
% Computing the average queue length
Nqmm2=(2*p_mm2)/(1-p_mm2^2);
Qlen_mm2=Nqmm2-U;
fprintf("Average queue length: %g \n", Qlen_mm2);
% Computint the average response time
R_mm2=D/(1-p_mm2^2);
fprintf("Average response time: %g \n", R_mm2);

