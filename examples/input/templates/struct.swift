import Foundation
// #BEGIN_IMPORT
// #IMPORT1 import {#IMPORT_1}
// #END_IMPORT

// {#COMMENT}
public struct {#NAME}: Codable, Identifiable {
// #BEGIN_VAR
  // #VAR public var {#VARNAME_JSON}: {#TYPE}
// #END_VAR
  
  public init(
// #BEGIN_CONSTRUCTOR
    // #CONSTRUCTOR {#VARNAME_JSON}: {#TYPE},
// #END_CONSTRUCTOR
  ) {
// #BEGIN_PARAMS
    // #PARAMS self.{#VARNAME_JSON} = {#VARNAME_JSON}
// #END_PARAMS
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
// #BEGIN_JSON
    // #JSON self.{#VARNAME_JSON} = try container.decode({#TYPE}.self, forKey: .{#VARNAME_JSON})
// #END_JSON
  }
}

// #BEGIN_FUNCTIONS
  // #FUNCTIONS {#FUNCTIONS}
// #END_FUNCTIONS
