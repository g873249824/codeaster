/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF MLNBPR utilitai  DATE 02/06/2006   AUTEUR MCOURTOI M.COURTOIS */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2001  EDF R&D              WWW.CODE-ASTER.ORG */
/*                                                                    */
/* THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR      */
/* MODIFY IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS     */
/* PUBLISHED BY THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE */
/* LICENSE, OR (AT YOUR OPTION) ANY LATER VERSION.                    */
/* THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL,    */
/* BUT WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF     */
/* MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU   */
/* GENERAL PUBLIC LICENSE FOR MORE DETAILS.                           */
/*                                                                    */
/* YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE  */
/* ALONG WITH THIS PROGRAM; IF NOT, WRITE TO : EDF R&D CODE_ASTER,    */
/*    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.     */
/* ================================================================== */
/* fournit le nombre de  threads en execution */
/*issu de l'afectation de la variable d environement OMP_NUM_THREADS  */
/* ------------------------------------------------------------------ */
#if defined SOLARIS || IRIX || P_LINUX || TRU64 || LINUX64 || SOLARIS64 
 int  mlnbpr_()
#elif defined HPUX
 int  mlnbpr()
#elif defined PPRO_NT
 int __stdcall MLNBPR()
#endif
{
#ifdef OMP
{
    extern int omp_get_max_threads();
    int nump;
    nump= omp_get_max_threads() ;
    return(nump);
}
#else
{
    int nump;
    nump=1;
    return(nump);
}

#endif
}
