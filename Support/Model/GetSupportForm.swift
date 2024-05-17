
import Foundation
import UIKit

struct GetSupportForm {
    let email: String
    let phone: String
    let clientCode: Int
    let issueType: IssueType
    let issueDescription: String
    let image: [UIImage]?
    
    init(email: String, phone: String, clientCode: Int, issueType: IssueType, issueDescription: String, image: [UIImage]? = nil) {
        self.email = email
        self.phone = phone
        self.clientCode = clientCode
        self.issueType = issueType 
        self.issueDescription = issueDescription
        self.image = image
    }
}

enum IssueType: String {
    case trading = "Trading"
    case deposit = "Deposit"
    case withdrawal = "Withdrawal"
    case BOAccountCreatation = "BO A/C Creation"
    case changeBoAccountInfo = "Change BO A/C Information"
    case wrongInfo = "Wrong Information"
    case others = "Others"
}
