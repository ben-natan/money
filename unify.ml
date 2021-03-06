(* Exception pour signeler les 2 cas d'erreurs d'unification. *)
exception Cycle of (Types.var_name * Types.ty) ;;
exception Conflict of (Types.ty * Types.ty) ;;


(* Fonction qui detecte les cycles dans un probleme d'unification. Elle sert �
   v�rifier que l'on n'a pas � unifier qqchose de la forme v et v -> v car
   dans ce cas, il n'y a pas de solution.
   On recherche donc s'il n'y a pas la variable v dans le type pass� en
   param�tre. *)
let rec occur_check v_name = function
  | Types.TFloat | Types.TBool | Types.TString | Types.TAsset | Types.TWallet | Types.TTransac -> false
  | Types.TFun (t1, t2) | Types.TPair (t1, t2) ->
      (occur_check v_name t1) || (occur_check v_name t2)
  | Types.TVar n -> v_name = n
;;


(* Unification de deux types. Retourne la substitution � effectuer pour
   unifier les 2 types.
   La structure d'une substitution est une liste de paires (var_name, type),
   o� chaque paire signifie "var_name" devient "type". *)
let rec unify t1 t2 =
  match (t1, t2) with
  | (Types.TFloat, Types.TFloat) | (Types.TBool, Types.TBool)
  | (Types.TString, Types.TString) | (Types.TAsset, Types.TAsset)
  | (Types.TWallet, Types.TWallet) | (Types.TWallet, Types.TFloat)
  | (Types.TFloat, Types.TWallet) | (Types.TTransac, Types.TTransac) 
  -> Subst.empty
  | (Types.TFun (a, b), Types.TFun (c, d)) ->
      let s1 = (unify a c) in
      (* s1 est la substitution n�cessaire pour que a et c collent. *)
      let b' = Subst.apply b s1 in
      let d' = Subst.apply d s1 in
      Subst.compose (unify b' d') s1
  | (Types.TPair (a, b), Types.TPair (c, d)) ->
      let s1 = unify a c in
      let b' = Subst.apply b s1 in
      let d' = Subst.apply d s1 in
      Subst.compose (unify b' d') s1
  | (Types.TVar v, other) | (other, Types.TVar v) ->
      if occur_check v other then raise (Cycle (v, other)) ;
      Subst.singleton v other
  | _ -> raise (Conflict (t1, t2))
;;
