%{
open Mnyast ;;
%}

%token <int> INT
%token <string> IDENT
%token TRUE FALSE
%token <string> STRING
%token PLUS MINUS MULT DIV EQUAL GREATER SMALLER GREATEREQUAL SMALLEREQUAL
%token LPAREN RPAREN SEMICOLON TWOSEMICOLONS ARROW COLON COMMA LBRACK RBRACK DOT
%token VAL FUN WALLET ASSET TRANSAC
%token IF THEN ELSE
%token BUY WITH THROUGH
%left EQUAL GREATER SMALLER GREATEREQUAL SMALLEREQUAL
%left PLUS MINUS
%left MULT DIV

%start main
%type <Mnyast.expr> main

%%

main: expr TWOSEMICOLONS {$1} | TWOSEMICOLONS main {$2}
;

expr:
     TRANSAC IDENT EQUAL BUY expr IDENT WITH IDENT THROUGH IDENT SEMICOLON expr { EBuy ($2, $5, $6, $8, $10, $12) } 
    | VAL IDENT EQUAL expr SEMICOLON expr { EAff ($2, $4, $6) }
    | ASSET IDENT EQUAL expr IDENT SEMICOLON expr { EAsset($2, $4, $5, $7) }
    | ASSET IDENT SEMICOLON expr { EAsset($2, EInt(1), "GEN", $4) }
    | WALLET IDENT EQUAL wallet SEMICOLON expr { EWallet ($2, $4, $6) }
    | IF expr THEN expr ELSE expr   { EIf($2, $4, $6) }
    // | FUN IDENT ARROW expr { EFun($2, $4) }
    | arith_expr   { $1 }
;

// seqident:
//   IDENT seqident  { $1 :: $2 }
// | /* rien */      { [] }
// ;

wallet:
    | LBRACK wallet_assets RBRACK    { $2 }
;

wallet_assets:
    IDENT COLON INT COMMA wallet_assets    { ($1,$3)::$5 }
    | IDENT COLON INT { ($1,$3)::[] }
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
    | application                   { $1 } 
;

application: 
    atom     { $1 }
;

atom: 
    INT       { EInt ($1) }
    | TRUE    { EBool (true) }
    | FALSE   { EBool (false) }
    | STRING  { EString ($1) }
    | IDENT   { EIdent ($1) }
    | LPAREN expr RPAREN   { $2 }
    | expr DOT IDENT  { EDot($1, $3) }
;
