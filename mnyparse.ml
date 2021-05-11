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

open Parsing;;
let _ = parse_error;;
# 2 "mnyparse.mly"
open Mnyast ;;
# 43 "mnyparse.ml"
let yytransl_const = [|
  259 (* TRUE *);
  260 (* FALSE *);
  262 (* PLUS *);
  263 (* MINUS *);
  264 (* MULT *);
  265 (* DIV *);
  266 (* EQUAL *);
  267 (* GREATER *);
  268 (* SMALLER *);
  269 (* GREATEREQUAL *);
  270 (* SMALLEREQUAL *);
  271 (* LPAREN *);
  272 (* RPAREN *);
  273 (* SEMICOLON *);
  274 (* TWOSEMICOLONS *);
  275 (* ARROW *);
  276 (* COLON *);
  277 (* COMMA *);
  278 (* LBRACK *);
  279 (* RBRACK *);
  280 (* DOT *);
  281 (* VAL *);
  282 (* FUN *);
  283 (* WALLET *);
  284 (* ASSET *);
  285 (* TRANSAC *);
  286 (* IF *);
  287 (* THEN *);
  288 (* ELSE *);
  289 (* BUY *);
  290 (* WITH *);
  291 (* THROUGH *);
    0|]

let yytransl_block = [|
  257 (* INT *);
  258 (* IDENT *);
  261 (* STRING *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\002\000\002\000\002\000\002\000\002\000\002\000\
\002\000\003\000\005\000\005\000\004\000\004\000\004\000\004\000\
\004\000\004\000\004\000\004\000\004\000\004\000\006\000\007\000\
\007\000\007\000\007\000\007\000\007\000\007\000\000\000"

let yylen = "\002\000\
\002\000\002\000\012\000\006\000\007\000\004\000\006\000\006\000\
\001\000\003\000\005\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\003\000\003\000\003\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\003\000\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\024\000\028\000\025\000\026\000\027\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\031\000\000\000\
\000\000\022\000\023\000\000\000\002\000\000\000\000\000\000\000\
\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\029\000\000\000\000\000\
\000\000\000\000\000\000\000\000\030\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\010\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\011\000\000\000\000\000\000\000\000\000"

let yydgoto = "\002\000\
\015\000\046\000\058\000\017\000\065\000\018\000\019\000"

let yysindex = "\001\000\
\026\000\000\000\000\000\000\000\000\000\000\000\000\000\044\000\
\026\000\002\255\012\255\014\255\032\255\044\000\000\000\015\255\
\054\000\000\000\000\000\241\254\000\000\025\255\026\255\251\254\
\045\255\035\255\000\000\059\255\044\000\044\000\044\000\044\000\
\044\000\044\000\044\000\044\000\044\000\000\000\044\000\047\255\
\044\000\044\000\034\255\044\000\000\000\050\255\009\255\009\255\
\000\000\000\000\088\255\088\255\088\255\088\255\088\255\046\255\
\073\255\061\255\004\255\050\255\044\000\235\254\044\000\056\255\
\057\255\044\000\062\255\008\255\044\000\050\255\082\255\000\000\
\050\255\044\000\064\255\050\255\069\255\050\255\099\255\073\255\
\067\255\000\000\101\255\096\255\044\000\050\255"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\216\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\075\255\098\255\
\013\255\040\255\121\255\144\255\167\255\190\255\213\255\000\000\
\000\000\000\000\000\000\233\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\236\255\000\000\000\000\
\239\255\000\000\000\000\244\255\094\255\005\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\008\000"

let yygindex = "\000\000\
\109\000\255\255\000\000\046\001\039\000\000\000\000\000"

let yytablesize = 339
let yytable = "\016\000\
\038\000\001\000\028\000\022\000\041\000\067\000\020\000\016\000\
\028\000\075\000\069\000\042\000\026\000\023\000\020\000\024\000\
\031\000\032\000\020\000\020\000\020\000\020\000\020\000\020\000\
\020\000\020\000\020\000\028\000\020\000\020\000\020\000\028\000\
\027\000\025\000\039\000\040\000\009\000\056\000\028\000\059\000\
\060\000\021\000\062\000\020\000\020\000\021\000\021\000\021\000\
\021\000\021\000\021\000\021\000\021\000\021\000\043\000\021\000\
\021\000\021\000\028\000\068\000\045\000\070\000\063\000\009\000\
\073\000\044\000\061\000\076\000\057\000\028\000\021\000\021\000\
\078\000\028\000\064\000\071\000\018\000\066\000\074\000\072\000\
\018\000\018\000\077\000\086\000\018\000\018\000\018\000\018\000\
\018\000\080\000\018\000\018\000\018\000\029\000\030\000\031\000\
\032\000\079\000\009\000\019\000\081\000\083\000\084\000\019\000\
\019\000\018\000\018\000\019\000\019\000\019\000\019\000\019\000\
\085\000\019\000\019\000\019\000\012\000\021\000\082\000\000\000\
\000\000\009\000\013\000\000\000\000\000\000\000\000\000\000\000\
\019\000\019\000\013\000\013\000\013\000\013\000\013\000\000\000\
\013\000\013\000\013\000\000\000\000\000\000\000\000\000\000\000\
\009\000\014\000\000\000\000\000\000\000\000\000\000\000\013\000\
\013\000\014\000\014\000\014\000\014\000\014\000\000\000\014\000\
\014\000\014\000\000\000\000\000\000\000\000\000\000\000\009\000\
\016\000\000\000\000\000\000\000\000\000\000\000\014\000\014\000\
\016\000\016\000\016\000\016\000\016\000\000\000\016\000\016\000\
\016\000\000\000\000\000\000\000\000\000\000\000\009\000\015\000\
\000\000\000\000\000\000\000\000\000\000\016\000\016\000\015\000\
\015\000\015\000\015\000\015\000\000\000\015\000\015\000\015\000\
\000\000\000\000\000\000\000\000\000\000\009\000\017\000\000\000\
\000\000\009\000\000\000\000\000\015\000\015\000\017\000\017\000\
\017\000\017\000\017\000\000\000\017\000\017\000\017\000\009\000\
\009\000\009\000\006\000\000\000\009\000\004\000\000\000\009\000\
\007\000\000\000\000\000\017\000\017\000\008\000\009\000\009\000\
\006\000\006\000\006\000\004\000\004\000\004\000\007\000\007\000\
\007\000\000\000\000\000\008\000\008\000\008\000\005\000\006\000\
\006\000\003\000\004\000\004\000\000\000\007\000\007\000\000\000\
\000\000\000\000\008\000\008\000\005\000\005\000\005\000\003\000\
\003\000\003\000\003\000\004\000\005\000\006\000\007\000\000\000\
\000\000\000\000\000\000\005\000\005\000\000\000\003\000\003\000\
\008\000\000\000\000\000\009\000\003\000\004\000\005\000\006\000\
\007\000\000\000\010\000\000\000\011\000\012\000\013\000\014\000\
\000\000\000\000\008\000\029\000\030\000\031\000\032\000\033\000\
\034\000\035\000\036\000\037\000\010\000\000\000\011\000\012\000\
\013\000\014\000\047\000\048\000\049\000\050\000\051\000\052\000\
\053\000\054\000\055\000"

let yycheck = "\001\000\
\016\001\001\000\024\001\002\001\010\001\002\001\008\000\009\000\
\024\001\002\001\032\001\017\001\014\000\002\001\002\001\002\001\
\008\001\009\001\006\001\007\001\008\001\009\001\010\001\011\001\
\012\001\013\001\014\001\024\001\016\001\017\001\018\001\024\001\
\018\001\002\001\010\001\010\001\024\001\039\000\024\001\041\000\
\042\000\002\001\044\000\031\001\032\001\006\001\007\001\008\001\
\009\001\010\001\011\001\012\001\013\001\014\001\010\001\016\001\
\017\001\018\001\024\001\061\000\002\001\063\000\017\001\024\001\
\066\000\031\001\033\001\069\000\022\001\024\001\031\001\032\001\
\074\000\024\001\002\001\020\001\002\001\017\001\017\001\023\001\
\006\001\007\001\001\001\085\000\010\001\011\001\012\001\013\001\
\014\001\021\001\016\001\017\001\018\001\006\001\007\001\008\001\
\009\001\034\001\024\001\002\001\002\001\035\001\002\001\006\001\
\007\001\031\001\032\001\010\001\011\001\012\001\013\001\014\001\
\017\001\016\001\017\001\018\001\023\001\009\000\080\000\255\255\
\255\255\024\001\002\001\255\255\255\255\255\255\255\255\255\255\
\031\001\032\001\010\001\011\001\012\001\013\001\014\001\255\255\
\016\001\017\001\018\001\255\255\255\255\255\255\255\255\255\255\
\024\001\002\001\255\255\255\255\255\255\255\255\255\255\031\001\
\032\001\010\001\011\001\012\001\013\001\014\001\255\255\016\001\
\017\001\018\001\255\255\255\255\255\255\255\255\255\255\024\001\
\002\001\255\255\255\255\255\255\255\255\255\255\031\001\032\001\
\010\001\011\001\012\001\013\001\014\001\255\255\016\001\017\001\
\018\001\255\255\255\255\255\255\255\255\255\255\024\001\002\001\
\255\255\255\255\255\255\255\255\255\255\031\001\032\001\010\001\
\011\001\012\001\013\001\014\001\255\255\016\001\017\001\018\001\
\255\255\255\255\255\255\255\255\255\255\024\001\002\001\255\255\
\255\255\002\001\255\255\255\255\031\001\032\001\010\001\011\001\
\012\001\013\001\014\001\255\255\016\001\017\001\018\001\016\001\
\017\001\018\001\002\001\255\255\024\001\002\001\255\255\024\001\
\002\001\255\255\255\255\031\001\032\001\002\001\031\001\032\001\
\016\001\017\001\018\001\016\001\017\001\018\001\016\001\017\001\
\018\001\255\255\255\255\016\001\017\001\018\001\002\001\031\001\
\032\001\002\001\031\001\032\001\255\255\031\001\032\001\255\255\
\255\255\255\255\031\001\032\001\016\001\017\001\018\001\016\001\
\017\001\018\001\001\001\002\001\003\001\004\001\005\001\255\255\
\255\255\255\255\255\255\031\001\032\001\255\255\031\001\032\001\
\015\001\255\255\255\255\018\001\001\001\002\001\003\001\004\001\
\005\001\255\255\025\001\255\255\027\001\028\001\029\001\030\001\
\255\255\255\255\015\001\006\001\007\001\008\001\009\001\010\001\
\011\001\012\001\013\001\014\001\025\001\255\255\027\001\028\001\
\029\001\030\001\029\000\030\000\031\000\032\000\033\000\034\000\
\035\000\036\000\037\000"

let yynames_const = "\
  TRUE\000\
  FALSE\000\
  PLUS\000\
  MINUS\000\
  MULT\000\
  DIV\000\
  EQUAL\000\
  GREATER\000\
  SMALLER\000\
  GREATEREQUAL\000\
  SMALLEREQUAL\000\
  LPAREN\000\
  RPAREN\000\
  SEMICOLON\000\
  TWOSEMICOLONS\000\
  ARROW\000\
  COLON\000\
  COMMA\000\
  LBRACK\000\
  RBRACK\000\
  DOT\000\
  VAL\000\
  FUN\000\
  WALLET\000\
  ASSET\000\
  TRANSAC\000\
  IF\000\
  THEN\000\
  ELSE\000\
  BUY\000\
  WITH\000\
  THROUGH\000\
  "

let yynames_block = "\
  INT\000\
  IDENT\000\
  STRING\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 23 "mnyparse.mly"
                         (_1)
# 281 "mnyparse.ml"
               : Mnyast.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Mnyast.expr) in
    Obj.repr(
# 23 "mnyparse.mly"
                                                   (_2)
# 288 "mnyparse.ml"
               : Mnyast.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 10 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 7 : 'expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 6 : string) in
    let _8 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _10 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _12 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 27 "mnyparse.mly"
                                                                                ( EBuy (_2, _5, _6, _8, _10, _12) )
# 300 "mnyparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 28 "mnyparse.mly"
                                          ( EAff (_2, _4, _6) )
# 309 "mnyparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 29 "mnyparse.mly"
                                                  ( EAsset(_2, _4, _5, _7) )
# 319 "mnyparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 30 "mnyparse.mly"
                                 ( EAsset(_2, EInt(1), "GEN", _4) )
# 327 "mnyparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'wallet) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 31 "mnyparse.mly"
                                               ( EWallet (_2, _4, _6) )
# 336 "mnyparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 32 "mnyparse.mly"
                                    ( EIf(_2, _4, _6) )
# 345 "mnyparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 34 "mnyparse.mly"
                   ( _1 )
# 352 "mnyparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'wallet_assets) in
    Obj.repr(
# 43 "mnyparse.mly"
                                     ( _2 )
# 359 "mnyparse.ml"
               : 'wallet))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : int) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'wallet_assets) in
    Obj.repr(
# 47 "mnyparse.mly"
                                           ( (_1,_3)::_5 )
# 368 "mnyparse.ml"
               : 'wallet_assets))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 48 "mnyparse.mly"
                      ( (_1,_3)::[] )
# 376 "mnyparse.ml"
               : 'wallet_assets))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 54 "mnyparse.mly"
                                   ( EBinop ("=", _1, _3) )
# 384 "mnyparse.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 55 "mnyparse.mly"
                                       ( EBinop (">", _1, _3) )
# 392 "mnyparse.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 56 "mnyparse.mly"
                                            ( EBinop (">=", _1, _3) )
# 400 "mnyparse.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 57 "mnyparse.mly"
                                       ( EBinop ("<", _1, _3) )
# 408 "mnyparse.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 58 "mnyparse.mly"
                                            ( EBinop ("<=", _1, _3) )
# 416 "mnyparse.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 59 "mnyparse.mly"
                                    ( EBinop ("+", _1, _3) )
# 424 "mnyparse.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 60 "mnyparse.mly"
                                     ( EBinop ("-", _1, _3) )
# 432 "mnyparse.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 61 "mnyparse.mly"
                                    ( EBinop ("*", _1, _3) )
# 440 "mnyparse.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'arith_expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'arith_expr) in
    Obj.repr(
# 62 "mnyparse.mly"
                                   ( EBinop ("/", _1, _3) )
# 448 "mnyparse.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'application) in
    Obj.repr(
# 63 "mnyparse.mly"
                                    ( _1 )
# 455 "mnyparse.ml"
               : 'arith_expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atom) in
    Obj.repr(
# 67 "mnyparse.mly"
             ( _1 )
# 462 "mnyparse.ml"
               : 'application))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 71 "mnyparse.mly"
              ( EInt (_1) )
# 469 "mnyparse.ml"
               : 'atom))
; (fun __caml_parser_env ->
    Obj.repr(
# 72 "mnyparse.mly"
              ( EBool (true) )
# 475 "mnyparse.ml"
               : 'atom))
; (fun __caml_parser_env ->
    Obj.repr(
# 73 "mnyparse.mly"
              ( EBool (false) )
# 481 "mnyparse.ml"
               : 'atom))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 74 "mnyparse.mly"
              ( EString (_1) )
# 488 "mnyparse.ml"
               : 'atom))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 75 "mnyparse.mly"
              ( EIdent (_1) )
# 495 "mnyparse.ml"
               : 'atom))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 76 "mnyparse.mly"
                           ( _2 )
# 502 "mnyparse.ml"
               : 'atom))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 77 "mnyparse.mly"
                      ( EDot(_1, _3) )
# 510 "mnyparse.ml"
               : 'atom))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Mnyast.expr)
