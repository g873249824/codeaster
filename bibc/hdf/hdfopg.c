/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF hdfopg hdf  DATE 13/10/2009   AUTEUR COURTOIS M.COURTOIS */
/* ================================================================== */
/* COPYRIGHT (C) 1991 - 2003  EDF R&D              WWW.CODE-ASTER.ORG */
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
#include <stdlib.h>
#include "aster.h"
/*-----------------------------------------------------------------------------/
/ Ouverture d'un groupe HDF, renvoie une erreur si le groupe ne peut �tre ouvert 
/  Param�tres :
/   - in idfile : identificateur du fichier (hid_t)
/   - in  nomgr : nom du groupe (contient toute l'arborescence depuis "/")
/  R�sultats :
/     identificateur du groupe, -1 sinon (hid_t = int)
/-----------------------------------------------------------------------------*/
#include <hdf5.h>

INTEGER DEFPS(HDFOPG, hdfopg, INTEGER *idf, char *nomgr, STRING_SIZE ln)
{
  hid_t  idgrp,idfic;     
  char *nomd;
  int k;
  long iret=-1;
  void *malloc(size_t size);
  
  idfic=(hid_t) *idf;
  nomd = (char *) malloc((ln+1) * sizeof(char));
  for (k=0;k<ln;k++) {
     nomd[k] = nomgr[k];
  }
  k=ln-1;
  while (nomd[k] == ' ' || nomd[k] == '/') { k--;}
  if ( k == -1 ) {
    nomd[k+1] = '/';
    k++;
  } 
  nomd[k+1] = '\0';

  if ((idgrp = H5Gopen(idfic, nomd)) >= 0) 
    iret = (long) idgrp;
  free (nomd);
  return iret;
}     
