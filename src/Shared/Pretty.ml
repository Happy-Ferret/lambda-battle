module Digits = struct
  let sub i =
    let script = function
      | 0 -> "₀"
      | 1 -> "₁"
      | 2 -> "₂"
      | 3 -> "₃"
      | 4 -> "₄"
      | 5 -> "₅"
      | 6 -> "₆"
      | 7 -> "₇"
      | 8 -> "₈"
      | 9 -> "₉"
      | _ -> failwith "bad subscript" in
    let rec go acc = function
      | 0 -> acc
      | n -> go (script (n mod 10) ^ acc) (n / 10) in
    begin match i with
      | 0 -> "₀"
      | i -> go "" i
    end

  let super i =
    let script = function
      | 0 -> "⁰"
      | 1 -> "¹"
      | 2 -> "²"
      | 3 -> "³"
      | 4 -> "⁴"
      | 5 -> "⁵"
      | 6 -> "⁶"
      | 7 -> "⁷"
      | 8 -> "⁸"
      | 9 -> "⁹"
      | _ -> failwith "bad subscript" in
    let rec go acc = function
      | 0 -> acc
      | n -> go (script (n mod 10) ^ acc) (n / 10) in
    begin match i with
      | 0 -> "⁰"
      | i -> go "" i
    end
end

let delim oldp newp fmt d =
  if oldp < newp then
    Fmt.pf fmt "%s" d
