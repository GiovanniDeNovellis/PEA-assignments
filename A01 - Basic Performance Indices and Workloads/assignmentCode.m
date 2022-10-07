clear all;

% Reading the data
data = readtable('apache1.log','FileType','text');
% At the end of the log file the number of arrivals and completions
% is the same, the number of rows of the file.
nA = size(data, 1);
nC = size(data, 1);

% This table will be used to compute the response time of each job.
response_matrix = [data(:,4), data(:, 11)];
% This table will be used to compute the number of jobs queued in the
% system at each time interval.
sz = [2*nA 3];
varTypes = ["datetime","double", "double"];
queueTable = table('Size',sz,'VariableTypes',varTypes);

% The computing of the response times works like this:
% If i am considering the first job in the system, then it's immediately
% served and therefore response_time=service_time.
% For every other job in the system:
% If the starting timestamp of the previous job + its response time (already
% computed) is greater than the starting timestamp of the current one then
% the current job won't be served immediately and the response time is
% computed as last_job_start_date + last_job_response_time -
% current_job_start_time + current_job_service_time.
% Else the current job is immediately served and
% response_time=service_time.
% In this cycle I also save every start - end timestamp in the queue table
% for later.
for i=2:nA
    curJobStartDate = datetime(response_matrix{i, 1}, "InputFormat","[dd/MMM/yyyy:HH:mm:ss.SSS");
    curJobServiceTime = response_matrix{i, 2};
    lastJobStartDate = datetime(response_matrix{i-1, 1}, "InputFormat","[dd/MMM/yyyy:HH:mm:ss.SSS");
    lastJobResponseTime = response_matrix{i-1, 2};
    lastJobEndDate = lastJobStartDate + seconds(lastJobResponseTime/1000);
    queueTable(i-1,1) = {lastJobStartDate};
    queueTable(nA+i-1, 1) = {lastJobEndDate};
    queueTable(i-1,2) = {1};
    queueTable(nA+i-1, 2) = {-1};
    if lastJobEndDate>curJobStartDate
        curJobResponseTime = (seconds(lastJobEndDate-curJobStartDate) + curJobServiceTime/1000)*1000;
        response_matrix(i,2) = {curJobResponseTime};
    end    
end
first_arrival_time = datetime(data{1, "Var4"}, "InputFormat","[dd/MMM/yyyy:HH:mm:ss.SSS");
last_arrival_time = datetime(data{nA, "Var4"}, "InputFormat","[dd/MMM/yyyy:HH:mm:ss.SSS");
last_time = last_arrival_time + seconds(response_matrix{nA, 2}/1000);
% The total time is computed as last_job_arrival + last_job_response -
% first_job_arrival
total_time = seconds(last_time-first_arrival_time);
queueTable(nA,1) = {last_arrival_time};
queueTable(nA,2)={1};
queueTable(2*nA,1)={last_time};
queueTable(2*nA,2)={-1};
% The queue table has all the arrival-end timestamps as the first column
% with a +1 for the arrivals and -1 for the endings on the second column.
% Sorting the timestamps in ascending time.
sorted_queue_table = sortrows(queueTable,1);
% The number of jobs queued on each time interval is the sum of the second
% column(+1 arrivals -1 endings) up to the considered interval.
sorted_queue_table{:,3} = cumsum(sorted_queue_table{:,2});
% The time spent by the system with N jobs queued is calculated iterating
% the queue table with the desired parameter.
time_0_jobs= calcTimeNJobs(0, sorted_queue_table);
time_1_jobs= calcTimeNJobs(1, sorted_queue_table);
time_2_jobs= calcTimeNJobs(2, sorted_queue_table);
time_3_jobs= calcTimeNJobs(3, sorted_queue_table);
% The probability of having N jobs in the system is calculated as
% total_time_with_N_jobs / total time.
prob_0_jobs = time_0_jobs/total_time;
prob_1_jobs = time_1_jobs/total_time;
prob_2_jobs = time_2_jobs/total_time;
prob_3_jobs = time_3_jobs/total_time;

% The arrival rate is computed as total_num_arrivals/total_time
lambda = nA/total_time;
% The throughput is computed as total_num_completions/total_time
X = nC/total_time;
% The average inter arrival time is computed as 1/arrival_rate
avg_inter_arrival_time = 1/lambda;
% The busy time is computed as the sum of the service times (given by the
% log file)
busy_time = sum(data{:,"Var11"})/1000;
% The utilization is computed as busy_time/total_time
utilization = busy_time/total_time;
% The average service time is computed as the
% total_busy_time/number_completions
average_service_time = busy_time/nC;

% The W is computed as the sum of all the response times.
W = sum(response_matrix{:,2})/1000;
% The average number of jobs is computed as W/total_time.
avg_number_jobs = W/total_time;
% The average response time is computed as W/number_completions.
avg_response_time = W/nC;
% The probability of having a response time < X is the (sum of all the
% response times < X) / number_of_completions
pr1s = sum(response_matrix{:, 2}<1000)/nC;
pr5s = sum(response_matrix{:, 2}<5000)/nC;
pr10s = sum(response_matrix{:, 2}<10000)/nC;


fprintf("Total time: %g \n", total_time);
fprintf("Arrival Rate: %g, Throughput %g\n", lambda, X);
fprintf("Average inter arrival time: %g\n", avg_inter_arrival_time);
fprintf("Total busy time: %g\n", busy_time);
fprintf("Utilization: %g\n", utilization);
fprintf("Average service time: %g\n", average_service_time);
fprintf("Total W: %g\n", W);
fprintf("Average number of jobs: %g\n", avg_number_jobs);
fprintf("Average response time: %g\n", avg_response_time);
fprintf("Probability of response < 1s: %g\n", pr1s);
fprintf("Probability of response < 5s: %g\n", pr5s);
fprintf("Probability of response < 10s: %g\n", pr10s);
fprintf("Probability of having 0 jobs in the system: %g \n", prob_0_jobs);
fprintf("Probability of having 1 jobs in the system: %g \n", prob_1_jobs);
fprintf("Probability of having 2 jobs in the system: %g \n", prob_2_jobs);
fprintf("Probability of having 3 jobs in the system: %g \n", prob_3_jobs);

% This function iterates through the sorted queue table and sums all the
% time intervals spent by the sistem with exactly X jobs queued.
function time_x = calcTimeNJobs(x, sorted_queue_table)
     time_x=0;
     for i=1:2001
         if sorted_queue_table{i,3}==x
            dateprev = sorted_queue_table{i,1};
            datesucc = sorted_queue_table{i+1,1};
            time_x= time_x + seconds(datesucc-dateprev);
         end    
     end
end