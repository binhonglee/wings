// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/place.wings -c:wings.json` upon completion.

import Foundation

// One of many location for a Day (in a Trip).
public struct Place: Codable, Identifiable {
  public var id: Int
  public var label: String
  public var url: String
  public var description: String
  
  public init(
    id: Int,
    label: String,
    url: String,
    description: String,
  ) {
    self.id = id
    self.label = label
    self.url = url
    self.description = description
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.label = try container.decode(String.self, forKey: .label)
    self.url = try container.decode(String.self, forKey: .url)
    self.description = try container.decode(String.self, forKey: .description)
  }
}

  