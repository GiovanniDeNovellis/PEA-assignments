clear all;

filename = 'Log4.csv';
interA_times = csvread(filename);

nA = size(interA_times,1);
% The average inter arrival time is the sum of the inter arrival times /
% number of jobs
avg_inter_arrival = sum(interA_times,1)/nA;
% The arrival rate is 1/avg_inter_arrival
lambda = 1/avg_inter_arrival;
% Computing the standard deviation of the inter arrival times with the
% built in function
s = std(interA_times);
% Building the table with arrival and completion timestamps
sz = [nA 2];
varTypes = ["double", "double"];
AC = table('Size',sz,'VariableTypes',varTypes);
% Each arrival time is the sum of the previous inter arrival times.
for i=2:nA
    AC(i,1) = {sum(interA_times(1:i-1))};
end
AC(1,2) = {1.2};
% Each completion time is calculated with the following formula, using the
% current arrival time, the previous completion time and the service time
% (fixed to 1.2 in this case)
for i=2:nA
    AC(i,2)={max(AC{i,1}, AC{i-1,2}) + 1.2};
end
% Each response time is the difference between the completion and arrival
% time of a job.
sum_response = sum(AC{:, 2} - AC{:,1});
% The average response time is calculated as sum(response_times)/num_jobs
average_response = sum_response/(nA);
% Here we are building points having as coordinates successive inter
% arrival times to plot them and see the distribution and the eventual
% correlation.
XY = [interA_times(1:end-1,1),  interA_times(2:end,1)];

fprintf("File: %s\n", filename);
fprintf("Average inter arrival time: %g \n", avg_inter_arrival);
fprintf("Arrival rate: %g \n", lambda);
fprintf("Standard deviation of inter arrival times: %g \n", s);
fprintf("Average response time: %g \n", average_response);
plot(XY(:,1), XY(:,2), ".");

% We can see that in case of the Log2 and Log3, even if the arrival
% rate is similar (0.50 and 0.54) since the variability of Log3 is more
% than the double of the one of Log2 also the response time is way higher
% (2.0 and 5.4).
% Also we can notice that the Log4 file, in which some correlation can be 
% graphically seen because of the packing of the points between themselves,
% has the highest average response time of all the logs, with 25.6 seconds          
% (more than 5 times the second highest average response time).