clear all;
% Initializing parameters
N=530;
Sk=[0.08, 0.12, 0.011];
Vk=[1, 0.75, 10];
Z=120;
% Computing the Demand for each station
Dk = Vk .* Sk;
fprintf("Demands: \n");
fprintf("Demand for the Moodle Server: %g \n", Dk(1));
fprintf("Demand for the file Server: %g \n", Dk(2));
fprintf("Demand for the DB Server: %g \n", Dk(3));
% Simulating the Closed Model System up to N jobs(students)
Nk=[0, 0, 0];
for n=1:N
    Rk=(1+Nk).*Dk;
    %Response Time with n jobs     
    Rn=sum(Rk);
    %Throughput with n jobs
    Xn=n/(Rn+Z);
    Nk=Rk*Xn;
end
fprintf("System Throughput: %d \n", Xn);
fprintf("System Response Time: %d \n", Rn);
% Computing the Utilization for each station
Uk = Dk*Xn;
fprintf("Utilizations: \n");
fprintf("Utilization for the Moodle Server: %g \n", Uk(1));
fprintf("Utilization for the file Server: %g \n", Uk(2));
fprintf("Utilization for the DB Server: %g \n", Uk(3));
% Computing the average number of students "not thinking"
NNz=sum(Nk);
fprintf("Number of students not thinking: %g \n", NNz);