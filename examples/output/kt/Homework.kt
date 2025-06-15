// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/homework.wings -c:wings.json` upon completion.

package kt
import kotlinx.datetime.Instant
import kotlinx.parcelize.TypeParceler
import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// Work to be done at home
@Serializable
@Parcelize
data class Homework(
    
    @SerialName(value = "id")
    var ID: Int,
    
    
    @SerialName(value = "name")
    var name: String,
    
    @TypeParceler<Instant, InstantParceler>
    @SerialName(value = "due_date")
    var dueDate: Instant,
    
    @TypeParceler<Instant, InstantParceler>
    @SerialName(value = "given_date")
    var givenDate: Instant,
    
    
    @SerialName(value = "feeling")
    var feeling: ArrayList<Emotion>,
    
) : Parcelable