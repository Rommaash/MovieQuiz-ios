import UIKit

public struct AlertModel{
    var title: String
    var message: String
    var buttonText: String
    let completion: () -> ()
}
