%{
  #include "lex.yy.c"  
  #include <stdio.h>
  #include "symbol_table.h"
  #include "symbol_table.c"

  int yylex();
  void yyerror(char *s); // const char *s
  int global_type;
  char *global_id_name;
  int global_syntax_errors = 0;
%}

%union {
  char *name;
  float value_float;
  int value_int;
  int tipo;
  char letter;
}

/* definitions */
%token START END

%token ASTERISCO BARRA CHAPEU MENOS PERCENTUAL SHIFTLEFT SHIFTRIGHT OPERADORDOIDO  /*unários*/

%token DIFERENTE IGUAL IGUALIGUAL MAIOROUIGUAL MAIORQUE MAIS MENOROUIGUAL MENORQUE /*relacionais*/

%token EDOUBLE ELOGICO PIPE PIPEDOUBLE /*lógicos*/

%token ABREEXPRESSAO FECHAEXPRESSAO ABREESCOPO FECHAESCOPO /*blocos*/

/*tokens modificadores*/
%token VOLATILE REGISTER
%token DOUBLE INT CHAR FLOAT VOID TRUE FALSE
%token SIGNED UNSIGNED
%token LONG SHORT
%token CONST

/*tokens operadores*/
%token <name> ID
%token <letter> LETTER
%token <value_int> POSITIVE
%token <value_int> NEGATIVE
%token <value_float> DECIMAL
%token DEFAULT IF ELSE ELSEIF BREAK CASE CONTINUE RETURN SWITCH
%token DO WHILE FOR GOTO
%token SIZEOF

%start start_point
%% 

break 
  : BREAK { /* vazio */ }
  ;

term
  : LETTER { }
  | identificador {}
  | DECIMAL  {}
  | POSITIVE {}
  | NEGATIVE {}
  ;

expr 
  : expr ASTERISCO expr { /* vazio */ }
  | expr BARRA expr { /* vazio */ }
  | expr CHAPEU expr { /* vazio */ }
  | expr DIFERENTE expr { /* vazio */ }
  | expr EDOUBLE expr { /* vazio */ }
  | expr ELOGICO expr { /* vazio */ }
  | expr IGUALIGUAL expr { /* vazio *name */ }
  | expr MAIORQUE expr { /* vazio */ }
  | expr MAIS expr { /* vazio */ }
  | expr MENOROUIGUAL expr { /* vazio */ }
  | expr MAIOROUIGUAL expr { /* vazio */ }
  | expr MENORQUE expr { /* vazio */ }
  | expr MENOS expr { /* vazio */ }
  | expr PERCENTUAL expr { /* vazio */ }
  | expr PIPE expr { /* vazio */ }
  | expr PIPEDOUBLE expr { /* vazio */ }
  | expr SHIFTLEFT expr { /* vazio */ }
  | expr SHIFTRIGHT expr { /* vazio */ }
  | expr OPERADORDOIDO expr { /* vazio */ }
  | ABREEXPRESSAO expr FECHAEXPRESSAO { /* vazio */ }
  | term
  ;

case 
  : CASE expr ':' stmt ';' { /* vazio */ }
  | DEFAULT ':' stmt ';' { /* vazio */ }
  ;

continue 
  : CONTINUE { /* vazio */ }
  ;

conditional 
  : IF ABREEXPRESSAO expr FECHAEXPRESSAO bloco { /* vazio */ }
  | IF ABREEXPRESSAO expr FECHAEXPRESSAO bloco elseif { /* vazio */ }
  | IF ABREEXPRESSAO expr FECHAEXPRESSAO bloco ELSE bloco { /* vazio */ }
  ;

elseif 
  : ELSEIF ABREEXPRESSAO expr FECHAEXPRESSAO bloco { /* vazio */ }
  | ELSEIF ABREEXPRESSAO expr FECHAEXPRESSAO bloco elseif { /* vazio */ }
  | ELSEIF ABREEXPRESSAO expr FECHAEXPRESSAO bloco elseif ELSE bloco { /* vazio */ }
  ;

identificador
  : ID { global_id_name = strdup($<name>1);installSymbolAtSymbolTable($<name>1, global_type); }
  ;

definicaoVariavel 
  : modificadorTipo identificador IGUAL expr ';' { /* vazio */ }
  ;

definicaoFuncao 
  : modificadorTipo identificador ABREEXPRESSAO tipoParametros FECHAEXPRESSAO bloco { /* vazio */ }
  ;

do : 
  DO ABREESCOPO stmtLoop FECHAESCOPO WHILE ABREEXPRESSAO expr FECHAEXPRESSAO ';' { /* vazio */ }
  ;


for 
  : FOR ABREEXPRESSAO stmt expr ';' stmt FECHAEXPRESSAO blocoLoop { /* vazio */ }
  ;

goto 
  : GOTO label ';' { /* vazio */ }
  ;

label 
  : identificador ':' { /* vazio */ }
  ;


modificadorTipo 
  : CHAR      {global_type = TYPE_CHAR;}
  | VOID      {global_type = TYPE_VOID;}
  | FLOAT     {global_type = TYPE_FLOAT;}
  | DOUBLE    {global_type = TYPE_DOUBLE;}
  | INT       {global_type = TYPE_INT;}
  ;


tipoParametros 
  : tipoParametros ',' tipoParametros { /* vazio */ }
  | modificadorTipo identificador { /* vazio */ }
  | /*vazio*/ { /* vazio */ }
  ;

parametros
  : parametros ',' parametros { /* vazio */ }
  | term { /* vazio */ }
  | /*vazio*/ { /* vazio */ }
  ;

return 
  : RETURN expr { /* vazio */ }
  | RETURN functionCall { /* vazio */ }
  | RETURN { /* vazio */ }
  ;

sizeof 
  : SIZEOF ABREEXPRESSAO identificador FECHAEXPRESSAO { /* vazio */ }
  ;

functionCall
  : identificador ABREEXPRESSAO parametros FECHAEXPRESSAO { /* vazio */ }
  ;
 
stmtList
  : stmt
  | stmt stmtList
  ;

stmtListLoop
  : stmtLoop
  | stmtLoop stmtListLoop
  ;

stmt 
  : while stmt { /* vazio */ }
  | expr IGUAL expr ';' { /* vazio */ }
  | for stmt { /* vazio */ }
  | switch stmt { /* vazio */ }
  | goto { /* vazio */ }
  | do stmt { /* vazio */ }
  | conditional stmt { /* vazio */ }
  | sizeof stmt { /* vazio */ }
  | functionCall stmt { /* vazio */ }
  | return ';' { /* vazio */ }
  | definicaoFuncao stmt { /* vazio */ }
  | definicaoVariavel stmt { /* vazio */ }
  | /* usado para permitir mais de um stmt dentro de um escopo */ { /* vazio */ }
  ;

switch 
  : SWITCH ABREEXPRESSAO identificador FECHAEXPRESSAO ABREESCOPO variosCase FECHAESCOPO { /* vazio */ }
  ;

variosCase 
  : variosCase variosCase ';' { /* vazio */ }
  | case ';' { /* vazio */ }
  | /*vazio*/ { /* vazio */ }
  ;

bloco
  : ABREESCOPO stmtList FECHAESCOPO
  | stmt
  ;

blocoLoop
  : ABREESCOPO stmtListLoop FECHAESCOPO
  | stmtLoop
  ;

stmtLoop 
  : while stmtLoop { /* vazio */ }
  | expr IGUAL expr ';' { /* vazio */ }
  | for stmtLoop { /* vazio */ }
  | switch stmtLoop { /* vazio */ }
  | goto { /* vazio */ }
  | break ';' { /* vazio */ }
  | continue ';' { /* vazio */ }
  | do stmtLoop { /* vazio */ }
  | conditional stmtLoop { /* vazio */ }
  | sizeof stmtLoop { /* vazio */ }
  | functionCall stmtLoop { /* vazio */ }
  | return ';' { /* vazio */ }
  | definicaoFuncao stmtLoop { /* vazio */ }
  | definicaoVariavel stmtLoop { /* vazio */ }
  | /* usado para permitir mais de um stmt dentro de um escopo */ { /* vazio */ }
  ;

while 
  : WHILE ABREEXPRESSAO expr FECHAEXPRESSAO ABREESCOPO stmtLoop FECHAESCOPO { /* vazio */ }
  ;

start_point
  : START stmtList END
  ;

%% 

int lineno = 0;

/* auxiliary routines */
   
/* yacc error handler */
void yyerror(char *s) { // const char *s
  // fprintf(stderr, "%s\n", s);
  printf("\n\nErro na linha: %d %s %s\n", lineno, s, yytext);
  global_syntax_errors++;
}

int main() {
  initBlockList();
  yyparse();

  if(global_syntax_errors == 0) {
    printSymbolTable();
    printf("\n\nPrograma correto\n");
  }

  return 0;
}