open Mnyast;;

type mnyval = 
  | Floatval of float
  | Boolval of bool
  | Stringval of string
  | Assetval of (float * string) list
  (* mettre une asset val GEN de sorte qu'elles soient toutes définies à partir de celle là *)
  | Walletval of (string * float) list
  | Transacval of {_success: bool; _from: string; _to: string; _amount: float; _price: float; _wallet: string}
  | Funval of { param: string; body: expr; env: environnement }
  | Funrecval of { fname: string; param: string; body: expr; env: environnement}

and environnement = (string * mnyval) list
;;

let print_wallet l = 
  let rec aux l = match l with
  | [(a,b)] -> Printf.printf "%s: %f }" a b
  | (a,b)::q -> Printf.printf "%s: %f, " a b; aux q
in Printf.printf "{ "; aux l;
;; 

let rec print_asset a = match a with
| t::q -> Printf.printf "%f of %s, " (fst t) (snd t)
| [] -> Printf.printf ". \n"

let print_asset a = 
  let rec aux a = match a with
  | [(a,b)] -> Printf.printf "%f of %s ]" a b
  | (a,b)::q -> Printf.printf "%f of %s, " a b; aux q
in Printf.printf "[ "; aux a;
;;


let rec get_wallet_val l x = match l with
| (nom,valeur)::q -> if x = nom then valeur else get_wallet_val q x
| [] -> raise (Failure "Asset not found")
;;

let rec get_asset_val l x = match l with
| (valeur,nom)::q -> if x = nom then valeur else get_asset_val q x
| [] -> raise (Failure "No trade defined between assets")
;;


(* Ajoute la valeur v de new_a à a *)
let rec add_to_asset a new_a v rho = match rho with
| (t,h)::q -> if t = a then (
                match h with 
                | Floatval _ | Boolval _ | Stringval _ | Transacval _ | Walletval _| Funval _ | Funrecval _ -> raise (Failure "Not an asset")
                | Assetval r -> (t,Assetval((v,new_a)::r))::q
              ) else 
                 (t,h)::(add_to_asset a new_a v q)
| [] -> raise (Failure "asset not found")
;;



let rec find_and_add x e l = match l with
|(u,v)::q -> if u = x then (u,v+.e)::q else (u,v)::(find_and_add x e q)
|[] -> [(x, e)]
;;

let rec add_to_wallet w x v rho = match rho with
| (t,h)::q -> if t = w then (
              match h with
              | Floatval _ | Boolval _ | Stringval _ | Assetval _ | Transacval _ | Funval _ | Funrecval _  -> raise (Failure "Not a wallet")
              | Walletval r -> let new_wallet = find_and_add x v r in
                  (t, Walletval(new_wallet))::q
              ) else 
                (t,h)::(add_to_wallet w x v q)

| [] -> raise (Failure "Wallet not found")
;;


let rec add_val_to_wallet vnom vval w = match w with
| (hnom, hval)::q -> if hnom = vnom then (hnom, hval +. vval)::q
                     else (hnom, hval)::(add_val_to_wallet vnom vval q)
| [] -> [(vnom, vval)]

let rec add_wallets w1 w2 = match w1 with
| [] -> w2
| (vnom, vval)::q -> let new_w2 = add_val_to_wallet vnom vval w2 in add_wallets q new_w2

let rec sub_val_to_wallet vnom vval w = match w with
| (hnom, hval)::q -> if hnom = vnom then (hnom, vval -. hval)::q
                     else (hnom, hval)::(sub_val_to_wallet vnom vval q)
| [] -> [(vnom, vval)]

let rec sub_wallets w1 w2 = match w1 with
| [] -> w2
| (vnom, vval)::q -> let new_w2 = sub_val_to_wallet vnom vval w2 in sub_wallets q new_w2



let rec k_mult_wallet f w = match w with
| [] -> []
| (vnom, vval)::q -> (vnom, f*.vval)::(k_mult_wallet f q)



let rec printval = function 
  | Floatval n -> Printf.printf "%f" n 
  | Boolval b -> Printf.printf "%s" (if b then "true" else "false")
  | Stringval s -> Printf.printf "\"%s\"" s
  | Walletval w -> print_wallet w
  | Assetval a -> print_asset a
  | Transacval t -> Printf.printf "{ success: %b, from: %s, to: %s, price: %f, amount: %f, wallet: %s }" t._success t._from t._to t._price t._amount t._wallet
  | Funval _ -> Printf.printf "<fun>"
  | Funrecval _ -> Printf.printf "<fun rec>"
;;

let init_env = [("GEN", Assetval([]))] ;;

let error msg = raise (Failure msg) ;;

let extend rho x v = match v with
| Assetval [t] -> let price = fst t in let asset = snd t in
                    let updated_rho = add_to_asset asset x (1./.price) rho in (x,v)::updated_rho
| Transacval {_success; _from; _to; _amount; _price; _wallet} ->
                  if _success then 
                    let inter_rho = add_to_wallet _wallet _to _amount rho in
                    let final_rho = add_to_wallet _wallet _from (-._price) inter_rho in
                    (x,v)::final_rho
                  else (x,v)::rho
| _ -> (x,v)::rho
;;

let lookup x rho = 
  try List.assoc x rho
  with Not_found -> error (Printf.sprintf "Undefined indent '%s'" x)
;;


let applyToAll l f rho = 
    let rec aux l rho acc = match l with
    | [] -> acc
    | t::q -> let nom = fst t in
             let valeur = snd t in 
             let valeur_end = f valeur rho in
             match valeur_end with
             | Floatval n -> aux q rho [(nom, n)]@acc
             | _ -> raise (Failure "Value must be float")
             
    in aux l rho []
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

  | EAsset (e, i) -> (
    match eval e rho with
      | Floatval n -> Assetval [(n, i)]
      | _ -> raise (Failure "Value must be float")
    )

  | EWallet w -> Walletval (applyToAll w eval rho)
    
  | EIf (test, e1, e2) -> (
    match eval test rho with
      | Boolval b -> eval (if b then e1 else e2) rho 
      | _ -> raise (Failure "Testing a non boolean condition")
    )

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
          let value = get_wallet_val l x in Floatval(value)
        )
      | Transacval {_success; _from; _to; _amount; _price; _wallet} -> (
        match x with
        | "success" -> Boolval _success
        | "from" -> Stringval _from
        | "to" -> Stringval _to
        | "amount" -> Floatval _amount
        | "price" -> Floatval _price
        | "wallet" -> Stringval _wallet
        | _ -> raise (Failure (Printf.sprintf "Can't access %s field of transaction" x))
      )
      | Funval _ | Funrecval _ -> raise (Failure "Can't access type fun property")
    )
  )

  | EBuy (b_amnt, buy_asst, wallet, thr_asst) -> (
    match eval b_amnt rho with
    | Floatval buy_amount -> 
      (* Ici on forme la transaction avec un lookup pour voir si assez d'argent *)
      let Walletval(_wallet) = lookup wallet rho in
      let Assetval(_buy_asst) = lookup buy_asst rho in
      let _wallet_amnt = get_wallet_val _wallet thr_asst in
      let _wallet_value = get_asset_val _buy_asst thr_asst in
      Transacval { _success = if _wallet_amnt /. _wallet_value >= buy_amount then true else false;
                   _from = thr_asst; _to = buy_asst; _amount = buy_amount; _price = buy_amount *. _wallet_value;
                   _wallet = wallet }
      (* Dans le extend on fait les modifs sur le wallet *)
    | _ -> raise (Failure "Buying amount must be float")

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
          | "!=" -> Boolval (n1<>n2)
          | "<" -> Boolval (n1 < n2)
          | "<=" -> Boolval (n1 <= n2) 
          | ">" -> Boolval (n1 > n2)
          | ">=" -> Boolval (n1 >= n2)
          | _ -> raise ( Failure (Printf.sprintf "Opérateur sur entier non reconnu: %s" op))
      )
      | (Boolval b1, Boolval b2) -> (
          match op with
          | "=" -> Boolval (b1=b2)
          | "!=" -> Boolval (b1<>b2)
          | "||" -> Boolval (b1 || b2)
          | "^" -> Boolval (b1<>b2)
          | "&&" -> Boolval (b1&&b2)
          | _ -> raise ( Failure (Printf.sprintf "Opérateur sur booléen non reconnu: %s" op))
      )
      | (Stringval s1, Stringval s2) -> (
          match op with
          | "=" -> Boolval (s1 = s2)
          | "+" -> Stringval (s1 ^ s2)
          | _ -> raise (Failure (Printf.sprintf "Opérateur sur string non reconnu: %s" op))
      )
      | (Walletval w1, Walletval w2) -> (
          match op with
          | "+" -> Walletval (add_wallets w1 w2)
          | "-" -> Walletval (sub_wallets w1 w2)
          | _ -> raise (Failure (Printf.sprintf "Opérateur sur wallet non reconnu: %s" op))
      )
      | (Walletval w, Floatval f) -> (
          match op with 
          | "*" -> Walletval ( k_mult_wallet f w)
          | "/" -> Walletval ( k_mult_wallet (1./.f) w)
          | _ -> raise (Failure (Printf.sprintf "Opérateur entre wallet et float non reconnu: %s" op))
      )
      | (Floatval f, Walletval w) -> (
          match op with
          | "*" -> Walletval ( k_mult_wallet f w)
          | "/" -> Walletval ( k_mult_wallet (1./.f) w)
          | _ -> raise (Failure (Printf.sprintf "Opérateur entre wallet et float non reconnu: %s" op))
      )
      | _ -> raise (Failure (Printf.sprintf "Opérandes invalides pour l'opérateur %s" op))
  )
  | EMonop (op, e) -> (
    match eval e rho with
    | Floatval f -> (
      match op with
      | "+" -> Floatval f
      | "-" -> Floatval (-.f)
      | "%" -> Floatval (f/.100.)
      | _ -> raise (Failure (Printf.sprintf "Opérande invalide pour l'opérateur %s" op))
    )
    | Boolval b -> (
      match op with
      | "!" -> if b then Boolval false else Boolval true
      | _ -> raise (Failure (Printf.sprintf "Opérande invalide pour l'opérateur %s" op))
    )
    | Stringval s -> (
      match op with
      | _ -> raise (Failure (Printf.sprintf "Opérande invalide pour l'opérateur %s" op))
    )
    | Walletval w -> (
      match op with
      | "+" -> Walletval w
      | "-" -> Walletval ( k_mult_wallet (-.1.) w)
      | _ -> raise (Failure (Printf.sprintf "Opérande invalide pour l'opérateur %s" op))
    )
    | Assetval a -> (
      match op with
      | _ -> raise (Failure (Printf.sprintf "Opérande invalide pour l'opérateur %s" op))
    )
    | _ -> raise (Failure (Printf.sprintf "Opérande invalide pour l'opérateur %s" op))
  )
  | EFun (p, e) -> Funval {param = p; body = e; env = rho}
  | EFunrec (f, x, e1, e2) -> 
      let fval = Funrecval {fname = f; param = x; body = e; env = rho} in 
      let new_rho = extend rho f fval in
      eval e2 new_rho
  | EApp (e1, e2) -> ( 
        match (eval e1 rho, eval e2 rho) with
        | (Funval {param; body; env}, v2) -> 
            let rho1 = extend env param v2 in 
            eval body rho1
        | (Funrecval {fname; param; body; env} as fval, v2) ->
            let rho1 = extend env fname fval in
            let rho2 = extend rho1 param v2 in 
            eval body rho2
        | _ -> raise (Failure "pas une fonction")
  )
  

  
  
;;



let eval e = eval e init_env ;;