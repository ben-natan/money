type expr = 
  | EFloat of float 
  | EBool of bool
  | EString of string
  | EAsset of expr * string
  (* | EExch of EAsset * EAsset  *)
  | EWallet of (string * expr) list
  | EIdent of string
  | EAff of string * expr * expr
  | EIf of expr * expr * expr
  | EBuy of expr * string * string * string
  | EBinop of string * expr * expr
  | EMonop of string * expr
  | EFun of string * expr
  | EFunrec of string * string * expr * expr
  | EDot of expr * string
  | EApp of expr * expr
;;


let rec print oc = function 
  | EFloat n -> Printf.fprintf oc "%f" n
  | EBool true -> Printf.fprintf oc "true"
  | EBool false -> Printf.fprintf oc "false"
  | EString s -> Printf.fprintf oc "\"%s\"" s
  | EAsset _ -> Printf.printf "asset"
  | EWallet _ -> Printf.printf "wallet"
  | EIdent s -> Printf.fprintf oc "%s" s 
  | EAff (x, e, expr) -> 
        Printf.fprintf oc "(%a = %a)" print (EIdent x) print e
  | EIf (test,e1,e2) -> 
      Printf.fprintf oc "(if %a then %a else %a)"  print test print e1 print e2
  | EBuy (amnt1, a1, wallet, a2) ->
      Printf.fprintf oc "(buy %a %a with %a through %a)" print (amnt1) print (EString a1) print (EString wallet) print (EString a2)
  | EBinop (op, e1, e2) -> 
      Printf.fprintf oc "(%a %s %a)" print e1 op print e2
  | EMonop (op, e) ->
      Printf.fprintf oc "(%a %s)" print e op 
  | EFun (f, e) -> 
      Printf.printf "Fonction"
  | EFunrec (f, p, e1, e2) ->
      Printf.printf "Fonction rec"
  | EDot (a, x) -> 
      Printf.printf "Dot"
  | EApp (e1, e2) ->
      Printf.printf "App"


  (* | _ -> Printf.printf "salut" *)

