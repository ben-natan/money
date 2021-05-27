let version = "0.01" ;;

let usage () = 
    let _ = 
        Printf.eprintf
            "Usage: %s [file]\n\tRead a MNY program from file (default is stdin)\n%!"
        Sys.argv.(0) in 
    exit 1
;;

let main () = 
    let input_channel = 
        match Array.length Sys.argv with
        | 1 -> stdin
        | 2 -> 
            begin match Sys.argv.(1) with
            | "-" -> stdin
            | name -> 
                begin try open_in name with
                    _ -> Printf.eprintf "Opening %s failed\n%!" name; exit 1 
                end 
            end 
        | n -> usage()
    in 
    let _ = Printf.printf "        Welcome to MONEY, version %s\n%!" version in 
    let lexbuf = Lexing.from_channel input_channel in 
    while true do
        try 
            let _ = Printf.printf "> %!" in
            let e = Mnyparse.main Mnylex.lex lexbuf in 
            let _ = Printf.printf "Recognized: " in
            let _ = Mnyast.print stdout e in 
            let _ = Printf.fprintf stdout " =\n%!" in
            let _ = Types.print stdout (fst (Infer.type_expr Types.init_env e)) in
            let _ = Mnysem.printval (Mnysem.eval e) in
            Printf.printf "\n%!"
        with 
            Mnylex.Eoi -> Printf.printf "Bye bye. \n%!" ; exit 0
            | Failure msg -> Printf.printf "Erreur: %s\n\n" msg
            | Parsing.Parse_error -> Printf.printf "Erreur de syntaxe\n\n"
            | Unify.Cycle (v_name, ty) ->
                Printf.printf "Error: variable %s appears in type %a\n\n"
                  v_name Types.print ty
            | Unify.Conflict (ty1, ty2) ->
                Printf.printf "Error: types %a and %a are incompatible\n\n"
                  Types.print ty1 Types.print ty2
    done
;;

if !Sys.interactive then () else main();;