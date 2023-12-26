type t_type =
  | T_int
  | T_char
  | T_array of t_type * int
  | T_none
  | T_func of t_type

(* DEBUG *)
let debugMode = false

let rec string_of_t_type = function
  | T_int -> "integer"
  | T_char -> "character"
  | T_array (t, n) -> "array(" ^ string_of_int n ^ ") of " ^ string_of_t_type t
  | T_none -> "nothing"
  | T_func t -> string_of_t_type t ^ " (function)"

let construct_array_type dimList endType =
  let rec helper cnt len dl =
    if cnt = len then
      endType
    else
      T_array (helper (cnt + 1) len (List.tl dl), List.hd dl)
  in
  if List.mem endType [ T_int; T_char ] then
    helper 0 (List.length dimList) dimList
  else
    failwith "Can't construct array of non-integers and non-characters"

let rec equal_types t1 t2 =
  match (t1, t2) with
  | T_array (t1', s1), T_array (t2', s2) ->
      if s1 = -1 || s2 = -1 then true else equal_types t1' t2'
  | _ ->
      if debugMode then
        Printf.printf "%s, %s -> " (string_of_t_type t1) (string_of_t_type t2);
      t1 = t2

let t_type_of_t_func = function T_func t -> t | _ -> assert false
(* Functions that convert types defined in Ast to t_type types are defined in
   Ast. *)
