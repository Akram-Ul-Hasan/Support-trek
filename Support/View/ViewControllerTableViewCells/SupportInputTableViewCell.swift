//
//  SupportInputTableViewCell.swift
//  Support
//
//  Created by Akram Ul Hasan on 7/5/24.
//

import UIKit

class SupportInputTableViewCell: UITableViewCell {

    @IBOutlet weak var curvedView: UIView!
    @IBOutlet weak var logoBackground: UIView!
    @IBOutlet weak var supportIcon: UIImageView!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var clientCodeTextField: UITextField!
    
    let validator = Validation()
    
    static let classname = String(describing: SupportInputTableViewCell.self)
    
    static func nib() -> UINib {
        return UINib(nibName: SupportInputTableViewCell.classname, bundle: nil)
    }
    
    public func configure() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTextField()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLogoBackground()
        curvedView.roundCorners(corners: [.topLeft, .topRight], radius: 38)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.endEditing(true)
    }
    
    private func setupTextField() {
        self.emailAddressTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.clientCodeTextField.delegate = self
        
        self.emailAddressTextField.setPlaceholder(text: "example@gmail.com")
        self.emailAddressTextField.keyboardType = .emailAddress
        
        self.phoneNumberTextField.setPlaceholder(text: "+8801272340815")
        self.phoneNumberTextField.keyboardType = .numberPad

        self.clientCodeTextField.setPlaceholder(text: "657458")
        self.clientCodeTextField.keyboardType = .numberPad
    }
    
    private func setupLogoBackground() {
        logoBackground.layer.cornerRadius = logoBackground.layer.frame.size.width / 2
        logoBackground.layer.shadowColor = UIColor(red: 0, green: 0.289, blue: 0.009, alpha: 0.1).cgColor
        logoBackground.layer.shadowOpacity = 1
        logoBackground.layer.shadowOffset = CGSize(width: 8, height: 8)
        logoBackground.layer.shadowRadius = 16
        logoBackground.clipsToBounds = false
    }
    
//    func validateEmail(_ email: String?) {
//        guard let email = email else { return }
//        let isValid = validator.isValidEmail(input: email)
//        updateTextFieldAppearance(emailAddressTextField, isValid: isValid)
//    }
//        
//    func validatePhoneNumber(_ phoneNumber: String?) {
//        guard let phoneNumber = phoneNumber else { return }
//        let isValid = validator.isValidPhoneNumber(phoneNumber: phoneNumber)
//        updateTextFieldAppearance(phoneNumberTextField, isValid: isValid)
//    }
//        
//    func validateClientCode(_ clientCode: String?) {
//        guard let clientCode = clientCode else { return }
//        let isValid = validator.isValidClientCode(clientCode: clientCode)
//        updateTextFieldAppearance(clientCodeTextField, isValid: isValid)
//    }
//        
//        // Helper method to update text field appearance based on validation result
//    private func updateTextFieldAppearance(_ textField: UITextField, isValid: Bool) {
//        textField.layer.borderColor = isValid ? UIColor(named: "borderColor")?.cgColor : UIColor.red.cgColor
//        textField.textColor = isValid ? UIColor(named: "labelColor") : UIColor.red
//    }
    
}

extension SupportInputTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        if textField == emailAddressTextField {
//            let newEmail = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//            print(newEmail)
//            return validator.isValidEmail(input: newEmail) || newEmail.isEmpty
//        } else if textField == phoneNumberTextField {
//            let newPhoneNumber = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//            return validator.isValidPhoneNumber(phoneNumber: newPhoneNumber) || newPhoneNumber.isEmpty
//        } else if textField == clientCodeTextField {
//            let newClientCode = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//                return validator.isValidClientCode(clientCode: newClientCode) || newClientCode.isEmpty
//            }
//            return true
//        }
//        
        func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailAddressTextField {
            if let email = textField.text, !validator.isValidEmail(input: email) {
                print("Invalid email format")
                textField.textColor = .red
            }
            
        } else if textField == phoneNumberTextField {
            if let phone = textField.text, !validator.isValidPhoneNumber(phoneNumber: phone) {
                print("Invalid phone number format")
                textField.textColor = .red
            }
            
        } else if textField == clientCodeTextField {
            if let code = textField.text, !validator.isValidClientCode(clientCode: code) {
                print("Invalid client code format")
                textField.textColor = .red
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor(named: "labelColor")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
