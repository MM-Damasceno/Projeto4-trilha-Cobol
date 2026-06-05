//COBLCL   JOB (COBOL),'MATEUS',CLASS=A,MSGCLASS=A,
//             MSGLEVEL=(1,1),NOTIFY=HERC01
//*================================================*
//* JOB    : COBLCL                               *
//* DESCRICAO: COMPILA E LINKA O PROGRAMA         *
//*            PROCONTA                           *
//*================================================*
//COBSTEP  EXEC COBUCG,
//             PARM.COB='APOST,XREF,LIB,STATE',
//             PARM.LKED='LIST,XREF,LET'
//COB.SYSIN   DD DSN=HERC01.COBOL.SOURCE(PROCONTA),DISP=SHR
//COB.SYSLIB  DD DSN=HERC01.COBOL.COPY,DISP=SHR
//LKED.SYSLMOD DD DSN=HERC01.COBOL.LOAD(PROCONTA),DISP=SHR
