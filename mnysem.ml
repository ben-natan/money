open Mnyast;;

type mnyval = 
  | Intval of int
  | Boolval of bool
  | Stringval of string
  | Assetval of (string * int) list
  (* mettre une asset val GEN de sorte qu'elles soient toutes définies à partir de celle là *)
  | Walletval of (string * int) list
  (* | Funval of { param: string; body: expr; env: environnement } *)

and environnement = (string * mnyval) list
;;

let rec print_wallet l = match l with
| (a,b)::q -> Printf.printf "%s:%d" a b; print_wallet q
| [] -> Printf.printf ""
;; 

let rec get_asset_val l x = match l with
| (a,v)::q -> if a = x then v else get_asset_val q x
| [] -> raise (Failure "Asset val not found")
;;

let rec printval = function 
  | Intval n -> Printf.printf "%d" n 
  | Boolval b -> Printf.printf "%s" (if b then "true" else "false")
  | Stringval s -> Printf.printf "\"%s\"" s
  | Walletval w -> print_wallet w
  | Assetval a -> print_wallet a
  (* | Funval _ -> Printf.printf "<fun>" *)
;;

let init_env = [] ;;

let error msg = raise (Failure msg) ;;

let extend rho x v = (x,v)::rho ;;

let lookup x rho = 
  try List.assoc x rho
  with Not_found -> error (Printf.sprintf "Undefined indent '%s'" x)
;;


let rec eval e rho = match e with
  | EInt n -> Intval n
  | EBool b -> Boolval b 
  | EString s -> Stringval s
  | EIdent x -> lookup x rho
  | EAff (x,v, next) -> 
    let v_end = eval v rho in 
    let new_rho = extend rho x v_end in 
    eval next new_rho
  | EAsset (x, v, a, next) ->
    let v_end = eval v rho in (
      match v_end with
      | Intval n ->
          if a = "GEN" then
            let new_rho = extend rho x (Assetval [(a,n)]) in 
            eval next new_rho
          
          else 
            (
              match lookup a rho with
              | Assetval asset -> let a_value = get_asset_val asset "GEN" in
                            (
                              match v with
                              | EInt n -> let new_rho = extend rho x (Assetval [("GEN",a_value * n);(a,n)]) in 
                                            eval next new_rho
                              | _ -> raise (Failure "asset value is not int")
                            )
                            
              | _ -> raise (Failure "is not an asset")
            )
            

      | _ -> raise (Failure "Asset value must be int")
    )
  | EIf (test, e1, e2) -> (
    match eval test rho with
      | Boolval b -> eval (if b then e1 else e2) rho 
      | _ -> raise (Failure "Testing a non boolean condition")
    )

  | EWallet (w, l, next) -> 
    let new_rho = extend rho w (Walletval(l)) in 
    eval next new_rho

  | EDot (a, x) -> (
    let a_end = eval a rho in
    (
      match a_end with
      | Intval n -> raise (Failure "Can't access type int property")
      | Boolval b -> raise (Failure "Can't access type bool property")
      | Stringval s -> raise (Failure "Can't access type string property")
      | Assetval l -> (
          let value = get_asset_val l x in Intval(value)
        )
      | Walletval l -> (
          let value = get_asset_val l x in Intval(value)
        )
    )
  )

  | EBuy (a1, wallet, a2) -> 
    raise (Failure "Pas encore implémenté: BUY")

  | EBinop (op, e1, e2) -> (
      match (eval e1 rho, eval e2 rho) with
      | (Intval n1, Intval n2) -> (
          match op with 
          | "+" -> Intval (n1 + n2)
          | "-" -> Intval (n1 - n2)
          | "*" -> Intval (n1 * n2)
          | "/" -> Intval (n1 / n2)
          | "=" -> Boolval (n1 = n2)
          | "<" -> Boolval (n1 < n2)
          | "<=" -> Boolval (n1 <= n2) 
          | ">" -> Boolval (n1 > n2)
          | ">=" -> Boolval (n1 >= n2)
          | _ -> raise ( Failure (Printf.sprintf "Opérateur sur entier non reconnu: %s" op))
      )
      | (Boolval b1, Boolval b2) -> (
          match op with
          | "=" -> Boolval (b1=b2)
          | _ -> raise ( Failure (Printf.sprintf "Opérateur sur booléen non reconnu: %s" op))
      )
      | (Stringval s1, Stringval s2) -> (
          match op with
          | "=" -> Boolval (s1 = s2)
          | "+" -> Stringval (s1 ^ s2)
          | _ -> raise (Failure (Printf.sprintf "Opérateur sur string non reconnu= %s" op))
      )
      | _ -> raise (Failure (Printf.sprintf "Opérandes invalides pour l'opérateur %s" op))
  )
  (* | EFun (f, e) -> Funval { param = f; body = e; env = rho} *)
  
;;



let eval e = eval e init_env ;;