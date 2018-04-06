module Term = struct
  module Var = struct
    include Int
  end

  type t =
    | Var of Var.t
    | Lam of Var.t * t
    | App of t * t

  (* type var_set = (Var.t, Var.comparator_witness) Set.t *)

  let supply =
    let open Sequence in
    let init = 0 in
    let f x = Step.Yield (x, x + 1) in
    unfold_step ~init ~f

  let fresh xs =
    let f x = not @@ Set.mem xs x in
    Sequence.find_exn supply ~f

  let rec free_vars t =
    begin match t with
      | Var x -> Set.singleton (module Var) x
      | Lam (x, e) -> Set.remove (free_vars e) x
      | App (f, a) -> Set.union (free_vars f) (free_vars a)
    end

  let rec all_vars t =
    begin match t with
      | Var x -> Set.singleton (module Var) x
      | Lam (_, e) -> all_vars e
      | App (f, a) -> Set.union (all_vars f) (all_vars a)
    end

  let rec subst x s b =
    let rec go e =
      begin match e with
        | Var v ->
          if Var.equal v x then
            s
          else
            e
        | Lam (v, e') ->
          if Var.equal v x then
            e
          else
            let fvars = free_vars s in
            if Set.mem fvars v then
              let v' = fresh @@ Set.union fvars (all_vars b) in
              Lam (v', go @@ subst v (Var v') e')
            else
              Lam (v, go e')
        | App (f, a) -> App (go f, go a)
      end in
    go b

  let rec whnf e =
    begin match e with
      | Var _ -> e
      | Lam (_, _) -> e
      | App (f, a) ->
        begin match whnf f with
          | Lam (x, b) -> whnf (subst x a b)
          | f' -> App (f', a)
        end
    end

  let rec nf e =
    begin match e with
      | Var _ -> e
      | Lam (x, e) -> Lam (x, nf e)
      | App (f, a) ->
        begin match whnf f with
          | Lam (x, b) -> nf (subst x a b)
          | f' -> App (nf f', nf a)
        end
    end
end

module Harness = struct
end
