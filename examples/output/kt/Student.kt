// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/student.wings -c:wings.json` upon completion.

package kt
import kotlinx.datetime.Instant
import kotlinx.parcelize.TypeParceler
import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// Any person who is studying in a class
@Serializable
@Parcelize
data class Student(
    
    @SerialName(value = "id")
    var ID: Int,
    
    
    @SerialName(value = "name")
    var name: String,
    
    
    @SerialName(value = "cur_class")
    var curClass: String,
    
    
    @SerialName(value = "feeling")
    var feeling: Emotion,
    
    
    @SerialName(value = "is_active")
    var isActive: Boolean,
    
    @TypeParceler<Instant, InstantParceler>
    @SerialName(value = "year")
    var year: Instant,
    
    @TypeParceler<Instant, InstantParceler>
    @SerialName(value = "graduation")
    var graduation: Instant,
    
    
    @SerialName(value = "homeworks")
    var homeworks: ArrayList<Homework>,
    
    
    @SerialName(value = "ids")
    var ids: ArrayList<Int>,
    
    
    @SerialName(value = "something")
    var something: HashMap<String, String>,
    
) : Parcelable