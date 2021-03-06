//
//  ViewController.swift
//  DebtorsAndSponsors
//
//  Created by Darya Kuliashova on 5/22/19.
//  Copyright © 2019 Darya Kuliashova. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var friends = [Friend]()
    var refunds = [Refund]()
    
    lazy var totalExpenses: Float = {
        return friends.map { $0.amountSpent }.reduce(0, +)
    }()
    
    lazy var averageSpentByFriend: Float = {
        return totalExpenses / Float(friends.count)
    }()
    
    lazy var debtors: [Friend] = {
        friends.filter { $0.amountSpent < averageSpentByFriend }
    }()
    
    lazy var sponsors: [Friend] = {
        friends.filter { $0.amountSpent > averageSpentByFriend }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - IBActions
    
    @IBAction func onAddButton(_ sender: UIButton!) {
        showAlertViewController()
    }
    
    @IBAction private func calculateRefund(_ sender: UIButton!) {
        performCalculations()
        navigateToDetailsVC()
    }
    
    // MARK: - FUNCTIONS
    
    @objc private func navigateToDetailsVC() {
        guard let controller = UIStoryboard.mainStoryboard?.instantiateVC(DetailsViewController.self) else {
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showAlertViewController() {
        let alert = UIAlertController(title: TextConstants.fillInAlertTitle, message: "", preferredStyle: .alert)
        
        alert.addTextField { nameTextField in
            nameTextField.placeholder = TextConstants.enterFriendName
            nameTextField.autocapitalizationType = .sentences
            nameTextField.keyboardType = .default
        }
        
        alert.addTextField { amountTextField in
            amountTextField.placeholder = TextConstants.enterAmountSpent
            amountTextField.keyboardType = .decimalPad
            amountTextField.delegate = self
        }
        
        let doneAction = UIAlertAction(title: TextConstants.done, style: .default) { _ in
            let name = alert.textFields?.first?.text ?? ""
            let amount = alert.textFields?[1].text ?? ""
            
            if name.isEmpty || amount.isEmpty {
                UIAlertController.showAlert(title: TextConstants.error,
                                            message: TextConstants.emptyFieldsError,
                                            controller: self) { [weak self] in
                                                guard let self = self else {
                                                    return
                                                }
                                                self.showAlertViewController()
                }
                return
            }
            let newFriend = Friend(name: name, amountSpent: Float(amount) ?? 0.0)
            self.friends.append(newFriend)
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: TextConstants.cancel, style: .cancel) { _ in
        }
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func performCalculations() {
        debtors.forEach { debtor in
            while debtor.amountSpent < averageSpentByFriend {
                let deptorLeftover = averageSpentByFriend - debtor.amountSpent
                
                guard let sponsor = sponsors.first(where: { $0.amountSpent > averageSpentByFriend }) else { return }
                
                let sponsorLeftover = sponsor.amountSpent - averageSpentByFriend
                
                let needToReturn = min(deptorLeftover, sponsorLeftover)
                let roundedReturn = (needToReturn*100).rounded() / 100
                
                let refund = Refund(who: debtor, toWhom: sponsor, amount: roundedReturn)
                refunds.append(refund)
                
                debtor.amountSpent += roundedReturn
                sponsor.amountSpent -= roundedReturn
            }
        }
        showAlertIfNumOfFriendsLessThanThree()
    }
    
    private func showAlertIfNumOfFriendsLessThanThree(){
        if friends.count <= 2 {
            UIAlertController.showAlert(title: TextConstants.error, message: TextConstants.enterThreeNames, controller: self)
        }
    }
}

extension CalculatorViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn:"0123456789") //TODO: when pasting a String value, it's still possible to insert it
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

// MARK: - UITableViewDataSource

extension CalculatorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.cellLabel.text = "\(friends[indexPath.row].name) " + "spent " + "\(friends[indexPath.row].amountSpent)"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friends.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .bottom)
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate

extension CalculatorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: TextConstants.edit, handler: { (action, indexPath) in
            print("edit pressed")
            // TODO: add editing
        })
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: TextConstants.delete, handler: { (action, indexPath) in
            print("delete pressed")
            // TODO: add deletion
        })
        return [editAction, deleteAction]
    }
}
