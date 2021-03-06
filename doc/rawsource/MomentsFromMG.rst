butools.dph.MomentsFromMG
=========================

.. currentmodule:: butools.dph

.. np:function:: MomentsFromMG

    .. list-table::
        :widths: 25 150

        * - Matlab:
          - :code:`moms = MomentsFromMG(alpha, A, K, prec)`
        * - Mathematica:
          - :code:`moms = MomentsFromMG[alpha, A, K, prec]`
        * - Python/Numpy:
          - :code:`moms = MomentsFromMG(alpha, A, K, prec)`

    Returns the first K moments of a matrix geometric 
    distribution.

    Parameters
    ----------
    alpha : vector, shape (1,M)
        The initial vector of the matrix-geometric distribution.
        The sum of the entries of alpha is less or equal to 1.
    A : matrix, shape (M,M)
        The matrix parameter of the matrix-geometric 
        distribution.
    K : int, optional
        Number of moments to compute. If K=0, 2*M-1 moments are
        computed. The default value is 0.
    prec : double, optional
        Numerical precision for checking the input.
        The default value is 1e-14.

    Returns
    -------
    moms : row vector of doubles
        The vector of moments.
        
    Examples
    --------    
    For Matlab:
    
    >>> a=[-0.6 0.3 1.3];
    >>> A=[0.25 0.2 -0.15; 0.3 0.1 0.25; 0 0.2 0.47];
    >>> moms = MomentsFromMG(a,A,3)
           3.4675       16.203       97.729
    >>> mean = MomentsFromMG(a,A,1)
           3.4675

    For Python/Numpy:
    
    >>> a = ml.matrix([[-0.6, 0.3, 1.3]])
    >>> A = ml.matrix([[0.25, 0.2, -0.15],[0.3, 0.1, 0.25],[0, 0.2, 0.47]])
    >>> moms=MomentsFromMG(a,A,3)
    >>> print(moms)
    [3.4674735249621778, 16.202576158568199, 97.728650249528698]
    >>> mean=MomentsFromMG(a,A,1)
    >>> print(mean)
    [3.4674735249621778]

