      *================================================*
      * PROGRAMA : PROCONTA                           *
      * DESCRICAO: PROCESSAMENTO DE CONTAS BANCARIAS  *
      *   - LE ARQUIVO ORDENADO POR AGENCIA           *
      *   - EXIBE DADOS DAS CONTAS                    *
      *   - CALCULA TOTAL DE CONTAS E SALDO TOTAL     *
      *   - EXIBE SALDO TOTAL POR AGENCIA             *
      * AUTOR    : MATEUS                             *
      * DATA     : 2025                               *
      *================================================*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROCONTA.
       AUTHOR. MATEUS.

      *================================================*
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARQ-CONTAS ASSIGN TO UT-S-CONTASIN
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE  IS SEQUENTIAL
               FILE STATUS  IS WS-STATUS.

      *================================================*
       DATA DIVISION.
       FILE SECTION.

       FD  ARQ-CONTAS
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS
           RECORD CONTAINS 55 CHARACTERS
           LABEL RECORDS ARE STANDARD.
           COPY CONTASC.

      *================================================*
       WORKING-STORAGE SECTION.

       01 WS-STATUS           PIC XX    VALUE SPACES.
       01 WS-FIM              PIC X     VALUE 'N'.
       01 WS-PRIMEIRA         PIC X     VALUE 'S'.

       01 WS-TOTAL-CONTAS     PIC 9(05) VALUE ZEROS.
       01 WS-SALDO-TOTAL      PIC S9(13)V99 VALUE ZEROS.

       01 WS-AGENCIA-ATUAL    PIC 9(04) VALUE ZEROS.
       01 WS-TOTAL-AG         PIC 9(05) VALUE ZEROS.
       01 WS-SALDO-AG         PIC S9(13)V99 VALUE ZEROS.

       01 WS-SALDO-EDIT       PIC ZZZ,ZZZ,ZZZ,ZZ9.99-.
       01 WS-SALDO-AG-EDIT    PIC ZZZ,ZZZ,ZZZ,ZZ9.99-.
       01 WS-SALDO-TOT-EDIT   PIC ZZZ,ZZZ,ZZZ,ZZ9.99-.
       01 WS-TIPO-DESC        PIC X(09) VALUE SPACES.

      *================================================*
       PROCEDURE DIVISION.

      *------------------------------------------------*
       0000-PRINCIPAL.
           PERFORM 1000-INICIALIZAR.
           PERFORM 2000-PROCESSAR UNTIL WS-FIM = 'S'.
           PERFORM 3000-FINALIZAR.
           STOP RUN.

      *------------------------------------------------*
       1000-INICIALIZAR.
           OPEN INPUT ARQ-CONTAS.
           IF WS-STATUS NOT = '00'
               DISPLAY '*** ERRO AO ABRIR - STATUS: ' WS-STATUS
               MOVE 'S' TO WS-FIM.

           DISPLAY ' '.
           DISPLAY '=============================================='.
           DISPLAY '  PROCESSAMENTO DE CONTAS BANCARIAS          '.
           DISPLAY '=============================================='.
           DISPLAY ' '.
           DISPLAY 'CONTA    AGN  TIPO      CLIENTE              '.
           DISPLAY '----------------------------------------------'.

           PERFORM 9000-LER.

      *------------------------------------------------*
       2000-PROCESSAR.
           IF WS-PRIMEIRA = 'S'
               MOVE AGENCIA     TO WS-AGENCIA-ATUAL
               MOVE 'N'         TO WS-PRIMEIRA.

           IF AGENCIA NOT = WS-AGENCIA-ATUAL
               PERFORM 2500-QUEBRA-AGENCIA.

           IF TIPO-CONTA = 'C'
               MOVE 'CORRENTE ' TO WS-TIPO-DESC
           ELSE
           IF TIPO-CONTA = 'P'
               MOVE 'POUPANCA ' TO WS-TIPO-DESC
           ELSE
               DISPLAY '*** TIPO INVALIDO: ' NUM-CONTA
               PERFORM 9000-LER
               GO TO 2000-PROCESSAR-EXIT.

           MOVE SALDO TO WS-SALDO-EDIT.

           DISPLAY NUM-CONTA ' ' AGENCIA ' ' WS-TIPO-DESC ' '
                   NOME-CLIENTE ' ' WS-SALDO-EDIT.

           ADD 1     TO WS-TOTAL-CONTAS.
           ADD 1     TO WS-TOTAL-AG.
           ADD SALDO TO WS-SALDO-TOTAL.
           ADD SALDO TO WS-SALDO-AG.

           PERFORM 9000-LER.

           2000-PROCESSAR-EXIT.
               EXIT.

      *------------------------------------------------*
       2500-QUEBRA-AGENCIA.
           MOVE WS-SALDO-AG TO WS-SALDO-AG-EDIT.
           DISPLAY ' '.
           DISPLAY '  >> AGENCIA: ' WS-AGENCIA-ATUAL
                   '  CONTAS: ' WS-TOTAL-AG
                   '  SALDO: ' WS-SALDO-AG-EDIT.
           DISPLAY '----------------------------------------------'.

           MOVE AGENCIA TO WS-AGENCIA-ATUAL.
           MOVE ZEROS   TO WS-TOTAL-AG.
           MOVE ZEROS   TO WS-SALDO-AG.

      *------------------------------------------------*
       3000-FINALIZAR.
           IF WS-PRIMEIRA = 'N'
               PERFORM 2500-QUEBRA-AGENCIA.

           MOVE WS-SALDO-TOTAL TO WS-SALDO-TOT-EDIT.
           DISPLAY ' '.
           DISPLAY '=============================================='.
           DISPLAY '  RESUMO GERAL                               '.
           DISPLAY '=============================================='.
           DISPLAY '  TOTAL DE CONTAS : ' WS-TOTAL-CONTAS.
           DISPLAY '  SALDO TOTAL     : ' WS-SALDO-TOT-EDIT.
           DISPLAY '=============================================='.

           CLOSE ARQ-CONTAS.

      *------------------------------------------------*
       9000-LER.
           READ ARQ-CONTAS
               AT END MOVE 'S' TO WS-FIM.
           IF WS-STATUS NOT = '00' AND WS-STATUS NOT = '10'
               DISPLAY '*** ERRO LEITURA - STATUS: ' WS-STATUS
               MOVE 'S' TO WS-FIM.
