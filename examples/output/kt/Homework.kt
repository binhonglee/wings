// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/homework.wings

package kt

// Work to be done at home
class Homework {
    var ID: Int = 0
    var name: String = ""
    var dueDate: Date =  Date()
    var givenDate: Date =  Date()
    var feeling: ArrayList<Emotion> =  ArrayList<Emotion>()

    fun toJsonKey(key: string): string {
        when (key) {
            "ID" -> return "id"
            "name" -> return "name"
            "dueDate" -> return "due_date"
            "givenDate" -> return "given_date"
            "feeling" -> return "feeling"
            else -> return key
        }
    }
}
