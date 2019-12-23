//
//  ViewController.swift
//  Peller_Task
//
//  Created by User on 12/19/19.
//  Copyright © 2019 GagikMelikyan. All rights reserved.
//

import UIKit
import STWebImage

class CharactersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private let limit = 30
    
    private var activityView = UIView()
    private var characters = [Character]()
    private var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCharacters()
        navigationController?.navigationBar.isHidden = true
        tableView.registerCells(names: [CharacterTableViewCell.id])
    }
    
    //MARK: GET Characters from DataProvider
    func getCharacters() {
        openActivityIndicator()
        
        UIApplication.appDelegate.dataProvider.getCharacters(limit: limit, offset: offset) { [weak self] (characters) in
            if characters != nil {
                self?.offset += 30
                self?.characters += characters!

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.closeActivityIndicator()
                }
                
            }
        }
    }
    
    //MARK: Open and close ACTIVITY INDICATOR
    func openActivityIndicator()  {
        activityIndicator.color = .systemYellow
        activityView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(activityView)
        activityView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 0.5)
        activityView.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
    }
    
    func closeActivityIndicator()  {
         activityView.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    
    
    
    //MARK: Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.id, for: indexPath) as! CharacterTableViewCell
        cell.characterName.text = characters[indexPath.row].name        
        
        cell.characterImg.st_setImage(withUrl: characters[indexPath.row].imgPath,  displayType: STImageViewDisplayType.fadeIn)
        if indexPath.row == characters.count - 1 {
            getCharacters()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            tableView.deselectRow(at: indexPath, animated: false)
        })

        let vc = storyboard!.instantiateViewController(withIdentifier:
            ChatViewController.id) as! ChatViewController
        vc.character = characters[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}




