//
//  ViewController.swift
//  Book Collector
//
//  Created by Wyz on 29/10/17.
//  Copyright © 2017 Wyz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var screenshots : [ScreenShot] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) { //every  time vc is abt to be shown
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {screenshots = try context.fetch(ScreenShot.fetchRequest())
            tableView.reloadData()
        } catch {
            
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenshots.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let screenshot = screenshots[indexPath.row]
        cell.textLabel?.text = screenshot.title
        cell.imageView?.image = UIImage(data: screenshot.image as Data!) //type UIImage(d and get this. Need to convert data into image cos it's only Data in the core data now. Have to put data cos it asks for data, not NSData.
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let screenshot = screenshots[indexPath.row]
        performSegue(withIdentifier: "screenshotSegue", sender: screenshot)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! GameViewController
        nextVC.screenshot = sender as? ScreenShot
        
    }
    
}

