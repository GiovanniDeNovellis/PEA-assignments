clear all;

%Initializing parameters
l1=1/20;
l2=1/3;
m1=1/2;
m2=1/8;
l3=1/100;
% s1=4G on Wifi on
% s2=4G off Wifi on
% s3=4G on Wifi off
% s4=4G off Wifi off

%   s1         s2      s3       s4
Q=[-l1-l2-l3,  l1   ,  l2   ,   l3   ; %s1
     m1     , -m1-l2,   0   ,   l2   ; %s2
     m2     ,   0   , -m2-l1,    l1  ; %s3
      0     ,  m2   ,  m1   , -m2-m1]; %s4

%The system always starts with 4G and Wifi on
p0=[1,0,0,0];

% Compute the solution
[t, Sol] = ode45(@(t,x) Q'*x, [0 300], p0');

plot(t, Sol, "-");
legend("s1", "s2", "s3", "s4");