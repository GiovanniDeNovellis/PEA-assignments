clear all;

% Initializing some parameters.
maxK=50000;
K=200;
DK=K;
M=250;
gamma=0.95;
d_gamma=1.96;
a_unif=5;
b_unif=10;
% Generating Service Times with an Uniform Distribution.
service_rnd = @() a_unif + (b_unif-a_unif)*rand();

newIters=K;
tA=0;
tC=0;
R=0;
R2=0;
U=0;
U2=0;
N=0;
N2=0;
X=0;
X2=0;
Wi=0;

% Generating 50000 samples and estimating the interval for the Response
% Times.
for i=1:maxK
    a_i = calculateArrivalHyperExp();
    s_i = service_rnd();
    tC = max(tA, tC) + s_i;
    ri = tC - tA;
    Wi = Wi + ri;
    R2 = R2 + ri^2;
    tA = tA + a_i;
end
Rm=Wi/maxK;
Rs=sqrt((R2-Wi^2/maxK)/(maxK-1));
CiR=[Rm - d_gamma * Rs /sqrt(maxK), Rm + d_gamma * Rs /sqrt(maxK)];
fprintf(1, "Resp. Time in [%g, %g], with %g confidence. \n", CiR(1,1), CiR(1,2), gamma);
tA=0;
tC=0;

% Estimating confidence interval for N Average Number of Jobs, X
% throughput, U utilization by doing 200 runs of 250 jobs each.
for i=1:newIters
    Bi=0;
    Wi=0;
    tA0=tA;
    for j=1:M
        a_ji = calculateArrivalHyperExp();
        s_ji = service_rnd();
        tC = max(tA, tC) + s_ji;
        ri = tC - tA;
        tA = tA + a_ji;
        Bi = Bi + s_ji;
        Wi = Wi + ri;
    end
    Ti=tC-tA0;
    Ni=Wi/Ti;
    Ui=Bi/Ti;
    Xi=M/Ti;
    N=N+Ni;
    U=U+Ui;
    X=X+Xi;
    N2=N2+Ni^2;
    U2=U2+Ui^2;
    X2=X2+Xi^2;
end

Um=U/K;
Us=sqrt((U2-U^2/K)/(K-1));  
CiU=[Um - d_gamma * Us /sqrt(K), Um + d_gamma * Us /sqrt(K)];

Nm=N/K;
Ns=sqrt((N2-N^2/K)/(K-1));  
CiN=[Nm - d_gamma * Ns /sqrt(K), Nm + d_gamma * Ns /sqrt(K)];

Xm=X/K;
Xs=sqrt((X2-X^2/K)/(K-1));  
CiX=[Xm - d_gamma * Xs /sqrt(K), Xm + d_gamma * Xs /sqrt(K)];


fprintf(1, "Utilization in [%g, %g], with %g confidence. \n", CiU(1,1), CiU(1,2), gamma);
fprintf(1, "Number of jobs in [%g, %g], with %g confidence. \n", CiN(1,1), CiN(1,2), gamma);
fprintf(1, "Throughput in [%g, %g], with %g confidence. \n", CiX(1,1), CiX(1,2), gamma);

% Generating the Inter Arrival times with a 2 stages HyperExponential
% Distribution.
function arr = calculateArrivalHyperExp()
    lambda=[0.02, 0.2];
    p=[0.1, 0.9];
    C=cumsum(p);
    rand1=rand();
    rand2=rand();
    for i=1:2
        if rand1<=C(1,i)
            arr=-log(rand2)/lambda(1,i);
            break;
        end
    end
end