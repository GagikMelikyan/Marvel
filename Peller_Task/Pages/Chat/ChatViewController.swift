//
//  ChatViewController.swift
//  Peller_Task
//
//  Created by User on 12/19/19.
//  Copyright © 2019 GagikMelikyan. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var character: Character?
    
    var userAnswers = ["User message 1", "User message 2", "User message 3", "User message 4", "User message 5", "User message 6"]
    var characterAnswers = ["Character message 1", "Character message 2", "Character message 3", "Character message 4", "Character message 5", "Character message 6"]
    var messages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCells(names: [CharacterMessageTableViewCell.id, UserMessageTableViewCell.id])
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        
        if let archiveMessages = UserDefaults.standard.array(forKey: String(character!.id)) as? [String] {
            messages = archiveMessages
        } else {
            messages.append("Hello I am \(character?.name ?? "")")
        }
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configTextView() {
        textView.delegate = self
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8
        textView.textContainer.maximumNumberOfLines = 5
        textView.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    //MARK: Keybord open & close
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardHeight: CGFloat?
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            
        }
        self.textViewBottomConstraint.constant = keyboardHeight ?? 350
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.textViewBottomConstraint.constant = 10
        self.view.layoutIfNeeded()
        
    }
    
    //MARK: TextView Rows Count
    func adjustUITextViewHeight(arg : UITextView) {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    //MARK: TextView should Return
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            if textView.text == "" {
                textView.becomeFirstResponder()
            } else {
                sendMessage()
            }
        }
        return true
    }
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CharacterMessageTableViewCell.id, for: indexPath) as! CharacterMessageTableViewCell
            
            cell.message.text = messages.reversed()[indexPath.row]
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UserMessageTableViewCell.id, for: indexPath) as! UserMessageTableViewCell
            
            cell.message.text = messages.reversed()[indexPath.row]
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
    }
    
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userAnswers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCollectionViewCell.id, for: indexPath) as! AnswerCollectionViewCell
        cell.answerButton.setTitle(userAnswers[indexPath.row], for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        addUserAnser(text: userAnswers[indexPath.row])
    }
    
    //MARK: Actions
    @IBAction func goToBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessage() {
        if textView.text != "" {
            addUserAnser(text: textView.text)
        }
    }
    
    //MARK: User Message
    private func addUserAnser(text: String) {
        view.isUserInteractionEnabled = false
        textView.text = ""
            
        messages += [text, ""]
        tableView.reloadData()
        answerToUser()

    }
    
    //MARK: Character Message
    private func answerToUser() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            let number = Int.random(in: 0 ..< self.characterAnswers.count)
            self.messages.removeLast()
            self.messages.append(self.characterAnswers[number])
            self.saveMessagesAndReloadTableView()
        }
    }
    
    //MARK: Save messages & Reload TableView
    func saveMessagesAndReloadTableView() {
        UserDefaults.standard.set(messages, forKey: String(character!.id))
         
        self.tableView.reloadData()
        self.view.isUserInteractionEnabled = true
        
    }
    
}
