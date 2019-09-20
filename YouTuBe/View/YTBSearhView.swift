//
//  YTBSearhView.swift
//  YouTuBe
//
//  Created by Max xie on 2019/9/20.
//

import UIKit

class YTBSearhView: UIView {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var suggestions = [String]()
    
    
    
    @IBAction func hideSearch(_ sender: Any) {
        inputTextField.text = ""
        suggestions.removeAll()
        tableView.isHidden = true
        inputTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
    }
}

extension YTBSearhView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! YTBSearchCell
        cell.resultLabel.text = suggestions[indexPath.row]
        return cell
    }
}

extension YTBSearhView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextField.text = self.suggestions[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension YTBSearhView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideSearch(self)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = inputTextField.text else {
             suggestions.removeAll()
            tableView.isHidden = true
            return true
        }
        let netText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet())!
        let url = URL.init(string: "https://api.bing.com/osjson.aspx?query=\(netText)")!
        let _  = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let weakSelf = self else {
                return
            }
            if error == nil {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    let data = json as! [Any]
                    DispatchQueue.main.async {
                        weakSelf.suggestions = data[1] as! [String]
                        if weakSelf.suggestions.count > 0 {
                            weakSelf.tableView.reloadData()
                            weakSelf.tableView.isHidden = false
                        } else {
                            weakSelf.tableView.isHidden = true
                        }
                    }
                }
            }
        }).resume()
        return true
    }
    
}

class YTBSearchCell: UITableViewCell {
    @IBOutlet weak var resultLabel: UILabel!
    
}
