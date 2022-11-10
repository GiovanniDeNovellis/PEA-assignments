clear all;

% Initializing parameters
l1=1/10;
m1=1/50;
m2=1/5;
l3=1/20;
m3=1/2;
% State reward vectors:
% Power consumption rewards:
%        s1  s2  s3  s4 
alpha1=[0.1, 2,  10, 0.5];
% Utilization rewards:
%       s1  s2  s3  s4
alpha2=[0,  1,  1,  1];

% s1=Idle
% s2=CPU
% s3=GPU
% s4=I/O
%   s1        s2           s3       s4
Q=[ -l1   ,   l1       ,   0   ,    0   ; %s1
     m1   , -m1-l3-l1  ,   l3  ,    l1  ; %s2
     0    ,   m3       ,  -m3  ,    0   ; %s3
     0    ,   m2       ,   0   ,   -m2 ]; %s4

%The system always starts in Idle state
p0=[1,0,0,0];

% Compute the state probabilities as a function of time
[t, Sol] = ode45(@(t,x) Q'*x, [0 500], p0');

% Plotting the state probabilities
figure(1);
plot(t, Sol, "-");
legend("Idle", "CPU", "GPU", "I/O");

Q_old=Q;
Q(:,1) = ones(4,1);
% Compute the steady state probabilities
pi = p0 * inv(Q);

% Compute the steady state solution for the state rewards
Power_SteadyState = Sol(end,:) * alpha1';
Utilization_SteadyState = Sol(end,:) * alpha2';

% Plotting the state rewards
figure(2);
plot(t, Sol * alpha1', "-", t, Sol * alpha2', "-");
legend("Power", "Utilization");

% Transition reward matrix for the system throughput
             % s1 s2 s3 s4
Q_S_throughput=[0, 0, 0, 0 ; %s1
                1, 0, 0, 0 ; %s2
                0, 0, 0, 0 ; %s3
                0, 0, 0, 0]; %s4

% Transition reward matrix for the GPU throughput
               % s1 s2 s3 s4
Q_GPU_throughput=[0, 0, 0, 0 ; %s1
                  0, 0, 0, 0 ; %s2
                  0, 1, 0, 0 ; %s3
                  0, 0, 0, 0]; %s4

% Transition reward matrix for the I/O frequency
             % s1 s2 s3 s4
Q_IO_frequency=[0, 0, 0, 0 ; %s1
                0, 0, 0, 0 ; %s2
                0, 0, 0, 0 ; %s3
                0, 1, 0, 0]; %s4

% Computing the transition rewards as a function of time
X_S=sum((sum((Q_old.*Q_S_throughput)') .* Sol)');
X_GPU=sum((sum((Q_old.*Q_GPU_throughput)') .* Sol)');
X_IO=sum((sum((Q_old.*Q_IO_frequency)') .* Sol)');

% Computing the steady state solution for the transition rewards
X_S_SteadyState=sum((sum((Q_old.*Q_S_throughput)') .* Sol(end,:))');
X_GPU_SteadyState=sum((sum((Q_old.*Q_GPU_throughput)') .* Sol(end,:))');
X_IO_SteadyState=sum((sum((Q_old.*Q_IO_frequency)') .* Sol(end,:))');

% Plotting the transition rewards
figure(3);
plot(t, X_S, "-", t, X_GPU, "-", t, X_IO, "-");
legend("System thoughput", "GPU throughput", "IO frequency");

