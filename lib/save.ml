open Rep
open Printf
open Type

let conc_comma = String.concat ","
let conc_line = String.concat "\n"

let rec type_to_string = function
  | [] -> []
  | h :: t ->
      let type_helper (t : Type.data_type) =
        match t with
        | Int -> "Int"
        | Float -> "Float"
        | String -> "String"
      in
      type_helper h :: type_to_string t

let rec string_to_type = function
| [] -> []
| h::t ->
  let string_helper t : data_type =
    match t with
    | "Int" -> Int
    | "Float" -> Float
    | "String" -> String
    | _ -> failwith "Type Error: Type does not exist"
  in
  string_helper h :: string_to_type t

let rec get_main_table db table_name cols =
  match cols with
  | [] -> []
  | h :: t ->
      (get_column_data db table_name h |> conc_comma)
      :: get_main_table db table_name t

let get_file db table_name =
  let field_names_pair =
    get_field_name_list db table_name |> List.split
  in
  let field_name_lst = field_names_pair |> fst in
  let field_name_string = field_name_lst |> conc_comma in
  let field_name_type =
    field_names_pair |> snd |> type_to_string |> conc_comma
  in
  let main_table = get_main_table db table_name field_name_lst in
  let table_title =
    field_name_string :: field_name_type :: []
  in
  (table_title |> conc_line) :: (main_table |> conc_line) :: []


  (* Save it to a file *)
  let save_file db table_name =
  let ecsv_title = Csv.input_all (Csv.of_string (List.nth (get_file db table_name) 0)) in
  let ecsv_main' = Csv.input_all (Csv.of_string (List.nth (get_file db table_name) 1)) in
  let ecsv_main = Csv.transpose ecsv_main' in
  let fname_title =
    Filename.concat Filename.current_dir_name
      ("csv_files/" ^ table_name ^ "_title.csv")
  in
  Csv.save fname_title ecsv_title;
  let fname_main =
    Filename.concat Filename.current_dir_name
      ("csv_files/" ^ table_name ^ "_main.csv")
  in
  Csv.save fname_main ecsv_main;
  printf "Saved CSV to file %S and %S.\n" fname_title fname_main

(** MS3 below this line *)

let csvs table_name =
  List.map (fun name -> Csv.load name)
           [ "csv_files/"^table_name^"_title.csv"; "csv_files/"^table_name^"_main.csv" ]

let file_to_db db table_name =
  let csv = csvs table_name in
  let csv_title = List.nth csv 0 |> Csv.to_array in
  let csv_main = List.nth csv 1 |> Csv.to_array in
  let csv_title1 = csv_title.(0) |> Array.to_list in
  let csv_title2 = csv_title.(1) |> Array.to_list |> string_to_type in
  let combine_func_1 str typ = (str,typ) in
  let combine_title = List.map2 combine_func_1 csv_title1 csv_title2 in
    ignore (create_table db table_name combine_title); (* create *)
  let array_to_db (str_arr:string array) : unit =
    let str_lst = str_arr |> Array.to_list in
    let combine_func_2 str1 str2 = (str1,str2) in
    let combine_row = List.map2 combine_func_2 csv_title1 str_lst in
  ignore (insert_row db table_name combine_row) (* insert *)
  in
  Array.iter array_to_db csv_main

let rec print_2d_array lst =
  let rec print_array = function
    | [] -> ""
    | h :: t -> h ^ " " ^ print_array t
  in
  match lst with
  | [] -> ""
  | h :: t -> print_array (Array.to_list h) ^ "\n" ^ print_2d_array t

(* let () = print_string (print_2d_array (Array.to_list csv_title))
let () = print_string (print_2d_array (Array.to_list csv_main)) *)
  