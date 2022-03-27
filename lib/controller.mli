open Tokenizer
open Database

(** [create table_name cols val_types] *)
val create : string -> string list -> col_type list -> unit
(** [select table columns filter_function] *)
val select : string -> string list -> ('a list * 'a list -> bool) -> unit
(** [insert table columns values] *)
val insert : string -> string list -> val_type list -> unit
(** [delete table_name filtering_function] *)
val delete : string -> ('a list * 'a list -> bool) -> unit
(** [update table columns values filtering_function] *)
val update : string -> string list -> val_type list -> 
  ('b list * 'b list -> bool) -> unit
(** [drop table_name] *)
val drop : string -> unit


