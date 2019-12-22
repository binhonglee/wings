
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
