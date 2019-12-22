
package kt

// Any person who is studying in a class
class Student {
    var ID: Int = 0
    var name: String = ""
    var curClass: String = ""
    var feeling: Emotion =  Emotion()
    var isActive: Boolean = false
    var year: Date =  Date()
    var graduation: Date =  Date()
    var homeworks: ArrayList<Homework> =  ArrayList<Homework>()
    var something: HashMap<String, String> =  HashMap<String, String>()

    fun toJsonKey(key: string): string {
        when (key) {
            "ID" -> return "id"
            "name" -> return "name"
            "curClass" -> return "cur_class"
            "feeling" -> return "feeling"
            "isActive" -> return "is_active"
            "year" -> return "year"
            "graduation" -> return "graduation"
            "homeworks" -> return "homeworks"
            "something" -> return "something"
            else -> return key
        }
    }
}
