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
end

and Value : sig
  type t =
    | L of { sco : int list; body : Term.t; sub : t list } (* lambda *)
    | A of { head : string; spine : t list } (* application *)
  [@@deriving (compare, hash, sexp, show { with_path = false })]
end

module Harness : sig
  include Shared.Battle.Harness
end
