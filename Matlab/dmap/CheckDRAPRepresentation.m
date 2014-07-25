%  r = CheckDRAPRepresentation(H, prec)
%  
%  Checks if the input matrixes define a discrete time RAP.
%  
%  Matrices H0 and H1 must have the same size, the dominant
%  eigenvalue of H0 is real and less than 1, and the rowsum of 
%  H0+H1 is 1 (up to the numerical precision).
%  
%  Parameters
%  ----------
%  H0 : matrix, shape (M,M)
%      The H0 matrix of the DRAP to check
%  H1 : matrix, shape (M,M)
%      The H1 matrix of the DRAP to check
%  prec : double, optional
%      Numerical precision, the default value is 1e-14
%  
%  Returns
%  -------
%  r : bool 
%      The result of the check

function r=CheckDRAPRepresentation(d0, d1, prec)
% CheckDRAPRepresentation [ D0, D1, prec[10^-14] ] :
%     Checks if the input matrixes define a discrete time RAP: D0, D1 
%     have the same size,	the dominant eigenvalue of matrix0 is less
%     than 1 and real and the rowsum of D0+D1 is 1. 'prec' is the numerical
%     precision.

    global BuToolsVerbose;
    if ~exist('prec','var')
        prec = 1e-14;
    end

    if size(d0,1) ~= size(d1,1) || size(d0,2) ~= size(d1,2) || size(d0,1) ~= size(d0,2)
        if BuToolsVerbose
            fprintf('CheckDRAPRepresentation: D0 and D1 have different sizes!\n');
        end
        r=0;
        return
    end

    if any(abs(sum(d0+d1,2)-1) > prec)
        if BuToolsVerbose
            fprintf('CheckDRAPRepresentation: A rowsum of D0+D1 is not 1 (at precision %g)!\n',prec);
        end
        r=0;
        return
    end

    ev = EigSort(eig(d0));
    maxev = ev(1);

    if ~isreal(maxev)
        if BuToolsVerbose
            fprintf('CheckDRAPRepresentation: The dominant eigenvalue of the D0 is complex!\n');
        end
        r=0;
        return
    end

    if maxev > 1+prec
        if BuToolsVerbose
            fprintf('CheckDRAPRepresentation: The dominant eigenvalue of D0 is greater than 1!\n');
        end
        r=0;
        return
    end

    if sum(abs(ev(1:end))==abs(maxev)) > 1
         if BuToolsVerbose
            fprintf('CheckDRAPRepresentation Warning: D0 has more than one eigenvalue with the same absolute value as the dominant eigenvalue!\n');
         end
    end

    r=1;
end