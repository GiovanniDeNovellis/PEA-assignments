clear all;

data = csvread("Traces.csv");
column=3;
N = size(data,1);

% Calculating the moments
M1 = sum(data(:,column))/N;
M2 = sum(data(:,column) .^ 2)/N;
M3 = sum(data(:,column) .^ 3)/N;

fprintf("First moment: %g \n", M1);
fprintf("Second moment: %g \n", M2);
fprintf("Third moment: %g \n", M3);
fprintf("Method of moment: \n");

% Uniform parameters with method of moments
a_unif = M1 - 0.5 * sqrt(12*(M2 - M1 .^ 2));
b_unif = M1 + 0.5 * sqrt(12*(M2 - M1 .^ 2));

% Exponential lambda with method of moments
lambda_exp = 1/M1;
cV = sqrt(M2 - M1.^2) / M1;

fprintf("Uniform left bound a: %g \n", a_unif);
fprintf("Uniform right bound b: %g \n", b_unif);
fprintf("Exponential rate: %g \n", lambda_exp);
fprintf("Coefficient of variation: %g \n", cV);

if cV >= 1
    fprintf("Coefficient of variation > 1, HypoExponential unfeasible");
%     Method of moments
    F_hyperExp_MM = @(p) [
        (p(1,3)/p(1,1) + (1-p(1,3))/p(1,2))/M1 - 1;
        (2*(p(1,3)/p(1,1).^2 + (1-p(1,3)/p(1,2).^2)))/M2 - 1;
        (6*(p(1,3)/p(1,1).^3 + (1-p(1,3)/p(1,2).^3)))/M3 - 1;
        ];
    % Solving HyperExponential equations to get parameters
    result_hyperExp_MM = fsolve(F_hyperExp_MM, [0.5, 0.5, 0.5]);
    fprintf("HyperExponential Lambda-1: %g \n", result_hyperExp_MM(1,1));
    fprintf("HyperExponential Lambda-2: %g \n", result_hyperExp_MM(1,2));
    fprintf("HyperExponential p: %g \n", result_hyperExp_MM(1,3));
    fprintf("Method of likelihood: \n");
%     Method of likelihood
    HyperExpPDF = @(x, l1, l2, p1) p1*l1*exp(-l1*x) + (1-p1)*l2*exp(-l2*x);
    % Applying Maximum likelihood method to HyperExponential to get parameters
    result_hyperExp_likelihood = mle(data(:, column), 'pdf', HyperExpPDF, 'start', [0.8/M1, 1.2/M1, 0.4]);
    fprintf("HyperExponential Lambda-1: %g \n", result_hyperExp_likelihood(1,1));
    fprintf("HyperExponential Lambda-2: %g \n", result_hyperExp_likelihood(1,2));
    fprintf("HyperExponential p: %g \n", result_hyperExp_likelihood(1,3));
else
%     Method of moments
    fprintf("Coefficient of variation < 1, HyperExponential unfeasible");
    F_hypoExp_MM = @(p)[
         (1/p(1,1) + 1/p(1,2))/M1 - 1;
         2*(1/(p(1,1).^2) + 1/(p(1,1)*p(1,2)) + 1/(p(1,2).^2))/M2 - 1;
    ];
    % Solving HypoExponential equations to get parameters
    result_hypoExp_MM = fsolve(F_hypoExp_MM, [0.5, 0.4]);
    fprintf("HypoExponential Lambda-1: %g \n", result_hypoExp_MM(1,1));
    fprintf("HypoExponential Lambda-2: %g \n", result_hypoExp_MM(1,2));
    fprintf("Method of likelihood: \n");
%     Method of likelihood
    HypoExpPDF = @(x, l1, l2) l1*l2/(l1-l2)*(exp(-x*l2) -exp(-x*l1));
    % Applying Maximum likelihood method to HypoExponential to get parameters
    result_hypoExp_likelihood = mle(data(:, column), 'pdf', HypoExpPDF, 'start', [1/(0.3*M1), 1/(0.7*M1)]);
    fprintf("HypoExponential Lambda-1: %g \n", result_hypoExp_likelihood(1,1));
    fprintf("HypoExponential Lambda-2: %g \n", result_hypoExp_likelihood(1,2));
end

ExpPDF = @(x, l) l*exp(-l*x);
% Applying Maximum likelihood method to Exponential to get parameters
result_Exp_likelihood = mle(data(:,column), 'pdf', ExpPDF, 'start', 0.5);
fprintf("Exponential rate: %g \n", result_Exp_likelihood(1,1));

% Plotting the data
% Method of moment results
t = [0:1200]/10;
y2unif_MM=max(0, min(1, (t-a_unif)/(b_unif-a_unif)));
y2exp_MM = 1 - exp(-lambda_exp*t);
if cV >=1
    y2Hyperexp_MM = 1 -result_hyperExp_MM(1,3)*exp(-result_hyperExp_MM(1,1)*t) ...
        -(1-result_hyperExp_MM(1,3))*exp(-result_hyperExp_MM(1,2)*t);
    figure(1);
    plot(sort(data(:,column)), [1:1000]/1000, "+", t, y2exp_MM, "-", t, y2Hyperexp_MM, "-", t, y2unif_MM, "-");
    legend('Data', 'Exponential', 'HyperExponential', 'Uniform');
    axis([0 40 0 1]);
    title('Method of moments');
else
    y2Hypoexp_MM = 1 - (result_hypoExp_MM(1,2)*exp(-result_hypoExp_MM(1,1)*t))/(result_hypoExp_MM(1,2)-result_hypoExp_MM(1,1)) ...
        + (result_hypoExp_MM(1,1)*exp(-result_hypoExp_MM(1,2)*t))/(result_hypoExp_MM(1,2)-result_hypoExp_MM(1,1));
    figure(1);
    plot(sort(data(:,column)), [1:1000]/1000, "+", t, y2exp_MM, "-", t, y2Hypoexp_MM, "-", t, y2unif_MM, "-");
    legend('Data', 'Exponential', 'HypoExponential', 'Uniform');
    axis([0 40 0 1]);
    title('Method of moments');
end
% Method of likelihood results
y2exp_likelihood = 1 - exp(-result_Exp_likelihood(1,1)*t);
if cV >=1
    y2Hyperexp_likelihood = 1 -result_hyperExp_likelihood(1,3)*exp(-result_hyperExp_likelihood(1,1)*t) ...
        -(1-result_hyperExp_likelihood(1,3))*exp(-result_hyperExp_likelihood(1,2)*t);
    figure(2);
    plot(sort(data(:,column)), [1:1000]/1000, "+", t, y2exp_likelihood, "-", t, y2Hyperexp_likelihood, "-");
    legend('Data', 'Exponential', 'HyperExponential');
    axis([0 40 0 1]);
    title('Method of likelihood');
else
    y2Hypoexp_likelihood = 1 - (result_hypoExp_likelihood(1,2)*exp(-result_hypoExp_likelihood(1,1)*t))/(result_hypoExp_likelihood(1,2)-result_hypoExp_likelihood(1,1)) ...
        + (result_hypoExp_likelihood(1,1)*exp(-result_hypoExp_likelihood(1,2)*t))/(result_hypoExp_likelihood(1,2)-result_hypoExp_likelihood(1,1));
    figure(2);
    plot(sort(data(:,column)), [1:1000]/1000, "+", t, y2exp_likelihood, "-", t, y2Hypoexp_likelihood, "-");
    legend('Data', 'Exponential', 'HypoExponential');
    axis([0 40 0 1]);
    title('Method of likelihood');
end








