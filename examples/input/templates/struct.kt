package {#1}
// #BEGIN_IMPORT
// #IMPORT1 import {#IMPORT_1}
// #END_IMPORT
import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// {#COMMENT}
@Serializable
@Parcelize
data class {#NAME}(
// #BEGIN_VAR
    // #VAR {#TYPE_PREFIX}
    // #VAR @SerialName(value = "{#VARNAME_JSON}")
    // #VAR var {#VARNAME_CAMEL}: {#TYPE},
    // #VAR {#TYPE_SUFFIX}
// #END_VAR
) : {#IMPLEMENT}Parcelable
