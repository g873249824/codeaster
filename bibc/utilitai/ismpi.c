/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF ISMPI utilitai  DATE 29/03/2011   AUTEUR COURTOIS M.COURTOIS */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2011  EDF R&D              WWW.CODE-ASTER.ORG */
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
#include "aster.h"

INTEGER STDCALL(ISMPI, ismpi) ()
/*
** Fonction pour interroger l'indicateur le type d'executable Aster 
** Renvoie 1 si l'ex�cutable a �t� compil� avec l'option _USE_MPI
** Renvoie 0 si l'ex�cutable n'a pas �t� compil� avec l'option _USE_MPI
*/
{
#ifdef _USE_MPI
   static INTEGER IND_COMP_MPI=1;
#else	
   static INTEGER IND_COMP_MPI=0;
#endif	

return IND_COMP_MPI;
}
