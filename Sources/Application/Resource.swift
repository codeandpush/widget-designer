//
// Created by Anthony Chinwo on 01/12/2017.
//

import Foundation

enum ResourceType: String {
    case image
    case html
}

protocol Resource {
    var type: ResourceType { get }
}
