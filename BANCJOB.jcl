//BANCJOB  JOB (BANCO),'MATEUS',CLASS=A,MSGCLASS=A,
//             MSGLEVEL=(1,1),NOTIFY=HERC01
//*================================================*
//* JOB    : BANCJOB                              *
//* DESCRICAO: PROCESSAMENTO DE CONTAS BANCARIAS  *
//*   STEP1 - CONCATENA CONTAS + CONTAS.NOVAS     *
//*   STEP2 - ORDENA POR AGENCIA                  *
//*   STEP3 - EXECUTA PROGRAMA PROCONTA           *
//*================================================*
//*
//*------------------------------------------------*
//* STEP1: CONCATENACAO DOS ARQUIVOS              *
//*------------------------------------------------*
//STEP1    EXEC PGM=IEBGENER
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//SYSUT1   DD  DSN=HERC01.COBOL.DATA(CONTAS),DISP=SHR
//         DD  DSN=HERC01.COBOL.DATA(CONTASN),DISP=SHR
//SYSUT2   DD  DSN=&&CONCAT,DISP=(NEW,PASS),
//             UNIT=SYSDA,SPACE=(TRK,(5,2)),
//             DCB=(RECFM=FB,LRECL=55,BLKSIZE=550)
//*
//*------------------------------------------------*
//* STEP2: ORDENACAO POR AGENCIA                  *
//*   AGENCIA = POSICAO 39, TAMANHO 4, ZD, ASC    *
//*------------------------------------------------*
//STEP2    EXEC PGM=SORT
//SYSPRINT DD  SYSOUT=*
//SYSOUT   DD  SYSOUT=*
//SORTIN   DD  DSN=&&CONCAT,DISP=(OLD,DELETE)
//SORTOUT  DD  DSN=&&SORTED,DISP=(NEW,PASS),
//             UNIT=SYSDA,SPACE=(TRK,(5,2)),
//             DCB=(RECFM=FB,LRECL=55,BLKSIZE=550)
//SYSIN    DD  *
  SORT FIELDS=(39,4,ZD,A)
/*
//*
//*------------------------------------------------*
//* STEP3: EXECUCAO DO PROGRAMA COBOL             *
//*------------------------------------------------*
//STEP3    EXEC PGM=PROCONTA
//STEPLIB  DD  DSN=HERC01.COBOL.LOAD,DISP=SHR
//CONTASIN DD  DSN=&&SORTED,DISP=(OLD,DELETE)
//SYSOUT   DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
