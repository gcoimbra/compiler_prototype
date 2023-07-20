#ifndef __TABELA_H__
#define __TABELA_H__

#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"

#define TYPE_VOID 1
#define TYPE_INT 2
#define TYPE_CHAR 3
#define TYPE_DOUBLE 4
#define TYPE_FLOAT 5 
#define TYPE_VOLATILE 6
#define TYPE_REGISTER 7
#define TYPE_CONST 8
#define TYPE_SHORT 9
#define TYPE_LONG 10
#define TYPE_SIGNED 11
#define TYPE_UNSIGNED 12
#define TYPE_TRUE 13
#define TYPE_FALSE 14
  

#define NMax 10

#define TABLE_SIZE 10


typedef struct symbolTable
{
  char *name;
  int kind;
  union {
    int number;
    float decimal;
    char letter;
  } valor;

} symbolTable;

symbolTable SymbolTable[TABLE_SIZE];

extern YYSTYPE yylval;
extern int linha;
extern FILE *yyin, *yyout;

int searchEntryAtSymbolTable(char*);
void initBlockList(void);
void installSymbolAtSymbolTable(char *, int );
void printSymbolTable();
void handleError(int);
void startBlock(void);
void endBlock(void);

int escopo[10];
int indexOfLastestSymbolTableLevel;
int indexOfLastElementAtSymbolTable;

#endif
