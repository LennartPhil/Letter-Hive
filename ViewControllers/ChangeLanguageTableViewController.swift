//
//  ChangeLanguageTableViewController.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 18.05.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "textImageCell"

class ChangeLanguageTableViewController: UITableViewController {
    
    let languages: [Language] = [.english, .german]
    
    var currentLanguage = ""
    
    var delegate: UpdateStandardLanguageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.setDefaultLanguageLabelText()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TextImageTableViewCell
        
        cell.wordLabel?.text = DeviceLanguage.translatedLanguage(language: languages[indexPath.row])
        
        if Defaults.currentStandardLanguage() == languages[indexPath.row] {
            cell.tickHidden = false
        } else {
            cell.tickHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedLanguage = languages[indexPath.row]
        
        Defaults.setStandardLanguage(language: selectedLanguage)
        
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol UpdateStandardLanguageDelegate {
    
    func setDefaultLanguageLabelText()
}
