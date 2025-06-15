// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/student.wings -c:wings.json` upon completion.

import Foundation

// Any person who is studying in a class
public struct Student: Codable, Identifiable {
  public var id: Int
  public var name: String
  public var cur_class: String
  public var feeling: Emotion
  public var is_active: Boolean
  public var year: Date
  public var graduation: Date
  public var homeworks: [Homework]
  public var ids: [Int]
  public var something: [String: String]
  
  public init(
    id: Int,
    name: String,
    cur_class: String,
    feeling: Emotion,
    is_active: Boolean,
    year: Date,
    graduation: Date,
    homeworks: [Homework],
    ids: [Int],
    something: [String: String],
  ) {
    self.id = id
    self.name = name
    self.cur_class = cur_class
    self.feeling = feeling
    self.is_active = is_active
    self.year = year
    self.graduation = graduation
    self.homeworks = homeworks
    self.ids = ids
    self.something = something
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.cur_class = try container.decode(String.self, forKey: .cur_class)
    self.feeling = try container.decode(Emotion.self, forKey: .feeling)
    self.is_active = try container.decode(Boolean.self, forKey: .is_active)
    self.year = try container.decode(Date.self, forKey: .year)
    self.graduation = try container.decode(Date.self, forKey: .graduation)
    self.homeworks = try container.decode([Homework].self, forKey: .homeworks)
    self.ids = try container.decode([Int].self, forKey: .ids)
    self.something = try container.decode([String: String].self, forKey: .something)
  }
}

  