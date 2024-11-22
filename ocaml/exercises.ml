exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

(* applies consumer function to the first elem in array that satisfies predicate *)
let first_then_apply array predicate consumer =
  match List.find_opt predicate array with
  | None -> None
  | Some x -> consumer x

(* generates infinite sequence of powers for a base *)
let powers_generator base =
  let rec generate_from power () =
    Seq.Cons (power, generate_from (power * base))

  in
  generate_from 1;;
 
(* counts number of meaningful lines in the file *)
  let meaningful_line_count filename =
    let meaningful_line line =
      let trimmed = String.trim line in (* trims lines that are not meaningful *)
      String.length trimmed > 0 && not (String.starts_with ~prefix:"#" trimmed)
    in
    let the_file = open_in filename in (* opens the file*)
    let finally () = close_in the_file in (* how it closes the file *)
    let rec count_lines count =
      try
        let line = input_line the_file in
        if meaningful_line line then
          count_lines (count + 1)
        else
          count_lines count (* returns the count of meaningful lines*)
      with
      | End_of_file -> count
    in
    Fun.protect ~finally (fun () -> count_lines 0);;
  
(* defines shape object *)
type shape = 
 | Sphere of float
 | Box of float * float * float

(* calculates volume of given shape *)
let volume s =
  match s with
  | Sphere r -> Float.pi *. (r ** 3.) *. 4. /. 3.
  | Box (l, w, h) -> l *. w *. h;;

(* calculates surface area of given shape *)
let surface_area s =
  match s with
  | Sphere r -> 4. *. Float.pi *. (r ** 2.)
  | Box (l, w, h) -> 2. *. (l *. w +. l *. h +. w *. h);;

  
(* BST defined *)
type 'a binary_search_tree =
  | Empty
  | Node of 'a * 'a binary_search_tree * 'a binary_search_tree

(* inserts a value into the BST *)
let rec insert value tree =
  match tree with
  | Empty -> Node (value, Empty, Empty)
  | Node (v, left, right) ->
      if value < v then
        Node (v, insert value left, right)
      else if value > v then
        Node (v, left, insert value right)
      else
        tree  

(* check if the BST contains a given value *)
let rec contains value tree =
  match tree with
  | Empty -> false
  | Node (v, left, right) ->
      if value = v then
        true
      else if value < v then
        contains value left
      else
        contains value right

(* calculates the size of the BST, aka counts number of objects *)
let rec size tree =
  match tree with
  | Empty -> 0
  | Node (_, left, right) ->
      1 + size left + size right

(* inorder traversal of the BST *)
let rec inorder tree =
  match tree with
  | Empty -> []
  | Node (v, left, right) ->
      inorder left @ [v] @ inorder right

(* string representation of the tree *)
let rec to_string tree =
  match tree with
  | Empty -> "Empty"
  | Node (v, left, right) ->
      Printf.sprintf "(%s, %s, %s)" (to_string left) (string_of_int v) (to_string right)

(* exports the Empty constructor *)
let empty = Empty
