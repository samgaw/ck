; HEEx (HTML + EEx) chunk definitions
; HEEx is Phoenix's HTML-aware template language that extends EEx

; ============================================================================
; Components (Phoenix LiveView components)
; ============================================================================

; Function components (<.component_name>)
(component
  (component_name) @name) @definition.class

; Module components (<Module.component>)
(component
  (component_name
    (module) @module
    (function) @name)) @definition.class

; ============================================================================
; HTML Tags and Structure
; ============================================================================

; Self-closing tags
(self_closing_tag
  (tag_name) @name) @definition.function

; Start tags (for tag pairs)
(start_tag
  (tag_name) @name) @definition.function

; ============================================================================
; Elixir Expressions (embedded)
; ============================================================================

; EEx expressions <%= ... %>
(expression
  (expression_value) @definition.function) @definition.function

; EEx directives <%!-- ... --%>
(directive
  (partial_expression_value) @definition.function) @definition.function

; ============================================================================
; Special Attributes
; ============================================================================

; Phoenix-specific attributes (phx-*)
(attribute
  (special_attribute_name) @definition.function)
