open Tokenizer

(** Representation of dynamic adventure state. *)

type record 
(** A dummy type representing a row in a table in the database. *)

type table
(** THe abstract type representing a table. *)
type data_base
(** The abstract type representing a database. *)

(** Partition the line into commands and get rid of ";" *)
val parse : token list -> unit


(** Parse one command, calls parse create, insert, delete, update, 
which then calls te controller. *)
val parse_query : token list -> unit

(** 这一波是叫controller functions的兄弟们， the last ones that return units*)


(** [parse_create input] parse a create data base command to send 
to controller_create to create a table. *)
val parse_create : token list -> unit


(** Parse an insert command  (make sure to cosume "INTO" because tokenizer 
does not handle that) *)
val parse_insert : token list -> unit


(** Parse delete command, calls controller.delete. *)
val parse_delete : token list -> unit


(** Parse update command and call controller.update *)
val parse_update : token list -> unit


(** Parse select command which calls parse_from and parse_where. *)
val parse_select : token list -> unit


(** [parse_drop input] Parse drop command and tell controller to drop either 
an entire database or entire table. *)
val parse_drop : token list -> unit


(** 这一波return the parameters of controllers, the functions above will call 
the functions below. *)


(** Parse the from phrase, return the target table we are manipulating, 
used as parameter for calling controller methods. *)
val parse_from : token list -> data_base

(** [parse_where input] parse where clause [token list] to a list [bool list]
where the (n-1)th bool repersent whether the nth row satisfy the condition 
specified in the where clause, true if satisfy and false otherwise *)
val parse_where : token list -> bool list

(** We might need a syntax tree for the expressions, it will be represented 
by helper functions within parse_where. *)