//
//  AlbumListViewController.swift
//  Support
//
//  Created by Akram Ul Hasan on 9/5/24.
//

import UIKit

class AlbumListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var optionTitles: [String] = []


    var isPresent: ((Bool) -> Void)?
    var selectedOption: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isPresent?(true)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isPresent?(false)
    }
    
    private func setupTableView() {
        tableView.register(SingleAlbumTitleTableViewCell.nib(), forCellReuseIdentifier: SingleAlbumTitleTableViewCell.classname)
        tableView.dataSource = self
        tableView.delegate = self
            
    }
}

extension AlbumListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleAlbumTitleTableViewCell.classname, for: indexPath) as? SingleAlbumTitleTableViewCell else {
            return UITableViewCell()
        }
        let selectedItem = optionTitles[indexPath.row]
        
        cell.configure(title: selectedItem, isSelectedTitle: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedAlbumTitle = optionTitles[indexPath.row]
        selectedOption?(selectedAlbumTitle)
//        delegate?.didSelectAlbum(albumTitle: selectedAlbumTitle)
        
        dismiss(animated: true, completion: nil)
            
    }
}

protocol AlbumMenuDelegate: AnyObject {
    func didSelectAlbum(albumTitle: String?)
}
