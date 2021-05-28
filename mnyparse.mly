%{
open Mnyast ;;

%}

%token <float> FLOAT
%token <string> IDENT
%token TRUE FALSE
%token <string> STRING
%token PLUS MINUS MULT DIV EQUAL GREATER SMALLER GREATEREQUAL SMALLEREQUAL
%token LPAREN RPAREN SEMICOLON TWOSEMICOLONS ARROW COLON COMMA LBRACK RBRACK DOT
%token SET FUN WALLET ASSET TRANSAC
%token IF THEN ELSE
%token BUY WITH THROUGH
%token OF
%token REC
%token NOTEQUAL EXCLAM XOR OR AND PERCENT
%left EQUAL GREATER SMALLER GREATEREQUAL SMALLEREQUAL NOTEQUAL
%left PLUS MINUS
%left MULT DIV
%left DOT
%left EXCLAM XOR OR AND
%right PERCENT


%start main
%type <Mnyast.expr> main

%%

main: expr TWOSEMICOLONS {$1} | TWOSEMICOLONS main {$2}
;

expr:
    | SET IDENT EQUAL expr SEMICOLON expr { EAff ($2, $4, $6) }
    | IF expr THEN expr ELSE expr   { EIf($2, $4, $6) }
    | SET REC IDENT EQUAL FUN IDENT ARROW expr SEMICOLON expr { EFunrec($3, $6, $8, $10) }
    | FUN IDENT ARROW expr { EFun($2, $4) }
    | arith_expr   { $1 } 
    | ASSET asset { $2 }
    | WALLET wallet { $2 }
    | BUY transac { $2 }
;

asset :
    expr OF IDENT    { EAsset($1, $3) }
    |                { EAsset(EFloat(1.), "GEN") }
;

wallet:
    | LBRACK wallet_assets RBRACK    { EWallet($2) }
;

wallet_assets:
    IDENT COLON expr COMMA wallet_assets    { ($1,$3)::$5 }
    | IDENT COLON expr { ($1,$3)::[] }
    |                  { [] }
;

transac:
    expr OF IDENT WITH IDENT THROUGH IDENT  { EBuy($1, $3, $5, $7) }
    | expr OF IDENT WITH IDENT              { EBuy($1, $3, $5, $5) }
;



arith_expr:
    arith_expr EQUAL arith_expr    { EBinop ("=", $1, $3) }
    | arith_expr NOTEQUAL arith_expr   { EBinop("!=", $1, $3) }
    | arith_expr GREATER arith_expr    { EBinop (">", $1, $3) }
    | arith_expr GREATEREQUAL arith_expr    { EBinop (">=", $1, $3) }
    | arith_expr SMALLER arith_expr    { EBinop ("<", $1, $3) }
    | arith_expr SMALLEREQUAL arith_expr    { EBinop ("<=", $1, $3) }
    | arith_expr PLUS arith_expr    { EBinop ("+", $1, $3) }
    | arith_expr MINUS arith_expr    { EBinop ("-", $1, $3) }
    | arith_expr MULT arith_expr    { EBinop ("*", $1, $3) }
    | arith_expr DIV arith_expr    { EBinop ("/", $1, $3) }
    | arith_expr XOR arith_expr    { EBinop("^", $1, $3) }
    | arith_expr OR arith_expr     { EBinop("||", $1, $3) }
    | arith_expr AND arith_expr    { EBinop("&&", $1, $3) }
    | arith_expr DOT IDENT    { EDot($1, $3) }
    | application                   { $1 } 
;

application: 
    application atom { EApp ($1, $2) }
    | MINUS atom     { EMonop("-", $2) }
    | EXCLAM atom    { EMonop("!", $2) }
    | PLUS atom      { EMonop("+", $2) }
    | atom PERCENT   { EMonop("%", $1) }
    | atom     { $1 }
    
;

atom: 
    FLOAT       { EFloat ($1) }
    | TRUE    { EBool (true) }
    | FALSE   { EBool (false) }
    | STRING  { EString ($1) }
    | IDENT   { EIdent ($1) }
    | wallet  { $1 }
    | LPAREN expr RPAREN   { $2 }
    
;
