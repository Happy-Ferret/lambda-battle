module rec Term : sig
  type t =
    | F of string (* free variable *)
    | B (* bound variable *)
    | L of int list * t (* lambda *)
    | A of t * t * int (* application *)
  [@@deriving (compare, hash, sexp, show { with_path = false })]
  val pretty : int -> t Fmt.t
  val free_vars : t -> int
  val occurrences : string -> string list -> int list
  val remove : string -> string list -> string list
end = struct
  type t =
    | F of string
    | B
    | L of int list * t
    | A of t * t * int
  [@@deriving (compare, hash, sexp, show { with_path = false })]

  let prec = function
    | F _ -> 0
    | B -> 0
    | L _ -> 2
    | A _ -> 1

  let rec pretty (oldp : int) fmt t =
    let newp = prec t in
    begin match t with
      | F var ->
        Fmt.string fmt var
      | B ->
        Fmt.string fmt "*"
      | L (sco, body) ->
        Fmt.pf fmt "@[%aλ[%a].@ %a%a@]"
          (Shared.Pretty.delim oldp newp) "("
          (Fmt.list ~sep:Fmt.sp Fmt.int) sco
          (pretty newp) body
          (Shared.Pretty.delim oldp newp) ")"
      | A (head, tail, split) ->
        Fmt.pf fmt "@[%a%a%a@ %a%a@]"
          (Shared.Pretty.delim oldp newp) "("
          (pretty 1) head
          Fmt.string (Shared.Pretty.Digits.super split)
          (pretty 0) tail
          (Shared.Pretty.delim oldp newp) ")"
    end

  let rec free_vars t =
    begin match t with
      | F _ -> 0
      | B -> 1
      | L (bind, body) -> free_vars body - List.length bind
      | A (head, tail, _) -> free_vars head + free_vars tail
    end

  let occurrences y =
    let rec go i xs =
      begin match xs with
        | [] -> []
        | x::xs when String.compare x y = 0 -> i :: go      0  xs
        | _::xs                             ->      go (i + 1) xs
      end in
    go 0

  let rec remove y xs =
    begin match xs with
      | [] -> []
      | x::xs when String.compare x y = 0 ->      remove y xs
      | x::xs                             -> x :: remove y xs
    end

  (* let rec of_term ctx (term : Simple.Term.t) : t * string list =
    let open! Simple.Term in
    begin match term with
      | V var ->
        if Set.mem ctx var then
          B, [var]
        else
          F var, []
      | L (var, body) ->
        let body, xs = of_term (Set.add ctx var) body in
        let bind = occurrences var xs in
        let xs = remove var xs in
        L (bind, body), xs
      | A (head, tail) ->
        let head, xs = of_term ctx head in
        let tail, ys = of_term ctx tail in
        let split = List.length xs in
        A (head, tail, split), xs @ ys
    end *)
end

and Value : sig
  type t =
    | L of { sco : int list; body : Term.t; sub : t list } (* lambda *)
    | A of { head : string; spine : t list } (* application *)
  [@@deriving (compare, hash, sexp, show { with_path = false })]
end = struct
  type t =
    | L of { sco : int list; body : Term.t; sub : t list }
    | A of { head : string; spine : t list }
  [@@deriving (compare, hash, sexp, show { with_path = false })]

  let insert w vs ks =
    let rec go w cur next vs ks =
      begin match vs, ks with
        |    vs,    [] when next = cur -> w :: vs
        |    vs, k::ks when next = cur -> w :: go w (cur + 0) (next + k) vs ks
        | v::vs,    ks                 -> v :: go w (cur + 1) (next + 0) vs ks
        | _                            -> assert false
      end in
    begin match ks with
      | []    -> vs
      | k::ks -> go w 0 k vs ks
    end
end

module Harness = struct
end
