; Elixir chunk definitions

; ============================================================================
; Module-level definitions
; ============================================================================

; Module definitions (defmodule, defprotocol, defimpl)
(call
  target: (identifier) @_target
  (#match? @_target "^(defmodule|defprotocol|defimpl)$")) @module

; Exception definitions
(call
  target: (identifier) @_target
  (#eq? @_target "defexception")) @definition.class

; Struct definitions
(call
  target: (identifier) @_target
  (#eq? @_target "defstruct")) @definition.class

; Behaviour attribute
(unary_operator
  operator: "@"
  operand: (call
    target: (identifier) @_behaviour_target
    (#eq? @_behaviour_target "behaviour"))) @module

; ============================================================================
; Function and macro definitions
; ============================================================================

; Standard function definitions (def, defp)
(call
  target: (identifier) @_target
  (#match? @_target "^(def|defp)$")) @definition.function

; Numerical function definitions (defn, defnp - from Nx library)
(call
  target: (identifier) @_target
  (#match? @_target "^(defn|defnp)$")) @definition.function

; Delegated functions
(call
  target: (identifier) @_target
  (#eq? @_target "defdelegate")) @definition.function

; Guard definitions
(call
  target: (identifier) @_target
  (#match? @_target "^(defguard|defguardp)$")) @definition.function

; Macro definitions (defmacro, defmacrop)
(call
  target: (identifier) @_target
  (#match? @_target "^(defmacro|defmacrop)$")) @definition.method

; Overridable function markers
(call
  target: (identifier) @_target
  (#eq? @_target "defoverridable")) @definition.function

; Anonymous functions
(anonymous_function) @definition.function

; ============================================================================
; Type specifications and documentation
; ============================================================================

; Type specifications (@type, @typep, @opaque, @spec, @callback, @macrocallback)
(unary_operator
  operator: "@"
  operand: (call
    target: (identifier) @_type_target
    (#match? @_type_target "^(type|typep|opaque|spec|callback|macrocallback)$"))) @definition.type

; Documentation attributes (@doc, @moduledoc, @typedoc, @shortdoc)
(unary_operator
  operator: "@"
  operand: (call
    target: (identifier) @_doc_target
    (#match? @_doc_target "^(doc|moduledoc|typedoc|shortdoc)$"))) @definition.documentation

; ============================================================================
; Test definitions (ExUnit)
; ============================================================================

; Test setup (setup, setup_all)
(call
  target: (identifier) @_target
  (#match? @_target "^(setup|setup_all)$")) @definition.function

; Test blocks (describe, test)
(call
  target: (identifier) @_target
  (#match? @_target "^(describe|test)$")) @definition.function
