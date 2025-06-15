// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/homework.wings -c:wings.json` upon completion.

import Foundation

// Work to be done at home
public struct Homework: Codable, Identifiable {
  public var id: Int
  public var name: String
  public var due_date: Date
  public var given_date: Date
  public var feeling: [Emotion]
  
  public init(
    id: Int,
    name: String,
    due_date: Date,
    given_date: Date,
    feeling: [Emotion],
  ) {
    self.id = id
    self.name = name
    self.due_date = due_date
    self.given_date = given_date
    self.feeling = feeling
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.due_date = try container.decode(Date.self, forKey: .due_date)
    self.given_date = try container.decode(Date.self, forKey: .given_date)
    self.feeling = try container.decode([Emotion].self, forKey: .feeling)
  }
}

  