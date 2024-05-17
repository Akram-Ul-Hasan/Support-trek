import UIKit

extension UITextField {
    
    var isValidEmail: Bool {
        guard let text = self.text else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: text)
    }
    
    var isValidPhoneNumber: Bool {
        guard let text = self.text else { return false }
        let phoneRegEx = "^\\+?88?[0-9]{11}$"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: text)
    }
        
    var isValidClientCode: Bool {
        guard let text = self.text else { return false }
        let clientCodeRegEx = "^[0-9]{6}$"
        let clientCodePred = NSPredicate(format:"SELF MATCHES %@", clientCodeRegEx)
        return clientCodePred.evaluate(with: text)
    }

    func setPlaceholder(text: String) {
        let fontSize: CGFloat = 16.0
        let fontWeight: UIFont.Weight = .light
        let lineHeight: CGFloat = 19.09
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
            .foregroundColor: UIColor(named: "placeholderColor") ?? .gray,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
        
        self.attributedPlaceholder = attributedPlaceholder
    }
    
}

