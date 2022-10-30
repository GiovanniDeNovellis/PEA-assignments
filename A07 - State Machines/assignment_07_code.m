clear all;

% Initializing parameters
s = 1;
t = 0;
Tmax = 1000000;
Ts1 = 0;
Ts2 = 0;
Ts3 = 0;
Ts4 = 0;
C=0;

while t<Tmax
    if s==1 % Temperature Sensor
        C=C+1;
        % Generating time with 3-stages Erlang Distribution        
        dt=-log(rand()*rand()*rand())/0.1;
        Ts1=Ts1+dt;
        ns=2;
    end
    if s==2 % CPU
        % Generating time with Uniform Distribution         
        dt =10+rand()*(20-10);
        Ts2=Ts2+dt;
        random_toss=rand();
        % 50% probability to go in the first state
        if random_toss<=0.5
            ns=1;
        % 30% probability to go in the third state
        elseif random_toss<=0.8
            ns=3;
        % 20% probability to go in the fourth state
        else
            ns=4;
        end
    end 
    if s==3 % Air Conditioning
        % Generationg time with Exponential Distribution
        dt=-log(rand())/0.05;
        Ts3=Ts3+dt;
        ns=1;
    end
    if s==4 %Heat Pump
        % Generating time with Exponential Distribution
        dt=-log(rand())/0.03;
        Ts4=Ts4+dt;
        ns=1;
    end
    
    s=ns;
    t=t+dt;
end

% Calculating Probabilities
Ps1 = Ts1/t;
Ps2 = Ts2/t;
Ps3 = Ts3/t;
Ps4 = Ts4/t;
% Calculating throughput
X=C/t;

fprintf("Probability of sensing: %g \n", Ps1);
fprintf("Probability of using CPU: %g \n", Ps2);
fprintf("Probability of actuating air conditioning: %g \n", Ps3);
fprintf("Probability of using heat pump: %g \n", Ps4);
fprintf("Throughput: %g \n", X);