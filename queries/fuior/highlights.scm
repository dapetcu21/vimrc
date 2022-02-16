;;; Highlighting for fuior

;;; Builtins
;; Keywords

(if_statement [ "if" "end" ] @conditional)
(elseif_clause "elseif" @conditional)
(else_clause "else" @conditional)

(choose_statement ["choose" "end"] @conditional)

(declare_var_statement "var" @keyword)
(return_statement "return" @keyword)
(choice_meta ["meta" "end"] @keyword)

;; Operators

[
 "not"
 "and"
 "or"
] @keyword.operator

[
"="
"-"
"*"
"/"
"+"
"<"
">"
"<="
">="
"!="
 ] @operator

;; Punctuation
[
  ":"
] @punctuation

;; Brackets
[
 "("
 ")"
 "["
 "]"
 "{"
 "}"
] @punctuation.bracket

;; Variables
[
  (identifier)
  (assign_lvalue)
] @variable
(declare_var_decorator ["@" (decorator_name)] @keyword)

;; Constants
(boolean) @boolean
(nil) @constant.builtin
(string) @string
(intl_string) @string
(number) @number

;; Functions
(command_signature (command_name) @function)
(declare_command_statement ["declare" "command"] @keyword.function)
(define_command_statement "command" @keyword.function)
(define_command_statement "end" @keyword)

(function_call (identifier) @function . (arg_list))

(command_verb) @function

;; Parameters
(arg_definition
  (arg_name) @parameter)

;; Types
(type_identifier) @type

;; Nodes
(comment) @comment

;; Text
(text_statement (text_actor) @type)
(text_statement (text_animation) @variable)
(text_copy) @string

(escape_sequence) @punctuation.special

(string_interpolation
  "${" @punctuation.special
  "}" @punctuation.special) @none

;; Error
(ERROR) @error
