clear all;
% Initializing Parameters
% Arrival Rates from outside
l_IN = [10; 0; 5];
% Service Times for each station
Sk = [0.085; 0.075; 0.06];
% Probability routings matrix
P=[0, 1, 0;
   0, 0, 1;
   0, 0, 0];
% Total Arrival Rate from outside (throughput)
l_0 = sum(l_IN);
fprintf("Throughput: %g \n", l_0);
% Computing the Arrival Rate for each station
l_k = inv(eye(3) - P') * l_IN;
% Computing the Visit Rate for each station
Vk = l_k / l_0;
fprintf("Visit rates: \n");
fprintf("Visit rate for the Web Server: %g \n", Vk(1));
fprintf("Visit rate for the DB Server: %g \n", Vk(2));
fprintf("Visit rate for the Storage Server: %g \n", Vk(3));
% Computing the Demand for each station
Dk = Vk .* Sk;
fprintf("Demands: \n");
fprintf("Demand for the Web Server: %g \n", Dk(1));
fprintf("Demand for the DB Server: %g \n", Dk(2));
fprintf("Demand for the Storage Server: %g \n", Dk(3));
% Computing the Utilization for each station
Uk = l_0 * Dk;
fprintf("Utilizations: \n");
fprintf("Utilization for the Web Server: %g \n", Uk(1));
fprintf("Utilization for the DB Server: %g \n", Uk(2));
fprintf("Utilization for the Storage Server: %g \n", Uk(3));
% Computing the Average Number of Jobs for each station
Nk = Uk ./ (1 - Uk);
fprintf("Average number of jobs: \n");
fprintf("Average number of jobs for the Web Server: %g \n", Nk(1));
fprintf("Average number of jobs for the DB Server: %g \n", Nk(2));
fprintf("Average number of jobs for the Storage Server: %g \n", Nk(3));
% Computing the Residence Time for each station
Rk = Dk ./ (1- Uk);
% Computing the Number of jobs in the system
N = sum(Nk);
% Computing the Average Response Time of the system
R = sum(Rk);
fprintf("System Response Time: %g \n", R);

