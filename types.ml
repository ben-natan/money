exception Error of string ;;

type var_name = string ;;

(* Types. *)
type ty =
  | TFloat
  | TBool
  | TString
  | TAsset
  | TWallet
  | TTransac
  | TFun of (ty * ty)
  | TVar of var_name
  | TPair of (ty * ty)
;;


(* Sch�mas de type. *)
type sch = ((var_name list) * ty) ;;

(* Environnements de typage. *)
type env = (string * sch) list ;;


(* Environnement initial : contient les constantes true et false. *)
let init_env = [
  ("true", ([], TBool)) ;
  ("false", ([], TBool))
] ;;


(* G�n�re une nouvelle variable de type. *)
let new_ty_var =
  let cpt = ref 0 in
  function () -> cpt := !cpt + 1 ; TVar ("t" ^ (string_of_int !cpt))
;;

(* Retourne une instance fra�che de sch�ma de type. *)
let instance sch =
  let var_mapping = List.map (fun v -> (v, new_ty_var ())) (fst sch) in
  let rec rec_copy ty =
    match ty with
    | TFloat | TBool | TString | TWallet | TAsset | TTransac -> ty
    | TFun (ty1, ty2) -> TFun ((rec_copy ty1), (rec_copy ty2))
    | TPair (ty1, ty2) -> TPair ((rec_copy ty1), (rec_copy ty2))
    | TVar v_name -> (try List.assoc v_name var_mapping with Not_found -> ty) in
  rec_copy (snd sch)
;;


(* V�rifie si un nom de variable de type appara�t dans un type. *)
let appear_in_ty v_name ty =
  let rec rec_appear = function
    | TFloat | TBool | TString | TWallet | TAsset | TTransac -> false
    | TFun (ty1, ty2) | TPair (ty1, ty2) -> (rec_appear ty1) || (rec_appear ty2)
    | TVar v_name' -> v_name = v_name' in
  rec_appear ty
;;


(* V�rifie si un nom de variable de type appara�t quelque part dans les
   types/sch�mas enregistr�s dans un environnement. *)
let appear_in_env v_name env =
  List.exists (fun (_, sch) -> appear_in_ty v_name (snd sch)) env ;;


(* Retourne un sch�ma de type trivial (pas de g�n�ralisation). *)
let trivial_sch ty = ([], ty) ;;


(* Generalise un type par rapport � un environnement. *)
let generalize ty env =
  let rec find_gen_vars accu = function
    | TFloat | TBool | TString | TWallet | TAsset | TTransac -> accu
    | TFun (ty1, ty2) | TPair (ty1, ty2) ->
        let accu' = find_gen_vars accu ty1 in
        find_gen_vars accu' ty2
    | TVar v_name ->
        if not (appear_in_env v_name env) then v_name :: accu else accu in
  ((find_gen_vars [] ty), ty)
;;


(* Pretty-printer pour les types. *)
let rec print ppf = function
  | TFloat -> Printf.fprintf ppf "int"
  | TBool -> Printf.fprintf ppf "bool"
  | TString -> Printf.fprintf ppf "string"
  | TWallet -> Printf.fprintf ppf "wallet"
  | TAsset -> Printf.fprintf ppf "asset"
  | TTransac -> Printf.fprintf ppf "transac"
  | TFun (t1, t2) -> Printf.fprintf ppf "(%a -> %a)" print t1 print t2
  | TVar v -> Printf.fprintf ppf "'%s" v
  | TPair (t1, t2) -> Printf.fprintf ppf "(%a * %a)" print t1 print t2
;;
