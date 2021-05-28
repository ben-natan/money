(* Recherche du type d'un identificateur dans un environment. *)
let rec find_id_sch idname = function
  | [] -> raise (Types.Error ("Unbound variable " ^ idname))
  | h :: q -> if fst h = idname then snd h else find_id_sch idname q
;;


(* Inf�rence du type d'une expression. *)
let rec type_expr env = function
  | Mnyast.EFloat _ -> (Types.TFloat, Subst.empty)
  | Mnyast.EBool _ -> (Types.TBool, Subst.empty)
  | Mnyast.EString _ -> (Types.TString, Subst.empty)
  | Mnyast.EWallet _ -> (Types.TWallet, Subst.empty)
  | Mnyast.EAsset _ -> (Types.TAsset, Subst.empty)
  | Mnyast.EBuy _ -> (Types.TTransac, Subst.empty)
  | Mnyast.EIdent v -> (Types.instance (find_id_sch v env), Subst.empty)
  | Mnyast.EIf (cond_e, then_e, else_e) -> (
      (* Typage de la condition. *)
      let (cond_ty, cond_subst) = type_expr env cond_e in
      (* Forcer le type � �tre bool. *)
      let u = Unify.unify cond_ty Types.TBool in
      (* Typage des 2 branches du if. *)
      let (then_ty, st) =
        type_expr (Subst.subst_env (Subst.compose u cond_subst) env) then_e in
      let (else_ty, se) =
        type_expr
          (Subst.subst_env (Subst.compose st (Subst.compose u cond_subst)) env)
          else_e in
      (* Unification des 2 branches de la conditionnelle. *)
      let u' = Unify.unify then_ty else_ty in
      ((Subst.apply then_ty u'),
       (Subst.compose
          u'
          (Subst.compose se (Subst.compose st (Subst.compose u cond_subst)))))
     )
  | Mnyast.EFun (arg_name, body) ->
      (* Nouvelle variable de type pour le param�tre de la fonction. *)
      let arg_ty = Types.new_ty_var () in
      (* Type et substitution du corps. *)
      let (body_ty, body_sub) =
        type_expr ((arg_name, (Types.trivial_sch arg_ty)) :: env) body in
      (Types.TFun ((Subst.apply arg_ty body_sub, body_ty)), body_sub)
  | Mnyast.EAff (v_name, e1, e2) ->
      let (e1_ty, e1_sub) = type_expr env e1 in
      let new_env = Subst.subst_env e1_sub env in
      let new_env' = (v_name, (Types.generalize e1_ty new_env)) :: new_env in
      let (e2_ty, e2_sub) = type_expr new_env' e2 in
      (e2_ty, Subst.compose e2_sub e1_sub)
  | Mnyast.EDot (e, ident) -> (Types.TFloat, Subst.empty)

  (* | Mnyast.EFunrec (v_name, e1, e2) ->
      (* Nouvelle variable qui deviendra le type de la fonction apr�s l'avoir
         unifi� avec le type calcul� par l'inf�rence pour le corps de la
         d�finition. *)
      let e1_pre_ty = Types.new_ty_var () in
      (* Nouvel environnement pour typer le corps de la d�finition. On ne
         g�n�ralise pas le type temporairement donn� pour la d�finition. *)
      let new_env = (v_name, (Types.trivial_sch e1_pre_ty)) :: env in
      let (e1_ty, e1_sub) = type_expr new_env e1 in
      (* Il faut unifier le type suppos� et le type trouv�. *)
      let u = Unify.unify e1_pre_ty e1_ty in
      let e1_ty' = Subst.apply e1_ty u in
      (* Maintenant il faut typer la partie 'in' dans l'environnement �tendu
         par le type finalement d�termin� pour l'identificateur li�
         r�cursivement. *)
      let new_env2 = Subst.subst_env (Subst.compose u e1_sub) env in
      let new_env3 = (v_name, (Types.generalize e1_ty' new_env2)) :: new_env2 in
      let (e2_ty, e2_sub) = type_expr new_env3 e2 in
      (e2_ty, Subst.compose e2_sub (Subst.compose u e1_sub)) *)
  | Mnyast.EFunrec (_,_,_,_) -> (Types.TFloat, Subst.empty)  (* Changer ça *)
  | Mnyast.EApp (e1, e2) ->
      let (e1_ty, e1_sub) = type_expr env e1 in
      let (e2_ty, e2_sub) = type_expr (Subst.subst_env e1_sub env) e2 in
      (* Nouvelle variable de type. On sait que e1_ty doit �tre de la forme
         t1 -> t2. Notre nouvelle variable va faire office de t2. *)
      let tmp_ty = Types.new_ty_var () in
      let e1_ty' = (Subst.apply e1_ty e2_sub) in
      let u = Unify.unify (Types.TFun (e2_ty, tmp_ty)) e1_ty' in
      (Subst.apply tmp_ty u,
       (Subst.compose u (Subst.compose e2_sub e1_sub)))
  
  (* | Mnyast.EPair (e1, e2) ->
      let (e1_ty, e1_sub) = type_expr env e1 in
      let (e2_ty, e2_sub) = type_expr (Subst.subst_env e1_sub env) e2 in
      let e1_ty' = Subst.apply e1_ty e2_sub in
      (Types.T_pair (e1_ty', e2_ty), Subst.compose e2_sub e1_sub)
   *)
  | Mnyast.EBinop (o_name, e1, e2) -> (
      match o_name with
      | "+" | "-" | "/" | "*" | "||" | "&&" | "^" ->
          (* Typage des 2 op�randes. *)
          let (e1_ty, e1_sub) = type_expr env e1 in
          let (e2_ty, e2_sub) = type_expr (Subst.subst_env e1_sub env) e2 in
          (* On les force � avoir le m�me type. *)
          let u = Unify.unify e1_ty e2_ty in
          let e1_ty' = Subst.apply e1_ty u in
          (* On force ce m�me type � �tre int. On utilise le type de l'une
             des op�randes au pif. *)
          let u' = Unify.unify e1_ty' Types.TFloat in
          (* On retourne int. *)
          (TFloat,
           (Subst.compose u' (Subst.compose u (Subst.compose e2_sub e1_sub))))
      | "=" | ">" | ">=" | "<" | "<=" | "!=" ->
          (* Op�rateurs polymorphes. La seule contrainte est que les deux
             op�randes aient le m�me type. *)
          let (e1_ty, e1_sub) = type_expr env e1 in
          let (e2_ty, e2_sub) = type_expr (Subst.subst_env e1_sub env)  e2 in
          let u = Unify.unify e1_ty e2_ty in
          (* Retourner bool. *)
          (TBool, (Subst.compose u (Subst.compose e2_sub e1_sub)))
      | _ -> failwith "Unknown binop"
     )
  | Mnyast.EMonop (o_name, e) -> (
      match o_name with
      | "-" | "%" | "!" ->
          (* Typage de l'op�rande. *)
          let (e1_ty, e1_sub) = type_expr env e in
          (* On force ce type � �tre int. *)
          let u = Unify.unify e1_ty Types.TFloat in
          (* On retourne int. *)
          (TFloat, (Subst.compose u e1_sub))
      | _ -> failwith "Unknown monop"
     )
;;
