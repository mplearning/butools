%  ImageFromDMAP(D0, D1, outFileName, prec)
%  
%  Depicts the given discrete Markovian arrival process,
%  and either displays it or saves it to file.
%  
%  Parameters
%  ----------
%  D0 : matrix, shape (M,M)
%      The D0 matrix of the discrete MAP.
%  D1 : matrix, shape (M,M)
%      The D1 matrix of the discrete MAP.
%  outFileName : string, optional
%      If it is not provided, or equals to 'display', the
%      image is displayed on the screen, otherwise it is 
%      written to the file. The file format is deduced 
%      from the file name.
%  prec : double, optional
%      Transition probabilities less then prec are 
%      considered to be zero and are left out from the 
%      image. The default value is 1e-13.
%  
%  Notes
%  -----
%  The 'graphviz' software must be installed and available
%  in the path to use this feature.

function ImageFromDMAP(D0,D1,outFileName,prec)

    if ~exist('prec','var')
        prec = 1e-13;
    end

    if ~exist('outFileName','var')
        outFileName = 'display';
    end
    
    ImageFromDMMAP({D0,D1},outFileName,prec);
end

