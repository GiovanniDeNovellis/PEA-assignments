clear all;

filename = 'Data4.txt';
data = csvread(filename);

N = size(data,1);

% Computing the moments from the samples
first_moment = sum(data)/N;
second_moment = sum(data .^ 2)/N;
third_moment = sum(data .^ 3)/N;
fourth_moment = sum(data .^ 4)/N;
fifth_moment = sum(data .^ 5)/N;

% Computing the standard deviation
std = sqrt(sum((data - first_moment).^2)/N);

% Computing the centered moments from the samples
second_centered_moment = sum((data - first_moment) .^ 2)/N;
third_centered_moment = sum((data - first_moment) .^ 3)/N;
fourth_centered_moment = sum((data - first_moment) .^ 4)/N;
fifth_centered_moment = sum((data - first_moment) .^ 5)/N;

% Computing the standardized momemnts from the samples
third_standardized_moment = sum(((data-first_moment)./std) .^ 3)/N;
fourth_standardized_moment = sum(((data-first_moment)./std) .^ 4)/N;
fifth_standardized_moment = sum(((data-first_moment)./std) .^ 5)/N;

% Computing the coefficient of variation and the kurtosis
coefficient_variation = std/first_moment;
kurtosis = fourth_standardized_moment-3;

sorted_data = sort(data);

% Plotting the approximated CDF using the sorted traces.
plot(sorted_data, [1:N]/N, "+" );

% Calculating the percentiles through linear interpolation
omega10 = calc_omega(10, sorted_data);
omega25 = calc_omega(25, sorted_data);
omega50 = calc_omega(50, sorted_data);
omega75 = calc_omega(75, sorted_data);
omega90 = calc_omega(90, sorted_data);

% Computing the cross covariance
Lag1 = sum((data(1:N-1,1)-first_moment).*(data(2:N,1)-first_moment))/(N-1);
Lag2 = sum((data(1:N-2,1)-first_moment).*(data(3:N,1)-first_moment))/(N-2);
Lag3 = sum((data(1:N-3,1)-first_moment).*(data(4:N,1)-first_moment))/(N-3);

% Computing the Person coefficient
PersonCoefficient1 = Lag1/(std.^2);
PersonCoefficient2 = Lag2/(std.^2);
PersonCoefficient3 = Lag3/(std.^2);

fprintf("First moment: %g \n", first_moment);
fprintf("Second moment: %g \n", second_moment);
fprintf("Third moment: %g \n", third_moment);
fprintf("Fourth moment: %g \n", fourth_moment);
fprintf("Fifth moment: %g \n", fifth_moment);
fprintf("Second centered moment: %g \n", second_centered_moment);
fprintf("Third centered moment: %g \n", third_centered_moment);
fprintf("Fourth centered moment: %g \n", fourth_centered_moment);
fprintf("Fifth centered moment: %g \n", fifth_centered_moment);
fprintf("Third standardized moment: %g \n", third_standardized_moment);
fprintf("Fourth standardized moment: %g \n", fourth_standardized_moment);
fprintf("Fifth standardized moment: %g \n", fifth_standardized_moment);
fprintf("Standard deviation: %g \n", std);
fprintf("Coefficient of variation: %g \n", coefficient_variation);
fprintf("Kurtosis: %g \n", kurtosis);
fprintf("10th percentile: %g \n", omega10);
fprintf("25th percentile: %g \n", omega25);
fprintf("50th percentile: %g \n", omega50);
fprintf("75th percentile: %g \n", omega75);
fprintf("90th percentile: %g \n", omega90);
fprintf("Cross covariance sigma=1: %g \n", Lag1);
fprintf("Cross covariance sigma=2: %g \n", Lag2);
fprintf("Cross covariance sigma=3: %g \n", Lag3);
fprintf("Person coefficient rho=1: %g \n", PersonCoefficient1);
fprintf("Person coefficient rho=2: %g \n", PersonCoefficient2);
fprintf("Person coefficient rho=3: %g \n", PersonCoefficient3);

% This function calculates the k-th percentile using linear interpolation
function omega = calc_omega(k, sorted_data)
    N=size(sorted_data,1);
    h=((N-1)*k)/100 + 1;
    if h == size(sorted_data)
        omega = sorted_data(size(sorted_data));
    else
        omega = sorted_data(floor(h),1) + ...
            (h - floor(h)) * (sorted_data(floor(h)+1,1) - sorted_data(floor(h),1));
    end
end