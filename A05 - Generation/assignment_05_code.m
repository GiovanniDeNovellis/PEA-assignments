clear all;

data = csvread("random.csv");
N= size(data(:,1));
N=N(1);
% Point 1
a_unif=5;
b_unif=15;
% Generating Uniform Samples
for k=1:N
    r = data(k,2);
    res_uniform(k,1) = a_unif + (b_unif-a_unif)*r;
end
t=[0:15];
% Analytical Uniform 
analytical_unif=max(0, min(1, (t-5)/(15-5)));
figure(1);
plot(sort(res_uniform), [1:N]/N, "-", t, analytical_unif , "-");
legend('Uniform', 'Analytical Uniform');

% Point 2
Pr = [0.3, 0.4, 0.3];
C = cumsum(Pr);
% Analytical Discrete
analytical_discrete(1:30,1) = 5;
analytical_discrete(31:70,1) = 10;
analytical_discrete(71:100,1) = 15;

% Generating Discrete Samples
for k=1:N
    r = data(k,1);
    for i=1:3
        if r < C(1,i)
            res_discrete(k,1)= 5*i;
            break;
        end
    end
end

figure(2);
plot(sort(res_discrete), [1:N]/N, "+", analytical_discrete, [1:100]/100, "+");
legend('Discrete', 'Analytical Discrete');

% Point 3
average = 10;
lambda_exp = 1/average;

% Generating Exponential Samples
for k=1:N
    r = data(k,2);
    res_exponential(k,1) = -log(r)/lambda_exp;
end
t=[0:100];
% Analytical Exponential
analytical_exp = 1 -exp(-lambda_exp*t);
figure(3);  
plot(sort(res_exponential), [1:N]/N, "-", t, analytical_exp, "-");
legend('Exponential', 'Analytical Exponential');

% Point 4
lambda=[0.05, 0.175];
p=[0.3, 0.7];
C=cumsum(p);

% Generating HyperExponential Samples
for k=1:N
    rand1=data(k,1);
    rand2=data(k,2);
    for i=1:2
        if rand1<=C(1,i)
            res_hyperExp(k,1) = -log(rand2)/lambda(1,i);
            break;
        end
    end
end
t=[0:80];
% Analytical HyperExponential
analytical_hyperExp = 1 -p(1,1)*exp(-lambda(1,1)*t) -p(1,2)*exp(-lambda(1,2)*t);
figure(4);
plot(sort(res_hyperExp), [1:N]/N, "-", t, analytical_hyperExp, "-");
legend('HyperExponential', 'Analytical HyperExponential');

% Point 5
lambda1=0.25;
lambda2=0.16667;
% Generating HypoExponential Samples
for k=1:N
    rand1 = data(k,2);
    rand2 = data(k,3);
    res_hypo(k,1) = -log(rand1)/lambda1 -log(rand2)/lambda2;
end
t=[0:80];
% Analytical HypoExponential
analytical_hypo= 1- lambda2*exp(-lambda1*t)/(lambda2-lambda1) + lambda1*exp(-lambda2*t)/(lambda2-lambda1);
figure(5);
plot(sort(res_hypo), [1:N]/N, "-", t, analytical_hypo, "-");
legend('HypoExponential', 'Analytical HypoExponential');

% Point 6
p=[0.3, 0.7];
lambda=[0.05, 0.35];
stages=[1, 2];
C=cumsum(p);

% Generating HyperErlang Samples
for k=1:N
    rand1=data(k,1);
    for i=1:2
        if rand1<C(1,i)
            res_hyperErl(k,1)=0;
            for l=1:stages(1,i)
                res_hyperErl(k,1) = res_hyperErl(k,1) -log(data(k,l+1))/lambda(1,stages(1,i));
            end
            break;
        end
    end
end
t=[0:80];
% Analytical HyperErlang
analytical_hyperErl = @(t) 1 -p(1,1)*exp(-lambda(1,1)*t) -p(1,2)*(exp(-lambda(1,2)*t) + lambda(1,2)*t.*exp(-lambda(1,2)*t));

figure(6);
plot(sort(res_hyperErl), [1:N]/N, "-", t, analytical_hyperErl(t), "-");
legend('HyperErlang', 'Analytical HyperErlang');



