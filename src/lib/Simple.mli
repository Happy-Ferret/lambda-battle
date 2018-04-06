module Term : sig
  module Var : sig
    include Comparator.S
    val equal : t -> t -> bool
  end

  type t =
    | Var of Var.t
    | Lam of Var.t * t
    | App of t * t

  val whnf : t -> t
  val nf : t -> t
end
