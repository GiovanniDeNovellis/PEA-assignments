clear all;
% M/G/1
% Initializing parameters
l=500;
rate_1=1500;
rate_2=1000;
% Computing first and second moment of the service time distribution
D=1/rate_1 + 1/rate_2;
second_moment=2*(1/rate_1^2 + 1/(rate_1*rate_2) + 1/rate_2^2);
% Computing the utilization of the system
rho_MG1=l*D;
% Computing average response time and average number of jobs
R_MG1=D+(l*second_moment)/(2*(1-rho_MG1));
N_MG1=rho_MG1+((l^2)*second_moment)/(2*(1-rho_MG1));
fprintf("M/G/1 \n");
fprintf("Utilization: %g \n", rho_MG1);
fprintf("Average Response time: %g \n", R_MG1);
fprintf("Average number of jobs: %g \n", N_MG1);
% G/G/2
% Initializing parameters
l=4000;
k=4;
c=2;
% Computing average inter arrival time considering the Erlang distribution
T=k/l;
% Computing average utilization
rho_GG2=D/(c*T);
% Computing Coefficient of Variation for Arrival Times
Ca=1/sqrt(k);
% Computing Coefficient of Variation for Service Times
Cv=sqrt(rate_1^2 + rate_2^2)/(rate_1+rate_2);
% Computing Average Response Time using the Kingsman formula and average
% number of jobs
R_GG2=D+((Ca^2 + Cv^2)/2)*((D*(rho_GG2^2))/(1-rho_GG2^2));
N_GG2=R_GG2/T;
fprintf("G/G/2 \n");
fprintf("Utilization: %g \n", rho_GG2);
fprintf("Average Response time: %g \n", R_GG2);
fprintf("Average number of jobs: %g \n", N_GG2);



