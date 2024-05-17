import Foundation

class Validation {

    func isValidEmail(input: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        let result = emailPredicate.evaluate(with: input)
        return result
    }

    func isValidPhoneNumber(phoneNumber : String) -> Bool{
        let phoneFormat = #"^(?:\+88|88)?(01[3-9]\d{8})$"#
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneFormat)
        let result = phonePredicate.evaluate(with: phoneNumber)
        return result
    }

    func isValidClientCode(clientCode : String) -> Bool {
        let clientCodeFormat = "^[0-9]{6}$"
        let clientCodePredicate = NSPredicate(format:"SELF MATCHES %@", clientCodeFormat)
        let result = clientCodePredicate.evaluate(with: clientCode)
        return result
    }
}
