type token =
  | INT of (int)
  | IDENT of (string)
  | TRUE
  | FALSE
  | STRING of (string)
  | PLUS
  | MINUS
  | MULT
  | DIV
  | EQUAL
  | GREATER
  | SMALLER
  | GREATEREQUAL
  | SMALLEREQUAL
  | LPAREN
  | RPAREN
  | SEMICOLON
  | TWOSEMICOLONS
  | ARROW
  | COLON
  | COMMA
  | LBRACK
  | RBRACK
  | DOT
  | VAL
  | FUN
  | WALLET
  | ASSET
  | TRANSAC
  | IF
  | THEN
  | ELSE
  | BUY
  | WITH
  | THROUGH

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Mnyast.expr
