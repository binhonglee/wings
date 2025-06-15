// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/place.wings -c:wings.json` upon completion.

package kt
import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// One of many location for a Day (in a Trip).
@Serializable
@Parcelize
data class Place(
    
    @SerialName(value = "id")
    var ID: Int,
    
    
    @SerialName(value = "label")
    var label: String,
    
    
    @SerialName(value = "url")
    var url: String,
    
    
    @SerialName(value = "description")
    var description: String,
    
) : Parcelable