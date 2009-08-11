/* ------------------------------------------------------------------ */
/*           CONFIGURATION MANAGEMENT OF EDF VERSION                  */
/* MODIF python supervis  DATE 11/08/2009   AUTEUR LEFEBVRE J-P.LEFEBVRE */
/* RESPONSABLE LEFEBVRE J-P.LEFEBVRE */
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
/* Minimal main program -- everything is loaded from the library */

#include "Python.h"
#ifdef _USE_MPI
#include "mpi.h"
#endif

extern DL_EXPORT(int) Py_Main();
extern void initaster();
extern void initaster_fonctions();

#ifdef _USE_MPI
void terminate(){
  printf("Fin interpreteur Python\n");
  MPI_Finalize();
}
#endif

int
main(argc, argv)
	int argc;
	char **argv;

{
   int ierr;
#ifdef _USE_MPI
   int me, rc, namelen, nbproc;
	char processor_name[MPI_MAX_PROCESSOR_NAME];
   
   rc = MPI_Init(&argc,&argv);
	if (rc != MPI_SUCCESS) {
	     fprintf(stderr, "MPI Initialization failed: error code %d\n",rc);
	     abort();
	}  
   atexit(terminate);
   MPI_Comm_size(MPI_COMM_WORLD, &nbproc);
   MPI_Comm_rank(MPI_COMM_WORLD, &me);
   MPI_Get_processor_name(processor_name, &namelen);
   printf("\n Version parall�le de Code_aster compil�e avec MPI\n");
   printf(" Ex�cution sur le processeur de nom %s de rang %d\n",processor_name,me);
   printf(" Nombre de processeurs utilis�s %d\n",nbproc);
#else	
   printf("\n Version s�quentielle de Code_aster \n");
#endif	
	
   PyImport_AppendInittab("aster",initaster);

   /* Module d�finissant des op�rations sur les objets fonction_sdaster */
	PyImport_AppendInittab("aster_fonctions",initaster_fonctions);

	ierr= Py_Main(argc, argv);
	return ierr;
}
