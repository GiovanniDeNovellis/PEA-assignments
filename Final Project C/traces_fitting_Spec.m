clear all;
% Fitting Specification Traces using Method of Moments with some of the 
% distributions of the slides and available on JMT:
% Uniform, Exponential, 2-Stages HyperExponential, Erlang
data = csvread("Traces/TraceC-Spec.txt");
% Calculating the moments
N=size(data,1);
M1 = sum(data)/N;
M2 = sum(data .^ 2)/N;
M3 = sum(data .^ 3)/N;
F_hyperExp_MM = @(p) [
        (p(1,3)/p(1,1) + (1-p(1,3))/p(1,2))/M1 - 1; 
        (2*(p(1,3)/p(1,1).^2 + (1-p(1,3))/(p(1,2).^2)))/M2 - 1;
        (6*(p(1,3)/p(1,1).^3 + (1-p(1,3))/(p(1,2).^3)))/M3 - 1;
        ];
% Uniform
a_unif = M1 - 0.5 * sqrt(12*(M2 - M1 .^ 2));
b_unif = M1 + 0.5 * sqrt(12*(M2 - M1 .^ 2));
fprintf("Uniform a: %d \n", a_unif);
fprintf("Uniform b: %d \n", b_unif);
% Exponential
lambda_exp = 1/M1;
cV = sqrt(M2 - M1.^2) / M1;
fprintf("Lambda Exponential: %d \n", lambda_exp);
fprintf("Cv: %d \n", cV);
% 2-Stages HyperExponential
if cV<1
    fprintf("Cv<1, HyperExponential Unfeasible \n");
else
    % Solving HyperExponential equations to get parameters     
    result_hyperExp_MM = fsolve(F_hyperExp_MM, [0.8/M1, 1.2/M1, 0.4]);
    fprintf("HyperExponential Lambda-1: %g \n", result_hyperExp_MM(1,1));
    fprintf("HyperExponential Lambda-2: %g \n", result_hyperExp_MM(1,2));
    fprintf("HyperExponential p: %g \n", result_hyperExp_MM(1,3));  
end
% Erlang
k_erlang = round(1/(cV^2));
lambda_erl = k_erlang/M1;
fprintf("Erlang k: %d \n", k_erlang);
fprintf("Lambda Erlang: %d \n", lambda_erl);
% Gamma
gamma_shape=1/(cV^2); %a
gamma_scale=M1/gamma_shape; %b
% Plotting
t = [0:1000];
y2unif_MM=max(0, min(1, (t-a_unif)/(b_unif-a_unif)));
y2exp_MM = 1 - exp(-lambda_exp*t);
syms n;
y2_erlang_MM = 1 - symsum((1/factorial(n)).*exp(-lambda_erl*t).*((lambda_erl.*t).^n) ,n, 0, k_erlang-1);
y2_gam = gamcdf(t, gamma_shape, gamma_scale);
if cV >=1
    y2Hyperexp_MM = 1 -result_hyperExp_MM(1,3)*exp(-result_hyperExp_MM(1,1)*t) ...
        -(1-result_hyperExp_MM(1,3))*exp(-result_hyperExp_MM(1,2)*t);
    figure(1);
    plot(sort(data(:,1)), [1:50000]/50000, "+", t, y2exp_MM, "-", t, y2Hyperexp_MM, "-", t, y2unif_MM, "-", t, y2_erlang_MM, "-");
    legend('Data', 'Exponential', 'HyperExponential', 'Uniform', 'Erlang');
    axis([0 1000 0 1]);
    title('Method of moments');
else
    figure(1);
    plot(sort(data(:,1)), [1:50000]/50000, "+", t, y2exp_MM, "-", t, y2unif_MM, "-", t, y2_erlang_MM, "-");
    legend('Data', 'Exponential','Uniform','Erlang');
    axis([0 1000 0 1]);
    title('Method of moments');
end