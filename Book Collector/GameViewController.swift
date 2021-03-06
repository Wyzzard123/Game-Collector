//
//  GameViewController.swift
//  Book Collector
//
//  Created by Wyz on 30/10/17.
//  Copyright © 2017 Wyz. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate { //add uiimagepickerdelegate
    var imagePicker = UIImagePickerController() //allows user to select sth from phone's library or take a new picture. Needs setup inviewdidload. Need to make imagePicker.delegate = self
    var screenshot : ScreenShot? = nil //needa set to nil. if it's nil then we're making a new game. Otherwise we pass something into the existing game property...
    
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var addUpdateButton: UIButton!
    
    @IBAction func cameraTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var screenshotImageView: UIImageView!
    
    @IBAction func addTapped(_ sender: Any) {//what happens when tap Add button. Note this still happens if you tap Update cos it's the same button!!
        
        
        
        if screenshot != nil { //this is using the variable at the top
            
            screenshot!.title = titleTextField.text
            screenshot!.image = UIImagePNGRepresentation(screenshotImageView.image!) //these two lines copied cos screenshot wasn't the local variable here! That's why need to use !
            //using this is to save the stuff and update the view controller (ie UPDATE the stuff). Below is add
            
        } else {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let screenshot = ScreenShot(context: context) //context: nsmanaged object replaced w context. the SCREENSHOT IS THE LOCAL CONSTANT
            screenshot.title = titleTextField.text
            screenshot.image = UIImagePNGRepresentation(screenshotImageView.image!) //rmb this "image" is binary data not uiimage so have to convert by converting to png or jpg
        }
        
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self //delegate to pull info. Eg a tableview needs to know what goes into each cell. ImagePicker needs to know once I get a picture where do I send it etc. Need to put on top UIImagePickerControllerDelegate and UINavigationControllerDelegate
        
        if screenshot != nil { //will add the title here etc
            screenshotImageView.image = UIImage(data: screenshot!.image as Data!) //type UIImage(d and get this. Need to convert data into image cos it's only Data in the core data now. Have to put data cos it asks for data, not NSData.  CHANGED TO ! cos of error
            titleTextField.text = screenshot?.title
            addUpdateButton.setTitle("Update", for: .normal) //for buttons as outlets, have to type SET TITLE. To get the controlstates, hit "." and you'll get a list. for now use NORMAL
        } else {
            deleteButton.isHidden = true //hides the delete Button!!
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func photosTapped(_ sender: Any) {
        
        // gonna set up image picker when tap the button photos. Need to say whether it's from photos or camera
        
        imagePicker.sourceType = .photoLibrary
        
        //type "imagePicker.sourceType = ." to get the sources for the photo. This is under when you click the photo button. photoLibrary and savedPhotosAlbum are the same thing. savedPhotoAlbum takes you to camera roll but photoLibrary goes to anywhere on the phone.
        
        
        present(imagePicker, animated: true, completion: nil)
        
        
        //present image picker in front of user so he can use it. Top one allows you to place another view controller on the screen. Completion is to ask you what you want to run but here you can say nil since it's optional. IE you dont care what happens after it's done
        
        
        //need to go to info.plist and select a new type, privacy - photo library usage. Need to give a message to the user why you need their info. Value will be a popup. This is to allow you to use.
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //didfinishpickingmedia to say what happens when the person selects the image!. Here we get a hash called "info" on what image they selected. Can see they give a dictionary with string for key and any for value
        
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //calling the value of "info" at the Original Image (ie the image they selected). As! UIImage to specify that this will give us back a UIImage. UIImage is the data around an image file that we can put into an image view
        
        
        screenshotImageView.image = image
        
        //setting the imageview image to the image we got from the image picker
        
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        //if you don't dismiss there'll be an error so you have to get rid of the imagePicker controller
    }
    //Core data notes:
    //have to put stuff with "Allows External Storage" or else the app will run super slow cos there's image (for coredata. Click shield.
    //can uncheck optional for the entities as well. Then you can't save stuff that isn't the same type
    @IBAction func deleteTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(screenshot!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
}
