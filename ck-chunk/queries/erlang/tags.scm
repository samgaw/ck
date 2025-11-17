; Erlang chunk definitions

; ============================================================================
; Module attributes
; ============================================================================

; Module declaration
(module_attribute
    name: (_) @name) @module

; Behaviour attribute
(behaviour_attribute
    (atom) @name) @module

; ============================================================================
; Type definitions
; ============================================================================

; Type alias
(type_alias
    name: (_) @name) @definition.type

; Opaque type
(opaque
    name: (_) @name) @definition.type

; Record declaration
(record_decl
    name: (_) @name) @definition.class

; ============================================================================
; Function definitions
; ============================================================================

; Function declarations
(fun_decl
    (function_clause
        name: (_) @name)) @definition.function

; Callback specification
(callback
    fun: (_) @name) @definition.method

; Spec attribute (function type specification)
(spec
    fun: (_) @name) @definition.type

; ============================================================================
; Preprocessor definitions
; ============================================================================

; Macro definitions
(pp_define
    lhs: (_) @name) @definition.method
