
import UIKit

class SupportInput2TableViewCell: UITableViewCell{
    
    @IBOutlet weak var issueTypeTextField: UITextField!
    @IBOutlet weak var issueDescriptionTextView: UITextView!
    
    
    var issueTypeTappedClosure: (() -> Void)?
    var placeholderText = "Write Issue description here.."
    
    static let classname = String(describing: SupportInput2TableViewCell.self)
    static public func nib() -> UINib {
        return UINib(nibName: SupportInput2TableViewCell.classname, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        issueDescriptionTextField.delegate = self
        
        setupTextField()
        setupTextView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.endEditing(true)
    }
    
    private func setupTextField() {
        issueTypeTextField.setPlaceholder(text: "Select issue type")
        issueTypeTextField.layer.borderColor = UIColor(named: "buttonBorderColor")?.cgColor
        issueTypeTextField.layer.borderWidth = 1
        issueTypeTextField.layer.cornerRadius = 6
    
    }
    
    private func setupTextView() {
        issueDescriptionTextView.layer.borderWidth = 1
        issueDescriptionTextView.layer.borderColor = UIColor(named: "buttonBorderColor")?.cgColor
        issueDescriptionTextView.layer.cornerRadius = 6
        
        
        issueDescriptionTextView.text = placeholderText
        issueDescriptionTextView.font = UIFont.systemFont(ofSize: 16)
        issueDescriptionTextView.textColor = UIColor(named: "placeholderColor")
        issueDescriptionTextView.delegate = self
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == placeholderText {
                textView.text = ""
                textView.font = UIFont.systemFont(ofSize: 14)
                textView.textColor = UIColor(named: "labelColor")
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = placeholderText
                textView.font = UIFont.systemFont(ofSize: 16)
                textView.textColor = UIColor(named: "placeholderColor")
            }
        }
    
    @IBAction func isIssueTypeBtnTapped(_ sender: Any) {

        self.issueTypeTappedClosure?()
    }
    
    func setIssueTypeTextField(text: String) {
//        print(text)
        self.issueTypeTextField.text = text
    }

 
}


extension SupportInput2TableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SupportInput2TableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
