open Mnyast;;

type mnyval = 
  | Floatval of float
  | Boolval of bool
  | Stringval of string
  | Assetval of (float * string) list
  (* mettre une asset val GEN de sorte qu'elles soient toutes définies à partir de celle là *)
  | Walletval of (string * float) list
  | Transacval of {_success: bool; _from: string; _to: string; _amount: float; _price: float; _wallet: string}
  (* | Transacval of (string * ) *)
  | Funval of { param: string; body: expr; env: environnement }

and environnement = (string * mnyval) list
;;

let rec print_wallet l = match l with
| (a,b)::q -> Printf.printf "%s:%f ; " a b; print_wallet q
| [] -> Printf.printf ""
;; 

let rec get_wallet_val l x = match l with
| (nom,valeur)::q -> if x = nom then valeur else get_wallet_val q x
| [] -> raise (Failure "Asset val not found")
;;

let rec get_asset_val l x = match l with
| (valeur,nom)::q -> if x = nom then valeur else get_asset_val q x
| [] -> raise (Failure "Pas d'échange défini entre les assets")
;;


(* Ajoute la valeur v de new_a à a *)
let rec add_to_asset a new_a v rho = match rho with
| (t,h)::q -> if t = a then (
                match h with 
                | Floatval _ | Boolval _ | Stringval _ | Transacval _-> raise (Failure "is not asset")
                | Assetval r -> (t,Assetval((v,new_a)::r))::q
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

let rec print_asset a = match a with
| t::q -> Printf.printf "%f of %s, " (fst t) (snd t)
| [] -> Printf.printf ". \n"


let rec printval = function 
  | Floatval n -> Printf.printf "%f" n 
  | Boolval b -> Printf.printf "%s" (if b then "true" else "false")
  | Stringval s -> Printf.printf "\"%s\"" s
  | Walletval w -> print_wallet w
  | Assetval a -> print_asset a
  | Transacval t -> Printf.printf "{success: %b, from: %s, to: %s, price: %f, amount: %f}" t._success t._from t._to t._price t._amount
  (* | Funval _ -> Printf.printf "<fun>" *)
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
             | _ -> raise (Failure "valeur non float")
             
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
      | Transacval t -> raise (Failure "not yet implemented transac")
    )
  )

  (* | EBuy (amnt_a1 ,a1, w, a2) -> (
    (* On cherche wallet, et on crée la transacval
       puis on redonne la main *)
    match eval amnt_a1 rho with
      | Floatval amnt_a1_end -> (
          match lookup w rho with 
          | Walletval wallet ->
              (
              match lookup a2 rho with 
                | Assetval asset2 -> (
                    let amnt_a2 = get_wallet_val wallet a2 in
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
    ) *)
  | EBuy (b_amnt, buy_asst, wallet, thr_asst) -> (
    match eval b_amnt rho with
    | Floatval buy_amount -> 
      (* Ici on forme la transaction avec un lookup pour voir si assez d'argent *)
      let Walletval(_wallet) = lookup wallet rho in
      let Assetval(_buy_asst) = lookup buy_asst rho in
      let _wallet_amnt = get_wallet_val _wallet buy_asst in
      let _wallet_value = get_asset_val _buy_asst thr_asst in
      Transacval { _success = if _wallet_amnt *. _wallet_value > buy_amount then true else false;
                   _from = thr_asst; _to = buy_asst; _amount = buy_amount; _price = buy_amount /. _wallet_value;
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
      | (Walletval w1, Walletval w2) -> (
          match op with
          | "+" -> Walletval (add_wallets w1 w2)
          | "-" -> Walletval (sub_wallets w1 w2)
      )
      | (Walletval w, Floatval f) -> (
          match op with 
          | "*" -> Walletval ( k_mult_wallet f w)
          | "/" -> Walletval ( k_mult_wallet (1./.f) w)
      )
      | (Floatval f, Walletval w) -> (
          match op with
          | "*" -> Walletval ( k_mult_wallet f w)
          | "/" -> Walletval ( k_mult_wallet (1./.f) w)
      )
      | _ -> raise (Failure (Printf.sprintf "Opérandes invalides pour l'opérateur %s" op))
  )
  | EFun (p, e) -> Funval {param = p; body = e; env = rho}
  | EApp (e1, e2) -> (
        match (eval e1 rho, eval e2 rho) with
        | (Funval {param; body; env}, v2) -> 
            let rho1 = extend env param v2 in 
            eval body rho1
        | _ -> raise (Failure "pas une fonction")
  )

  
  
;;



let eval e = eval e init_env ;;