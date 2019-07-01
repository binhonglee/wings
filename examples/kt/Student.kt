/* This is a generated file
 *
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * Source: examples/student.struct
 */

package kt

import java.util.ArrayList

class Student {
    var id: Int = -1
    var name: String = ""
    var class: String = ""
    var isActive: Boolean = true
    var year: Date = Date()
    var homeworks: ArrayList<Homework> = ArrayList<Homework>()

    fun toJsonKey(key: string): string {
        when (key) {
            "id" -> return "id"
            "name" -> return "name"
            "class" -> return "class"
            "isActive" -> return "is_active"
            "year" -> return "year"
            "homeworks" -> return "homeworks"
            else -> return key
        }
    }
}
