clear all;
% Initializing parameters
% Arrival rates per class
lam=[5; 10];
% Demands per class and station
Dck=[0.05, 0.1; 0.06, 0.04];
% Computing the Utilization of the two servers
% Utilization per class and station
Uck = Dck .* [lam lam];
% Utilization per class(columns)
Uk=sum(Uck);
% Computing the Throughput per class
Xc= lam;
% Computing the Total Throughput
X= sum(Xc);
% Computing the Residence Time  the two servers
% Residence Time per class and station
Rck= Dck ./ (1- [Uk; Uk]);
% Residence Time per station
Rk=sum(Xc ./ [X; X] .* Rck);
% Computing the System Response Time
R= sum(Rk);
fprintf("Utilization of CRM: %g \n", Uk(1));
fprintf("Utilization of FS: %g \n", Uk(2));
fprintf("Residence Time of CRM: %g \n", Rk(1));
fprintf("Residence Time of FS: %g \n", Rk(2));
fprintf("System Response Time: %g \n", R);