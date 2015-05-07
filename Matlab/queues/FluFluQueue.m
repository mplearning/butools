function varargout = FluFluQueue(Qin, Rin, Qout, Rout, srv0stop, varargin)

    % parse options
    prec = 1e-14;
    needST = 0;
    needQL = 0;
    eaten = [];
    for i=1:length(varargin)
        if strcmp(varargin{i},'prec')
            prec = varargin{i+1};
            eaten = [eaten, i, i+1];
        elseif length(varargin{i})>2 && strcmp(varargin{i}(1:2),'st')
            needST = 1;
        elseif length(varargin{i})>2 && strcmp(varargin{i}(1:2),'ql')
            needQL = 1;
        end
    end
    
    global BuToolsCheckInput;

    if isempty(BuToolsCheckInput)
        BuToolsCheckInput = true;
    end   

    if BuToolsCheckInput && ~CheckGenerator(Qin,false,prec)
        error('FluFlu: Generator matrix Qin is not Markovian!');
    end
    if BuToolsCheckInput && ~CheckGenerator(Qout,false,prec)
        error('FluFlu: Generator matrix Qout is not Markovian!');
    end
    if BuToolsCheckInput && (any(diag(Rin)<-prec) || any(diag(Rout)<-prec))
        error('FluFlu: Fluid rates Rin and Rout must be non-negative !');
    end  
    
    Iin = eye(size(Qin));
    Iout = eye(size(Qout));

    if needQL
        Q = kron(Qin,Iout)+kron(Iin,Qout);
        if srv0stop
            Q0 = kron(Qin,Iout)+kron(Rin, pinv(Rout)*Qout);
        else
            Q0 = Q;
        end
        [mass0, ini, K, clo] = GeneralFluidSolve (Q, kron(Rin,Iout)-kron(Iin,Rout), Q0, prec);
    end
    if needST
        Rh = kron(Rin,Iout) - kron(Iin,Rout);
        Qh = kron(Qin, Rout) + kron(Rin, Qout);       
        [massh, inih, Kh, cloh] = GeneralFluidSolve (Qh, Rh);

        % sojourn time density in case of 
        % srv0stop = false: inih*expm(Kh*x)*cloh*kron(Rin,Iout)/lambda
        % srv0stop = true: inih*expm(Kh*x)*cloh*kron(Rin,Rout)/lambda/mu    

        lambda = sum(CTMCSolve(Qin,prec)*Rin);
        mu = sum(CTMCSolve(Qout,prec)*Rout);
    end
    
    Ret = {};
    retIx = 1;
    argIx = 1;
    while argIx<=length(varargin)
        if any(ismember(eaten, argIx))
            argIx = argIx + 1;
            continue;
        elseif strcmp(varargin{argIx},'qlDistrPH')
            % transform it to PH
            Delta = diag(linsolve(K',-ini')); % Delta = diag (ini*inv(-K));
            A = inv(Delta)*K'*Delta;
            alpha = sum(clo,2)'*Delta;
            Ret{retIx} = {alpha, A};
            retIx = retIx + 1;
        elseif strcmp(varargin{argIx},'qlDistrME')
            % transform it to ME
            B = TransformToOnes(inv(-K)*sum(clo,2));
            Bi = inv(B);
            alpha = ini*Bi;
            A = B*K*Bi;
            Ret{retIx} = {alpha, A};
            retIx = retIx + 1;
        elseif strcmp(varargin{argIx},'qlMoms')
            numOfMoms = varargin{argIx+1};
            argIx = argIx + 1;
            moms = zeros(1,numOfMoms);
            iK = inv(-K);
            for m=1:numOfMoms
                moms(m) = factorial(m)*sum(ini*iK^(m+1)*clo);
            end
            Ret{retIx} = moms;
            retIx = retIx + 1;
        elseif strcmp(varargin{argIx},'qlDistr')
            points = varargin{argIx+1};
            argIx = argIx + 1;
            values = zeros(size(points));
            iK = inv(-K);
            for p=1:length(points)
                values(p) = sum(mass0) + sum(ini*(eye(size(K,1))-expm(K*points(p)))*iK*clo);
            end
            Ret{retIx} = values;
            retIx = retIx + 1;
        elseif strcmp(varargin{argIx},'stDistrPH')
            % convert result to PH representation
            Delta = diag(linsolve(Kh',-inih')); % Delta = diag (inih*inv(-Kh));
            A = inv(Delta)*Kh'*Delta;       
            if ~srv0stop        
                alpha = sum(Delta*cloh*kron(Rin,Iout)/lambda,2)';
            else
                alpha = sum(Delta*cloh*kron(Rin,Rout)/lambda/mu,2)';
            end        
            Ret{retIx} = {alpha, A};
            retIx = retIx + 1;
        elseif strcmp(varargin{argIx},'stDistrME')
            % convert result to ME representation
            if ~srv0stop
                B = TransformToOnes(sum(cloh*kron(Rin,Iout)/lambda,2));
            else
                B = TransformToOnes(sum(cloh*kron(Rin,Rout)/lambda/mu,2));
            end
            iB = inv(B);
            A = B*Kh*iB;
            alpha = inih*inv(-Kh)*iB;
            Ret{retIx} = {alpha, A};
            retIx = retIx + 1;
        elseif strcmp(varargin{argIx},'stMoms')
            numOfMoms = varargin{argIx+1};
            argIx = argIx + 1;
            moms = zeros(1,numOfMoms);
            if srv0stop
                kclo = cloh*kron(Rin,Rout)/lambda/mu;
            else
                kclo = cloh*kron(Rin,Iout)/lambda;
            end
            iKh = inv(-Kh);
            for m=1:numOfMoms
                moms(m) = factorial(m)*sum(inih*iKh^(m+1)*kclo);
            end
            Ret{retIx} = moms;
            retIx = retIx + 1;
        elseif strcmp(varargin{argIx},'stDistr')
            points = varargin{argIx+1};
            argIx = argIx + 1;
            values = zeros(size(points));
            if srv0stop
                kclo = cloh*kron(Rin,Rout)/lambda/mu;
            else
                kclo = cloh*kron(Rin,Iout)/lambda;
            end
            iKh = inv(-Kh);
            for p=1:length(points)
                values(p) = 1-sum(inih*expm(Kh*points(p))*iKh*kclo);
            end
            Ret{retIx} = values;
            retIx = retIx + 1;
        else
            error (['FluFluQueue: Unknown parameter ' varargin{argIx}])
        end
        argIx = argIx + 1;
    end
    if length(Ret)==1 && iscell(Ret{1})
        varargout = Ret{1};
    else
        varargout = Ret;
    end
end

