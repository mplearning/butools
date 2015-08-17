clear all
run('/home/gabor/github/butools/Matlab/BuToolsInit.m')

disp('---BuTools: Fitting package test file---');
disp('Enable the verbose messages with the BuToolsVerbose flag');
global BuToolsVerbose;
BuToolsVerbose = true;
disp('Enable input parameter checking with the BuToolsCheckInput flag');
global BuToolsCheckInput;
BuToolsCheckInput = true;
global BuToolsCheckPrecision;
format short g;
disp('========================================')
disp('Testing BuTools function EmpiricalSquaredDifference')
disp('Input:');
disp('------');
disp('tr = dlmread(''/home/gabor/github/butools/test/data/bctrace.iat'');:');
tr = dlmread('/home/gabor/github/butools/test/data/bctrace.iat');
disp('intBounds = linspace(0, MarginalMomentsFromTrace(tr, 1)*4, 50);:');
intBounds = linspace(0, MarginalMomentsFromTrace(tr, 1)*4, 50);
disp('[pdfTrX, pdfTrY] = PdfFromTrace(tr, intBounds);:');
[pdfTrX, pdfTrY] = PdfFromTrace(tr, intBounds);
disp('[cdfTrX, cdfTrY] = CdfFromTrace(tr);:');
[cdfTrX, cdfTrY] = CdfFromTrace(tr);
disp('step = ceil(length(tr)/2000);:');
step = ceil(length(tr)/2000);
disp('cdfTrX = cdfTrX(1:step:length(tr));:');
cdfTrX = cdfTrX(1:step:length(tr));
disp('cdfTrY = cdfTrY(1:step:length(tr));:');
cdfTrY = cdfTrY(1:step:length(tr));
disp('[alpha, A] = APHFrom3Moments(MarginalMomentsFromTrace(tr, 3));:');
[alpha, A] = APHFrom3Moments(MarginalMomentsFromTrace(tr, 3));
disp('[pdfPHX, pdfPHY] = IntervalPdfFromPH(alpha, A, intBounds);:');
[pdfPHX, pdfPHY] = IntervalPdfFromPH(alpha, A, intBounds);
disp('cdfPHY = CdfFromPH(alpha, A, cdfTrX);:');
cdfPHY = CdfFromPH(alpha, A, cdfTrX);
disp('Test:');
disp('-----');
disp('sqPdf = EmpiricalSquaredDifference(pdfTrY, pdfPHY, intBounds);:');
sqPdf = EmpiricalSquaredDifference(pdfTrY, pdfPHY, intBounds);
disp('sqPdf = ');
disp(sqPdf);
disp('sqCdf = EmpiricalSquaredDifference(cdfTrY(1:end-1), cdfPHY(1:end-1), cdfTrX);:');
sqCdf = EmpiricalSquaredDifference(cdfTrY(1:end-1), cdfPHY(1:end-1), cdfTrX);
disp('sqCdf = ');
disp(sqCdf);
assert(sqPdf>=0, 'Empirical squared difference is negative!');
assert(sqCdf>=0, 'Empirical squared difference is negative!');
disp('========================================')
disp('Testing BuTools function EmpiricalRelativeEntropy')
disp('Input:');
disp('------');
disp('tr = dlmread(''/home/gabor/github/butools/test/data/bctrace.iat'');:');
tr = dlmread('/home/gabor/github/butools/test/data/bctrace.iat');
disp('intBounds = linspace(0, MarginalMomentsFromTrace(tr, 1)*4, 50);:');
intBounds = linspace(0, MarginalMomentsFromTrace(tr, 1)*4, 50);
disp('[pdfTrX, pdfTrY] = PdfFromTrace(tr, intBounds);:');
[pdfTrX, pdfTrY] = PdfFromTrace(tr, intBounds);
disp('[cdfTrX, cdfTrY] = CdfFromTrace(tr);:');
[cdfTrX, cdfTrY] = CdfFromTrace(tr);
disp('step = ceil(length(tr)/2000);:');
step = ceil(length(tr)/2000);
disp('cdfTrX = cdfTrX(1:step:length(tr));:');
cdfTrX = cdfTrX(1:step:length(tr));
disp('cdfTrY = cdfTrY(1:step:length(tr));:');
cdfTrY = cdfTrY(1:step:length(tr));
disp('[alpha, A] = APHFrom3Moments(MarginalMomentsFromTrace(tr, 3));:');
[alpha, A] = APHFrom3Moments(MarginalMomentsFromTrace(tr, 3));
disp('[pdfPHX, pdfPHY] = IntervalPdfFromPH(alpha, A, intBounds);:');
[pdfPHX, pdfPHY] = IntervalPdfFromPH(alpha, A, intBounds);
disp('cdfPHY = CdfFromPH(alpha, A, cdfTrX);:');
cdfPHY = CdfFromPH(alpha, A, cdfTrX);
disp('Test:');
disp('-----');
disp('rePdf = EmpiricalRelativeEntropy(pdfTrY, pdfPHY, intBounds);:');
rePdf = EmpiricalRelativeEntropy(pdfTrY, pdfPHY, intBounds);
disp('rePdf = ');
disp(rePdf);
disp('reCdf = EmpiricalRelativeEntropy(cdfTrY(1:end-1), cdfPHY(1:end-1), cdfTrX);:');
reCdf = EmpiricalRelativeEntropy(cdfTrY(1:end-1), cdfPHY(1:end-1), cdfTrX);
disp('reCdf = ');
disp(reCdf);
assert(rePdf>=0, 'Empirical relative entropy is negative!');
assert(reCdf>=0, 'Empirical relative entropy is negative!');
disp('========================================')
disp('Testing BuTools function LikelihoodFromTrace')
disp('Input:');
disp('------');
disp('tr = dlmread(''/home/gabor/github/butools/test/data/bctrace.iat'');:');
tr = dlmread('/home/gabor/github/butools/test/data/bctrace.iat');
disp('[alpha, A] = APHFrom3Moments(MarginalMomentsFromTrace(tr, 3));:');
[alpha, A] = APHFrom3Moments(MarginalMomentsFromTrace(tr, 3));
disp('[D0, D1] = MAPFromFewMomentsAndCorrelations(MarginalMomentsFromTrace(tr, 3), LagCorrelationsFromTrace(tr, 1));:');
[D0, D1] = MAPFromFewMomentsAndCorrelations(MarginalMomentsFromTrace(tr, 3), LagCorrelationsFromTrace(tr, 1));
disp('Test:');
disp('-----');
disp('logliPH = LikelihoodFromTrace(tr, alpha, A);:');
logliPH = LikelihoodFromTrace(tr, alpha, A);
disp('logliPH = ');
disp(logliPH);
disp('logliMAP = LikelihoodFromTrace(tr, D0, D1);:');
logliMAP = LikelihoodFromTrace(tr, D0, D1);
disp('logliMAP = ');
disp(logliMAP);
disp('========================================')
disp('Testing BuTools function SquaredDifference')
disp('Input:');
disp('------');
disp('tr = dlmread(''/home/gabor/github/butools/test/data/bctrace.iat'');:');
tr = dlmread('/home/gabor/github/butools/test/data/bctrace.iat');
disp('trAcf = LagCorrelationsFromTrace(tr, 10);:');
trAcf = LagCorrelationsFromTrace(tr, 10);
disp('trAcf = ');
disp(trAcf);
disp('[D0, D1] = MAPFromFewMomentsAndCorrelations(MarginalMomentsFromTrace(tr, 3), trAcf(1));:');
[D0, D1] = MAPFromFewMomentsAndCorrelations(MarginalMomentsFromTrace(tr, 3), trAcf(1));
disp('mapAcf = LagCorrelationsFromMAP(D0, D1, 10);:');
mapAcf = LagCorrelationsFromMAP(D0, D1, 10);
disp('mapAcf = ');
disp(mapAcf);
disp('Test:');
disp('-----');
disp('sqAcf = SquaredDifference(mapAcf, trAcf);:');
sqAcf = SquaredDifference(mapAcf, trAcf);
disp('sqAcf = ');
disp(sqAcf);
assert(sqAcf>=0, 'Squared difference is negative!');
disp('========================================')
disp('Testing BuTools function RelativeEntropy')
disp('Input:');
disp('------');
disp('tr = dlmread(''/home/gabor/github/butools/test/data/bctrace.iat'');:');
tr = dlmread('/home/gabor/github/butools/test/data/bctrace.iat');
disp('trAcf = LagCorrelationsFromTrace(tr, 10);:');
trAcf = LagCorrelationsFromTrace(tr, 10);
disp('trAcf = ');
disp(trAcf);
disp('[D0, D1] = MAPFromFewMomentsAndCorrelations(MarginalMomentsFromTrace(tr, 3), trAcf(1));:');
[D0, D1] = MAPFromFewMomentsAndCorrelations(MarginalMomentsFromTrace(tr, 3), trAcf(1));
disp('mapAcf = LagCorrelationsFromMAP(D0, D1, 10);:');
mapAcf = LagCorrelationsFromMAP(D0, D1, 10);
disp('mapAcf = ');
disp(mapAcf);
disp('Test:');
disp('-----');
disp('reAcf = RelativeEntropy(mapAcf, trAcf);:');
reAcf = RelativeEntropy(mapAcf, trAcf);
disp('reAcf = ');
disp(reAcf);
assert(reAcf>=0, 'Relative entropy is negative!');
disp('========================================')
disp('Testing BuTools function PHFromTrace')
disp('Input:');
disp('------');
disp('tr = dlmread(''/home/gabor/github/butools/test/data/bctrace.iat'');:');
tr = dlmread('/home/gabor/github/butools/test/data/bctrace.iat');
disp('Test:');
disp('-----');
disp('[alpha, A] = PHFromTrace(tr, 5);:');
[alpha, A] = PHFromTrace(tr, 5);
disp('alpha = ');
disp(alpha);
disp('A = ');
disp(A);
disp('logli = LikelihoodFromTrace(tr, alpha, A);:');
logli = LikelihoodFromTrace(tr, alpha, A);
disp('logli = ');
disp(logli);
disp('intBounds = linspace(0, MarginalMomentsFromTrace(tr, 1)*4, 50);:');
intBounds = linspace(0, MarginalMomentsFromTrace(tr, 1)*4, 50);
disp('[pdfTrX, pdfTrY] = PdfFromTrace(tr, intBounds);:');
[pdfTrX, pdfTrY] = PdfFromTrace(tr, intBounds);
disp('[pdfPHX, pdfPHY] = IntervalPdfFromPH(alpha, A, intBounds);:');
[pdfPHX, pdfPHY] = IntervalPdfFromPH(alpha, A, intBounds);
disp('sqPdf = EmpiricalSquaredDifference(pdfTrY, pdfPHY, intBounds);:');
sqPdf = EmpiricalSquaredDifference(pdfTrY, pdfPHY, intBounds);
disp('sqPdf = ');
disp(sqPdf);
disp('rePdf = EmpiricalRelativeEntropy(pdfTrY, pdfPHY, intBounds);:');
rePdf = EmpiricalRelativeEntropy(pdfTrY, pdfPHY, intBounds);
disp('rePdf = ');
disp(rePdf);
disp('[cdfTrX, cdfTrY] = CdfFromTrace(tr);:');
[cdfTrX, cdfTrY] = CdfFromTrace(tr);
disp('step = ceil(length(tr)/2000);:');
step = ceil(length(tr)/2000);
disp('cdfTrX = cdfTrX(1:step:length(tr));:');
cdfTrX = cdfTrX(1:step:length(tr));
disp('cdfTrY = cdfTrY(1:step:length(tr));:');
cdfTrY = cdfTrY(1:step:length(tr));
disp('cdfPHY = CdfFromPH(alpha, A, cdfTrX);:');
cdfPHY = CdfFromPH(alpha, A, cdfTrX);
disp('sqCdf = EmpiricalSquaredDifference(cdfTrY(1:end-1), cdfPHY(1:end-1), cdfTrX);:');
sqCdf = EmpiricalSquaredDifference(cdfTrY(1:end-1), cdfPHY(1:end-1), cdfTrX);
disp('sqCdf = ');
disp(sqCdf);
disp('reCdf = EmpiricalRelativeEntropy(cdfTrY(1:end-1), cdfPHY(1:end-1), cdfTrX);:');
reCdf = EmpiricalRelativeEntropy(cdfTrY(1:end-1), cdfPHY(1:end-1), cdfTrX);
disp('reCdf = ');
disp(reCdf);
disp('========================================')
disp('Testing BuTools function MAPFromTrace')
disp('Input:');
disp('------');
disp('tr = dlmread(''/home/gabor/github/butools/test/data/bctrace.iat'');:');
tr = dlmread('/home/gabor/github/butools/test/data/bctrace.iat');
disp('tr = tr(1:10000);:');
tr = tr(1:10000);
disp('Test:');
disp('-----');
disp('[D0, D1] = MAPFromTrace(tr, 5);:');
[D0, D1] = MAPFromTrace(tr, 5);
disp('D0 = ');
disp(D0);
disp('D1 = ');
disp(D1);
disp('logli = LikelihoodFromTrace(tr, D0, D1);:');
logli = LikelihoodFromTrace(tr, D0, D1);
disp('logli = ');
disp(logli);
disp('trAcf = LagCorrelationsFromTrace(tr, 10);:');
trAcf = LagCorrelationsFromTrace(tr, 10);
disp('trAcf = ');
disp(trAcf);
disp('mapAcf = LagCorrelationsFromMAP(D0, D1, 10);:');
mapAcf = LagCorrelationsFromMAP(D0, D1, 10);
disp('mapAcf = ');
disp(mapAcf);
disp('sqAcf = SquaredDifference(mapAcf, trAcf);:');
sqAcf = SquaredDifference(mapAcf, trAcf);
disp('sqAcf = ');
disp(sqAcf);
disp('reAcf = RelativeEntropy(mapAcf, trAcf);:');
reAcf = RelativeEntropy(mapAcf, trAcf);
disp('reAcf = ');
disp(reAcf);
