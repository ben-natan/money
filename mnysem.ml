open Mnyast;;

type mnyval = 
  | Floatval of float
  | Boolval of bool
  | Stringval of string
  | Assetval of (string * float) list
  (* mettre une asset val GEN de sorte qu'elles soient toutes définies à partir de celle là *)
  | Walletval of (string * float) list
  | Transacval of {_success: bool; _from: string; _to: string; _amount: float; _price: float}
  (* | Transacval of (string * ) *)
  (* | Funval of { param: string; body: expr; env: environnement } *)

and environnement = (string * mnyval) list
;;

let rec print_wallet l = match l with
| (a,b)::q -> Printf.printf "%s:%f ; " a b; print_wallet q
| [] -> Printf.printf ""
;; 

let rec get_asset_val l x = match l with
| (a,v)::q -> if a = x then v else get_asset_val q x
| [] -> raise (Failure "Asset val not found")
;;


(* Ajoute la valeur v de new_a à a *)
let rec add_to_asset a new_a v rho = match rho with
| (t,h)::q -> if t = a then (
                match h with 
                | Floatval _ | Boolval _ | Stringval _ | Transacval _-> raise (Failure "is not asset")
                | Assetval r -> (t,Assetval((new_a,v)::r))::q
                | Walletval _ -> raise (Failure "wallet not yet implemented")
              ) else 
                 (t,h)::(add_to_asset a new_a v q)
| [] -> raise (Failure "asset not found")
;;

let rec find_and_add x e l = match l with
|(u,v)::q -> if u = x then (u,v+.e)::q else (u,v)::(find_and_add x e q)
|[] -> raise (Failure "Not found")
;;

let rec add_to_wallet w x v rho = match rho with
| (t,h)::q -> if t = w then (
              match h with
              | Floatval _ | Boolval _ | Stringval _ | Assetval _ | Transacval _-> raise (Failure "is not wallet")
              | Walletval r -> let new_wallet = find_and_add x v r in
                  (t, Walletval(new_wallet))::q
              ) else 
                (t,h)::(add_to_wallet w x v q)

| [] -> raise (Failure "wallet not found")
;;


let rec printval = function 
  | Floatval n -> Printf.printf "%f" n 
  | Boolval b -> Printf.printf "%s" (if b then "true" else "false")
  | Stringval s -> Printf.printf "\"%s\"" s
  | Walletval w -> print_wallet w
  | Assetval a -> print_wallet a
  | Transacval t -> Printf.printf "{success: %b, from: %s, to: %s, price: %f, amount: %f}" t._success t._from t._to t._price t._amount
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
  | EFloat n -> Floatval n
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
      | Floatval n ->
          let new_rho = extend rho x (Assetval [(a,n)]) in 
          if a = "GEN" then
            eval next new_rho
          else
            (* On ajoute la correspondance à l'autre asset aussi *)
            (
              match lookup a new_rho with
              | Assetval _ -> 
                let final_rho = add_to_asset a x (1./.n) (* à remplacer par 1/v *) new_rho in
                eval next final_rho

              | _ -> raise (Failure ".. is not an asset")
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
      | Floatval n -> raise (Failure "Can't access type int property")
      | Boolval b -> raise (Failure "Can't access type bool property")
      | Stringval s -> raise (Failure "Can't access type string property")
      | Assetval l -> (
          let value = get_asset_val l x in Floatval(value)
        )
      | Walletval l -> (
          let value = get_asset_val l x in Floatval(value)
        )
      | Transacval t -> raise (Failure "not yet implemented transac")
    )
  )

  | EBuy (t, amnt_a1 ,a1, w, a2, next) -> (
    (* On cherche wallet, et on crée la transacval
       puis on redonne la main *)
    match eval amnt_a1 rho with
      | Floatval amnt_a1_end -> (
          match lookup w rho with 
          | Walletval wallet ->
              (
              match lookup a2 rho with 
                | Assetval asset2 -> (
                    let amnt_a2 = get_asset_val wallet a2 in
                    let val_a2 = get_asset_val asset2 a1 in
                    if (amnt_a2 *. val_a2 >= amnt_a1_end) then
                      (* Transaction réussie *)
                      let new_rho = add_to_wallet w a1 amnt_a1_end rho in
                      let almost_done_rho = add_to_wallet w a2 (-1. *. amnt_a1_end /. val_a2) new_rho in
                      let final_rho = extend almost_done_rho t (Transacval {_success= true; _from= a2; _to= a1; _amount= amnt_a1_end; _price= amnt_a2}) in
                      eval next final_rho
                    else
                      (* Transaction pas réussie *)
                      let final_rho = extend rho t (Transacval {_success= false; _from= a2; _to= a1; _amount= amnt_a1_end; _price= amnt_a2}) in
                      eval next final_rho
                    )
                | _ -> raise (Failure "Asset 2 non reconnu")
              )
          | _ -> raise (Failure "Wallet non reconnu") 
        )
      | _ -> raise (Failure "Amount not int")
    )
  | EBinop (op, e1, e2) -> (
      match (eval e1 rho, eval e2 rho) with
      | (Floatval n1, Floatval n2) -> (
          match op with 
          | "+" -> Floatval (n1 +. n2)
          | "-" -> Floatval (n1 -. n2)
          | "*" -> Floatval (n1 *. n2)
          | "/" -> Floatval (n1 /. n2)
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
  | EFun (f, e) -> raise (Failure "not yet implemented: fun")
  
;;



let eval e = eval e init_env ;;