/* This tells flex to read only one input file */ 
%option noyywrap

%{ 
    /*codigo colocado aqui aparece no arquivo gerado pelo flex*/ 
    #include <stdio.h>
    #include "y.tab.h"
%}

/* definicoes regulares */ 
nl [\n]
delim [ _/\t]

ws		{delim}+ 
digit   [0-9]
true "verdade"
false "mentira"
letter  [a-zA-Z]
positive  ((\+){digit}+)|{digit}+
negative  (-){digit}+
decimal ({positive}|{negative})(\.{digit}+)?(E[+]?{digit}+)?
id  ("CAF")({letter}+|{digit}+|_+)

comment ("comentar").*("comentado")

start "comecou"
end "acabou"

abreEscopo "bonito"
fechaEscopo "feio"

abreExpressao "baixo"
fechaExpressao "alto"

char "dalila"
float "paulo"
double "joaoarthur"
void "danielmendes"
int "daniel"

break "nacif"
case "vinicius"
continue "nancy"
do "vitorhugo"
else "vitorputo"
elseif "vitormudo"
for "bruno"
goto "iara"
if "pato"
return "pascal"
sizeof "brandao"
switch "thais"
while "espeto"

asterisco "amou"
barra "espatifou"
chapeu "parou"
diferente "julgou"
eDouble "corrigiu"
eLogico "comprou"
igual "toma"
igualIgual "tomatoma"
maiorOuIgual "ficou"
maiorQue "enviou"
mais "casou"
menorOuIgual "saiu"
menorQue "recebeu"
menos "estapeou"
percentual "cortou"
pipe "estudou"
pipeDouble "seguiu"
shiftLeft "esquerdou"
shiftRight "direitou"

operadorDoido "endoidou"

%% 
{id}  { printf("%s", yytext); yylval.name = strdup(yytext); return ID;}

{start}    { printf("%s", yytext); return START;}
{end}   { printf("%s", yytext); return END;}

{abreEscopo}    { printf("%s", yytext); return ABREESCOPO;}
{fechaEscopo}   { printf("%s", yytext); return FECHAESCOPO;}

{abreExpressao} { printf("%s", yytext); return ABREEXPRESSAO;}
{fechaExpressao} { printf("%s", yytext); return FECHAEXPRESSAO;}

 
{void}      { printf("%s", yytext); return VOID;}

{char}      { printf("%s", yytext); return CHAR; }
{float}     { printf("%s", yytext); return FLOAT;}
{double}    { printf("%s", yytext); return DOUBLE;}
{int}       { printf("%s", yytext); return INT;}

{true}      { printf("%s", yytext); return TRUE;}
{false}     { printf("%s", yytext); return FALSE;}
{break}     { printf("%s", yytext); return BREAK;}
{case}      { printf("%s", yytext); return CASE;}
{continue}  { printf("%s", yytext); return CONTINUE;}
{do}        { printf("%s", yytext); return DO;}
{else}      { printf("%s", yytext); return ELSE;}
{elseif}    { printf("%s", yytext); return ELSEIF;}
{for}       { printf("%s", yytext); return FOR;}
{goto}      { printf("%s", yytext); return GOTO;}
{if}        { printf("%s", yytext); return IF;}
{return}    { printf("%s", yytext); return RETURN;}
{sizeof}    { printf("%s", yytext); return SIZEOF;}
{switch}    { printf("%s", yytext); return SWITCH;}
{while}     { printf("%s", yytext); return WHILE;}

":"          {printf("%s", yytext); return(':');}
";"          {printf("%s", yytext); return(';');}
","          {printf("%s", yytext); return(',');}

{asterisco}     { printf("%s", yytext); return ASTERISCO;}
{barra}         { printf("%s", yytext); return BARRA;}
{chapeu}        { printf("%s", yytext); return CHAPEU;}
{diferente}     { printf("%s", yytext); return DIFERENTE;}
{eDouble}       { printf("%s", yytext); return EDOUBLE;}
{eLogico}       { printf("%s", yytext); return ELOGICO;}
{igual}         { printf("%s", yytext); return IGUAL;}
{igualIgual}    { printf("%s", yytext); return IGUALIGUAL;}
{maiorOuIgual}  { printf("%s", yytext); return MAIOROUIGUAL;}
{maiorQue}      { printf("%s", yytext); return MAIORQUE;}
{mais}          { printf("%s", yytext); return MAIS;}
{menorOuIgual}  { printf("%s", yytext); return MENOROUIGUAL;}
{menorQue}      { printf("%s", yytext); return MENORQUE;}
{menos}         { printf("%s", yytext); return MENOS;}
{percentual}    { printf("%s", yytext); return PERCENTUAL;}
{pipe}          { printf("%s", yytext); return PIPE;}
{pipeDouble}    { printf("%s", yytext); return PIPEDOUBLE;}
{shiftLeft}     { printf("%s", yytext); return SHIFTLEFT;}
{shiftRight}    { printf("%s", yytext); return SHIFTRIGHT;}

{letter}      { printf("%s", yytext); yylval.letter = yytext[1]; return LETTER;}
{positive}    { printf("%s", yytext); yylval.value_int = atoi(yytext) ;return POSITIVE;}
{negative}    { printf("%s", yytext); yylval.value_int = atoi(yytext) ; return NEGATIVE;}
{decimal}     { printf("%s", yytext); yylval.value_float = atof(yytext) ;return DECIMAL;}

{nl} {extern int lineno; lineno++;printf("\n%d|", lineno);}

{ws}        {printf("\t");} 
{comment}   {/*nenhuma acao e nenhum retorno*/}
%%

    /*
        int main(void) 
        {
            yylex(); 
            return 0; 
        }
    */