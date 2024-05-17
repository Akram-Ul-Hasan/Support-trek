
import UIKit

class IssueTypeViewController: UIViewController {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var issueTypeDoneBtn: UIButton!
    

    let option: [String] = ["Trading", "Deposit", "Withdrawal", "BO A/C Creation", "Change BO A/C Information", "Wrong Information", "Others"]
    
    var selectedIssueHandler: ((String) -> Void)?
    var selectedIssue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        issueTypeDoneBtn.layer.cornerRadius = issueTypeDoneBtn.frame.size.height / 2
        setupTableView()
        if ((selectedIssue?.isEmpty) != nil) {
            setIssueTypeDoneBtn()
        }
        
    }
    
    private func setupTableView() {
        tableView.register(IssueTypeTableViewCell.nib(), forCellReuseIdentifier: IssueTypeTableViewCell.classname)
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func issueTypeSelectDoneBtn(_ sender: Any) {
        guard let selectedValue = selectedIssue else {
            return
        }
        self.selectedIssueHandler?(selectedValue)

        self.dismiss(animated: true) {
            self.selectedIssueHandler?(selectedValue)
        }
    
    }
    func didSelectIssueType(_ type: String) {
        print("Selected Issue Type: \(type)")
    }
}

extension IssueTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IssueTypeTableViewCell.classname, for: indexPath) as? IssueTypeTableViewCell else {
            return UITableViewCell()
        }
        
        let item = option[indexPath.row]
        
        if item == selectedIssue {
            cell.configure(title: item, isSelectedItem: true)
            self.setIssueTypeDoneBtn()
        } else {
            cell.configure(title: item, isSelectedItem: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = option[indexPath.row]
        self.selectedIssue = selectedItem
        
        DispatchQueue.main.async {
            tableView.reloadData()
            
//            self.setIssueTypeDoneBtn()
            
        }
    }
    
    func setIssueTypeDoneBtn () {
        self.issueTypeDoneBtn.isSelected = true
        
        self.issueTypeDoneBtn.setTitleColor( UIColor(red: 1, green: 0, blue: 0, alpha: 1), for: .highlighted)
        self.issueTypeDoneBtn.titleLabel?.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        self.issueTypeDoneBtn.tintColor = UIColor.black
        self.issueTypeDoneBtn.subtitleLabel?.textColor = .black
        self.issueTypeDoneBtn.backgroundColor = UIColor(red: 0, green: 0.784, blue: 0.024, alpha: 1)
    }
}

