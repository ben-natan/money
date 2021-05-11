type expr = 
  | EInt of int 
  | EBool of bool
  | EString of string
  | EAsset of string * expr * string * expr
  (* | EExch of EAsset * EAsset  *)
  | EWallet of string * ((string * int) list) * expr
  | EIdent of string
  | EAff of string * expr * expr
  | EIf of (expr * expr * expr)
  | EBuy of string * expr * string * string * string * expr
  | EBinop of (string * expr * expr)
  | EFun of (string * expr)
  | EDot of (expr * string)
;;


let rec print oc = function 
  | EInt n -> Printf.fprintf oc "%d" n
  | EBool true -> Printf.fprintf oc "true"
  | EBool false -> Printf.fprintf oc "false"
  | EString s -> Printf.fprintf oc "\"%s\"" s
  | EAsset _ -> Printf.printf "asset"
  | EWallet (s,l,n) -> Printf.printf "wallet"
  | EIdent s -> Printf.fprintf oc "%s" s 
  | EAff (x, e, expr) -> 
        Printf.fprintf oc "(%a = %a)" print (EIdent x) print e
  | EIf (test,e1,e2) -> 
      Printf.fprintf oc "(if %a then %a else %a)"  print test print e1 print e2
  | EBuy (t, amnt1, a1, wallet, a2, next) ->
      Printf.fprintf oc "(buy %a %a with %a through %a)" print (amnt1) print (EString a1) print (EString wallet) print (EString a2)
  | EBinop (op, e1, e2) -> 
      Printf.fprintf oc "(%a %s %a)" print e1 op print e2
  | EFun (f, e) -> 
      Printf.printf "Fonction"
  | EDot (a, x) -> 
      Printf.printf "Dot"
  (* | _ -> Printf.printf "salut" *)

