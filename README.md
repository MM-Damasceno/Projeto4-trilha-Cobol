# Projeto 4 - COBOL - Processamento de Contas Bancárias
**Acelera Maker | Semana 6**

## Descrição
Sistema de processamento de contas bancárias desenvolvido em COBOL para ambiente MVS (TK5/Hercules).

O job JCL realiza:
1. Concatenação dos arquivos de contas
2. Ordenação por agência
3. Execução do programa COBOL para processamento e exibição de relatório

---

## Estrutura do Projeto

```
cobol-contas/
├── copy/
│   └── CONTASC.cpy       → Copybook do registro de contas
├── source/
│   └── PROCONTA.cbl      → Programa COBOL principal
├── data/
│   ├── CONTAS.txt        → Arquivo de contas principal
│   └── CONTASN.txt       → Arquivo de contas novas (desafio)
└── jcl/
    ├── COBLCL.jcl        → JCL de compilação e link
    └── BANCJOB.jcl       → JCL principal do job
```

---

## Layout do Registro (Copybook CONTASC)

| Campo        | Tipo      | Tamanho | Descrição                  |
|--------------|-----------|---------|----------------------------|
| NUM-CONTA    | PIC 9(08) | 8       | Número da conta            |
| NOME-CLIENTE | PIC X(30) | 30      | Nome do cliente            |
| AGENCIA      | PIC 9(04) | 4       | Código da agência          |
| TIPO-CONTA   | PIC X(01) | 1       | C=Corrente / P=Poupança    |
| SALDO        | PIC S9(09)V99 | 12  | Saldo da conta             |

**LRECL total: 55 bytes**

---

## Datasets no Mainframe (TK5)

| Dataset               | RECFM | LRECL | Conteúdo             |
|-----------------------|-------|-------|----------------------|
| HERC01.COBOL.SOURCE   | FB    | 80    | Programa PROCONTA    |
| HERC01.COBOL.COPY     | FB    | 80    | Copybook CONTASC     |
| HERC01.COBOL.LOAD     | U     | 0     | Load module          |
| HERC01.COBOL.DATA     | FB    | 55    | Arquivos de dados    |
| HERC01.JCL.SOURCE     | FB    | 80    | JCLs                 |

---

## Como Executar

### 1. Alocar os Datasets
No RFE (opção 3.2), criar os 5 datasets conforme tabela acima.

### 2. Carregar os Members
Copiar o conteúdo de cada arquivo para o respectivo member no mainframe via RFE (opção 2).

### 3. Compilar o Programa
Submeter o JCL `COBLCL` via TSO:
```
SUB HERC01.JCL.SOURCE(COBLCL)
```
Verificar RC=0000 no SDSF.

### 4. Executar o Job
Submeter o JCL `BANCJOB`:
```
SUB HERC01.JCL.SOURCE(BANCJOB)
```
Verificar RC=0000 nos 3 steps no SDSF.

---

## Funcionalidades
- ✅ Leitura de arquivo ordenado por agência
- ✅ Exibição dos dados de cada conta
- ✅ Cálculo do total de contas
- ✅ Cálculo do saldo total geral
- ✅ **[Desafio]** Concatenação de arquivo CONTAS.NOVAS antes da ordenação
- ✅ **[Desafio]** Saldo total por agência
- ✅ **[Desafio]** Validação de tipo de conta inválido

---

## Ambiente
- **Emulador:** Hercules
- **SO:** MVS 3.8j (TK5)
- **Compilador:** OS/VS COBOL
- **Interface:** RFE via PW3270
# Projeto4-trilha-Cobol
