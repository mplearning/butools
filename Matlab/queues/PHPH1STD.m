%  [alpha, A] = PHPH1STD(delta, D, sigma, S, transToPH, prec)
%  
%  Returns the matrix-exponential distribution of the sojourn
%  time of the jobs in a PH/PH/1 queue.
%  
%  In a PH/PH/1 queue both the inter-arrival times and the 
%  service times are given by phase-type distributions.
%  
%  Parameters
%  ----------
%  delta : matrix, shape(1,N)
%      The initial probability vector of the phase-type
%      distribution generating the inter-arrival times
%  D : matrix, shape(N,N)
%      The transient generator of the phase-type 
%      distribution generating the inter-arrival times
%  sigma : matrix, shape(1,N)
%      The initial probability vector of the phase-type
%      distribution corresponging to the service time
%  S : matrix, shape(N,N)
%      The transient generator of the phase-type 
%      distribution corresponging to the service time
%  transToPH : bool, optional
%      If true, the result is transformed to a phase-type
%      representation. The default value is false
%  prec : double, optional
%      Numerical precision to check if the input is valid and
%      it is also used as a stopping condition when solving
%      the matrix-quadratic equation
%  
%  Returns
%  -------
%  alpha : matrix, shape (1,M)
%      The initial vector of the matrix-exponential 
%      distribution representing the sojourn time of the jobs
%  A : matrix, shape (M,M)
%      The matrix parameter of the matrix-exponential 
%      distribution representing the sojourn time of the jobs
%      
%  
%  Notes
%  -----
%  While the transformation of the results to phase-type
%  representation is always possible theoretically, it may
%  introduce numerical problems in some cases.

function [alpha, A] = PHPH1STD (delta, D, sigma, S, transToPH, prec)

    if ~exist('prec','var')
        prec = 1e-14;
    end
    
    if ~exist('transToPH','var')
        transToPH = false;
    end
    
    global BuToolsCheckInput;

    if isempty(BuToolsCheckInput)
        BuToolsCheckInput = true;
    end   

    if BuToolsCheckInput && ~CheckPHRepresentation(delta,D,prec)
        error('PHPH1STD: The arrival distribution (delta,D) is not a valid PH representation!');
    end
    
    if BuToolsCheckInput && ~CheckPHRepresentation(sigma,S,prec)
        error('PHPH1STD: The service distribution (sigma,S) is not a valid PH representation!');
    end

    [alpha, A] = MAPMAP1STD (D, sum(-D,2)*delta, S, sum(-S,2)*sigma, transToPH, prec);    
end

