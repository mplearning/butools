# -*- coding: utf-8 -*-
"""
Created on Sun Aug 24 15:47:28 2014

@author: gabor
"""

import subprocess
import os.path
import butools
from butools.ph import CheckPHRepresentation
import numpy as np
import numpy.matlib as ml
from numpy.random import rand

def SamplesFromPH (a,A,k,prec=1e-14):
    """
    Generates random samples from a phase-type distribution.
    
    Parameters
    ----------
    alpha : matrix, shape (1,M)
        The initial probability vector of the phase-type
        distribution.
    A : matrix, shape (M,M)
        The transient generator matrix of the phase-type
        distribution.
    K : integer
        The number of samples to generate.
    prec : double, optional
        Numerical precision to check if the input phase-type
        distribution is valid. The default value is 1e-14.
    
    Returns
    -------
    x : vector, length(K)
        The vector of random samples
    """


    if butools.checkInput and not CheckPHRepresentation(a,A,prec):
        raise Exception("SamplesFromPH: input is not a valid PH representation!")

    # auxilary variables
    a = a.A.flatten()
    N = len(a)
    cummInitial = np.cumsum(a)
    sojourn = -1.0/np.diag(A)
    nextpr = ml.matrix(np.diag(sojourn))*A
    nextpr = nextpr - ml.matrix(np.diag(np.diag(nextpr)))
    nextpr = np.hstack((nextpr, 1.0-np.sum(nextpr,1)))
    nextpr = np.cumsum(nextpr,1)
    
    x = np.zeros(k)
    for n in range(k):
        time = 0

        # draw initial distribution
        r = rand()
        state = 0
        while cummInitial[state]<=r:
            state+=1

        # play state transitions
        while state<N:
            time += - np.log(rand()) * sojourn[state]
            r = rand()
            nstate = 0
            while nextpr[state,nstate]<=r:
                nstate += 1
            state = nstate
        x[n] = time
    return x
    
def ImageFromPH(alpha,A,outFileName=None,prec=1e-13):
    """
    Depicts the given phase-type distribution,
    and either displays it or saves it to file.
    
    Parameters
    ----------
    alpha : matrix, shape (1,M)
        The initial probability vector of the phase-type
        distribution.
    A : matrix, shape (M,M)
        The transient generator matrix of the phase-type
        distribution.
    outFileName : string, optional
        If it is not provided, or equals to 'display', the
        image is displayed on the screen, otherwise it is 
        written to the file. The file format is deduced 
        from the file name.
    prec : double, optional
        Transition rates less then prec are considered to
        be zero and are left out from the image. The 
        default value is 1e-13.
    
    Notes
    -----
    The 'graphviz' software must be installed and available
    in the path to use this feature.
    """

    if outFileName==None or outFileName=="display":
        outputFile = "_result.png"
        displ = True
    else:
        outputFile = outFileName
        displ = False
    
    inputFile = "_temp.dot"

    fid = open(inputFile,'w')
    fid.write ("digraph G {\n")
    fid.write ("\trankdir=LR;\n")
    fid.write ('\tnode [shape=circle,width=0.3,height=0.3,label=""];\n')
    
    # nodes
    alpha = np.flatten(alpha)
    for i in range(len(alpha)):
        fid.write ('\tn%d [xlabel=<<i>%g</i>>];\n' % (i, alpha[i]))
    
    # transitions to a non-absorbing state
    for i in range(len(alpha)):
        for j in range(len(alpha)):
            if i!=j and abs(A[i,j])>prec:
                fid.write('\tn%d -> n%d [label="%g"];\n' % (i, j, A[i,j]))
    
    # transitions to the absorbing state
    fid.write('\tab [style=filled];\n')
    a = -np.sum(A,1)
    for i in range(len(alpha)):
        if abs(a[i])>prec:
            fid.write('\tn%d -> ab [label="%g"];\n' % (i, a[i]))

    fid.write('}\n')
    fid.close()

    ext = os.path.splitext(outputFile)[1]
    subprocess.call(['dot', "-T"+ext, inputFile, "-o", outputFile])
    
#    delete (inputFile);
#    if displ:
#        delete(outputFile);
