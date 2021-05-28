type token =
  | FLOAT of (float)
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
  | SET
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
  | OF
  | REC
  | NOTEQUAL
  | EXCLAM
  | XOR
  | OR
  | AND
  | PERCENT

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Mnyast.expr
