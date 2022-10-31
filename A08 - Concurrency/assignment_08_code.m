clear all;

% Initializing parameters
s = 1;
t = 0;
Tmax = 1000000;
Ts1 = 0;
Ts2 = 0;
Ts3 = 0;
% Generating all the timings with an exponential distribution
generate_exponential = @(lambda) -log(rand())/lambda;
C=0;
 
while t<Tmax
    if s==1 %Preparing a new job
        dt=generate_exponential(0.05);
        Ts1=Ts1+dt;
        ns=2;
        C=C+1;
    end
    if s==2 %Running at full speed
        tCompletion=generate_exponential(1);
        tStartGarbage=generate_exponential(0.1);
        if tCompletion < tStartGarbage
            ns=1;
            dt=tCompletion;
        else
            ns=3;
            dt=tStartGarbage;
        end
        Ts2=Ts2+dt;
    end
    if s==3 %Running during garbage collection
        tCompletion=generate_exponential(0.3);
        tFullSpeed=generate_exponential(0.4);
        if tCompletion < tFullSpeed
            ns=1;
            dt=tCompletion;
        else
            ns=2;
            dt=tFullSpeed;
        end
        Ts3=Ts3+dt;
    end

    s=ns;
    t=t+dt;
end

%Calculating Probabilities
Ps1 = Ts1/t;
Ps2 = Ts2/t;
Ps3 = Ts3/t;
%Calculating throughput
X=C/t;

fprintf("Probability of preparing a job: %g \n", Ps1);
fprintf("Probability of running full speed: %g \n", Ps2);
fprintf("Probability of garbage collection: %g \n", Ps3);
fprintf("Throughput: %g \n", X);

