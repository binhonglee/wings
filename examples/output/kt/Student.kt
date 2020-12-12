// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/student.wings -c:wings.json` upon completion.

package kt

// Any person who is studying in a class
class Student {
  var ID: Int = -1
  var name: String = ""
  var curClass: String = ""
  var feeling: Emotion = Emotion.Meh
  var isActive: Boolean = false
  var year: Date = Date()
  var graduation: Date = Date()
  var homeworks: ArrayList<Homework> = arrayListOf<Homework>()
  var ids: ArrayList<Int> = arrayListOf<Int>()
  var something: HashMap<String, String> = hashMapOf<String, String>()

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
      "ids" -> return "ids"
      "something" -> return "something"
      else -> return key
    }
  }
}