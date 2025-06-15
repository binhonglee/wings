package {#1}

var val_{#NAME} = 0

// #BEGIN_VAR
enum class {#NAME}(val value: Int = val_{#NAME}++) {
    // #VAR {#VARNAME_PASCAL},
}
// #END_VAR
