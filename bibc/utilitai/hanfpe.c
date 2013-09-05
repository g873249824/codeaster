/* ------------------------------------------------------------------ */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2012  EDF R&D              WWW.CODE-ASTER.ORG */
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
/* ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,      */
/*    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.     */
/* ================================================================== */
/* ------------------------------------------------------------------ */
#include "aster.h"

/*
**  Fonction C intermediaire pour appeler une routine FORTRAN
**  qui va faire appel a UTMESS('F',...)
**  Il n'y a pas de passage d'argument pour minimiser les problemes
**  d'interfacage FORTRAN/C et reciproquement
*/
#if defined _POSIX
#include <stdio.h>
#include <stdlib.h>
#endif

#if defined SOLARIS
#include <siginfo.h>
#include <ucontext.h>
   void hanfpe (int sig, siginfo_t *sip, ucontext_t *uap)
#else
   void hanfpe (int sig)
#endif
{
   void exit (int status);
   void DEF0(UTMFPE, utmfpe);
   
   CALL0(UTMFPE, utmfpe);
   exit(sig);
}
