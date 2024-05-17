
import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var issueTypeSelectedOption: String?
    var issueImageCollection: [PHAsset] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle()
        setupTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print(issueImageCollection.count)
    }
    
    private func setupNavigationTitle() {
//        guard let font = UIFont(name: "SFProText-Medium", size: 16) else {
//            fatalError("SF Pro Text font not found")
//        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "labelColor") ?? .label,
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.title = "Trek Support"
    }

    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SupportInputTableViewCell.nib(), forCellReuseIdentifier: SupportInputTableViewCell.classname)
        tableView.register(SupportInput2TableViewCell.nib(), forCellReuseIdentifier: SupportInput2TableViewCell.classname)
        tableView.register(SupportInput3TableViewCell.nib(), forCellReuseIdentifier: SupportInput3TableViewCell.classname)
    }
    
    private func handleIssueTypeTapped() {
        
        guard let viewControllerToPresent = storyboard?.instantiateViewController(withIdentifier: "IssueTypeViewController") as? IssueTypeViewController else {
            return
        }
        
        if let issue = self.issueTypeSelectedOption {
            viewControllerToPresent.selectedIssue = issue
        }
        
        viewControllerToPresent.selectedIssueHandler = { [weak self] selectedOption in
            if selectedOption != self?.issueTypeSelectedOption {
                self?.issueImageCollection = []
                self?.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                
                self?.issueTypeSelectedOption = selectedOption
                
                let cell = self?.tableView.dequeueReusableCell(withIdentifier: SupportInput2TableViewCell.classname) as! SupportInput2TableViewCell
                
                cell.setIssueTypeTextField(text: selectedOption)
                self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
            
            
        }
        
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [ .medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        
        
        self.navigationController?.present(viewControllerToPresent, animated: true)
//        self.navigationController?.present(viewControllerToPresent, animated: true, completion: {
//            <#code#>
//        })
    }
    
    func attachImageFromGallery() {
        guard let viewControllerToPresent = storyboard?.instantiateViewController(withIdentifier: "AllPhotosViewController") as? AllPhotosViewController else {
            return
        }
        
        viewControllerToPresent.maxImageLimit = 5 - self.issueImageCollection.count
        viewControllerToPresent.didSelectedImages = { [weak self] asset in
            
            guard let self = self else { return }
            self.issueImageCollection.append(contentsOf: asset)
                        
            updateTableView()
        }
        
        let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true, completion: nil)

    }
    
    private func updateTableView () {
//        print("animated from view controller")
        UIView.transition(with: self.tableView, duration: 0.35, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }, completion: nil)

    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SupportInputTableViewCell.classname, for: indexPath) as? SupportInputTableViewCell else {
                return UITableViewCell()
            }
            return cell
            
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SupportInput2TableViewCell.classname, for: indexPath) as? SupportInput2TableViewCell else {
                return UITableViewCell()
            }
            cell.issueTypeTappedClosure = {
                self.handleIssueTypeTapped()
            }
            cell.issueTypeTextField.text = self.issueTypeSelectedOption

            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SupportInput3TableViewCell.classname, for: indexPath) as? SupportInput3TableViewCell else {
                return UITableViewCell()
            }
            cell.configure(imageAssetCollection: self.issueImageCollection)
            
            cell.isAttachImagesViewClicked = { [weak self] in
                self?.attachImageFromGallery()
                

            }
            
            cell.isIssueImagesAssetRemoved = { index in
                self.issueImageCollection.remove(at: index)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            return cell
        }
    }
    
}
