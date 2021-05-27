%{
open Mnyast ;;

%}

%token <float> FLOAT
%token <string> IDENT
%token TRUE FALSE
%token <string> STRING
%token PLUS MINUS MULT DIV EQUAL GREATER SMALLER GREATEREQUAL SMALLEREQUAL
%token LPAREN RPAREN SEMICOLON TWOSEMICOLONS ARROW COLON COMMA LBRACK RBRACK DOT
%token VAL FUN WALLET ASSET TRANSAC
%token IF THEN ELSE
%token BUY WITH THROUGH
%token OF
%left EQUAL GREATER SMALLER GREATEREQUAL SMALLEREQUAL
%left PLUS MINUS
%left MULT DIV
%left DOT

%start main
%type <Mnyast.expr> main

%%

main: expr TWOSEMICOLONS {$1} | TWOSEMICOLONS main {$2}
;

expr:
    | VAL IDENT EQUAL expr SEMICOLON expr { EAff ($2, $4, $6) }
    | IF expr THEN expr ELSE expr   { EIf($2, $4, $6) }
    | FUN IDENT ARROW expr { EFun($2, $4) }
    | arith_expr   { $1 } 
    | ASSET asset { $2 }
    | WALLET wallet { $2 }
    | BUY transac { $2 }
;

asset :
    expr OF IDENT    { EAsset($1, $3) }
    | expr           { EAsset($1, "GEN") }
    |                { EAsset(EFloat(1.), "GEN") }
;

wallet:
    | LBRACK wallet_assets RBRACK    { EWallet($2) }
;

wallet_assets:
    IDENT COLON expr COMMA wallet_assets    { ($1,$3)::$5 }
    | IDENT COLON expr { ($1,$3)::[] }
;

transac:
    expr OF IDENT WITH IDENT THROUGH IDENT  { EBuy($1, $3, $5, $7) }
    | expr OF IDENT WITH IDENT              { EBuy($1, $3, $5, $5) }
;



arith_expr:
    arith_expr EQUAL arith_expr    { EBinop ("=", $1, $3) }
    | arith_expr GREATER arith_expr    { EBinop (">", $1, $3) }
    | arith_expr GREATEREQUAL arith_expr    { EBinop (">=", $1, $3) }
    | arith_expr SMALLER arith_expr    { EBinop ("<", $1, $3) }
    | arith_expr SMALLEREQUAL arith_expr    { EBinop ("<=", $1, $3) }
    | arith_expr PLUS arith_expr    { EBinop ("+", $1, $3) }
    | arith_expr MINUS arith_expr    { EBinop ("-", $1, $3) }
    | arith_expr MULT arith_expr    { EBinop ("*", $1, $3) }
    | arith_expr DIV arith_expr    { EBinop ("/", $1, $3) }
    | arith_expr DOT IDENT    { EDot($1, $3) }
    | application                   { $1 } 
;

application: 
    application atom { EApp ($1, $2) }
    | atom     { $1 }
    
;

atom: 
    FLOAT       { EFloat ($1) }
    | TRUE    { EBool (true) }
    | FALSE   { EBool (false) }
    | STRING  { EString ($1) }
    | IDENT   { EIdent ($1) }
    | LPAREN expr RPAREN   { $2 }
    
;
