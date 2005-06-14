/* -------------------------------------------------------------------- */
/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF LSEGJV UTILITAI  DATE 23/09/2002   AUTEUR MCOURTOI M.COURTOIS */
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
/* -------------------------------------------------------------------- */
#include <stdlib.h>
#if defined SOLARIS || IRIX || P_LINUX || TRU64 || SOLARIS64 
   long lsegjv_(long* val)
#elif defined HPUX
   long lsegjv(long* val)
#elif defined PPRO_NT
   long __stdcall LSEGJV(long* val)
#endif
/*
** Fonction pour positionner et interroger l'indicateur de longueur
** des segments de valeurs associ�s au type 3 de
** parcours de la segmentation de memoire JEVEUX
** val -> si <  0 LSEGJV renvoie le type de parcourt
**        si >= 0 positionne l'indicateur
*/
{
static long LSEG_JEVEUX=0;
if (*val >= 0) {
   LSEG_JEVEUX=*val;
   }
return(LSEG_JEVEUX);
}
