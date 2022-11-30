clear all;
% Initializing Parameters
% Probability routings matrix
P=[0  , 0.3, 0.2;
   1  , 0  , 0  ;
   0.2, 0.8, 0  ];
% Arrival Rates from outside
l_IN = [10; 0; 0];
% Total Arrival Rate from outside
l_0 = sum(l_IN);
% Service Times for each station
Sk = [0.04; 0.1; 0.12];

% Computing the Arrival Rate for each station
l_k = inv(eye(3) - P') * l_IN;
% Computing the Visit Rate for each station
Vk = l_k / l_0;
% Computing the Demand for each station
Dk = Vk .* Sk;
% Computing the Throughput for each station
Xk = Vk * l_0;

