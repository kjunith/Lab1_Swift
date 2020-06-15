//
//  SettingsViewController.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-06-11.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    // MARK: -- PROPERTIES
    
    private var buttons = UIStackView()
    let imagePicker = UIImagePickerController()
    
    // MARK: -- OUTLETS
    
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var labelSettings: UILabel!
    @IBOutlet weak var labelPicture: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelRequired: UILabel!
    
    @IBOutlet weak var viewPictureMask: UIView!
    @IBOutlet weak var imagePicture: UIImageView!
    @IBOutlet weak var buttonCamera: UIButton!
    @IBOutlet weak var buttonGallery: UIButton!
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    
    
    // MARK: -- VIEW CONTROLLER
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewBackground.layer.cornerRadius = 16
        self.viewBackground.layer.masksToBounds = true
        
        self.viewPictureMask.layer.cornerRadius = 4
        self.viewPictureMask.layer.masksToBounds = true
        
        self.imagePicture.mask = viewPictureMask
        
        setupContent()
        setupButtons()
    }
    
    
    // MARK: -- SETUP LABLES
    
    func setupContent() {
        let labels:[UILabel] = [labelSettings, labelPicture, labelUsername, labelEmail, labelFirstName, labelLastName, labelRequired]
        
        for label in labels {
            label.font = label.font.bold
            label.shadowOffset = CGSize(width: 2, height: 2)
            label.shadowColor = UIColor.black
        }
        
        let buttons:[UIButton] = [buttonCamera, buttonGallery]
        
        for button in buttons {
            button.backgroundColor = UIColor(named: "colorYellow")
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            button.layer.shadowColor = UIColor.black.cgColor
            button.tintColor = UIColor(named: "colorBrown")
        }
        
        textFieldUsername.placeholder = "Username"
        textFieldEmail.placeholder = "E-Mail"
        textFieldFirstName.placeholder = "First Name"
        textFieldLastName.placeholder = "Last Name"
        
        self.textFieldUsername.text = Profile.data.userName
        self.textFieldEmail.text = Profile.data.email
        self.textFieldFirstName.text = Profile.data.firstName
        self.textFieldLastName.text = Profile.data.lastName
        self.imagePicture.image = UIImage(data: Profile.data.picture)
    }
    
    
    // MARK: -- SETUP BUTTONS
    
    func setupButtons() {
        buttons = UIStackView(arrangedSubviews: createButtons(named: "SAVE", "BACK"))
        
        buttons.translatesAutoresizingMaskIntoConstraints = false
        buttons.axis = .horizontal
        buttons.spacing = 8
        buttons.distribution = .fillEqually
        
        viewMenu.addSubview(buttons)
    }
    
    func createButtons(named: String...) -> [Button] {
        return named.map { name in
            let button = Button()
            button.setTitle(name, for: .normal)
            button.configure()
            if button.titleLabel?.text == "SAVE" {
                button.setTitleColor(UIColor(named: "colorGreen"), for: .normal)
                button.setTitleColor(UIColor(named: "colorGreenDark"), for: .highlighted)
            }
            
            button.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .touchUpInside)
            return button
        }
    }
    
    @objc func buttonPressed(sender: Button!) {
        if let title:String = sender.titleLabel!.text {
            switch title {
            case "SAVE":
                if !userNameEmpty() {
                    Profile.data.userName = self.textFieldUsername.text!
                    Profile.data.email = self.textFieldEmail.text!
                    Profile.data.firstName = self.textFieldFirstName.text!
                    Profile.data.lastName = self.textFieldLastName.text!
                    Profile.data.picture = imagePicture.image!.pngData()!
                    
                    Profile.data.saveData()
                    showAlertDialog(title: "Saved", message: "Settings has been saved")
                } else {
                    showAlertDialog(title: "Error", message: "Username can not be empty!")
                }
            case "BACK":
                dismiss(animated: true, completion: nil)
            default:
                print("No button found")
                return
            }
        }
    }
    
    func userNameEmpty() -> Bool {
        if textFieldUsername.text != "" {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func onUsernamePressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onEmailPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onFirstnamePressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onLastnamePressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // MARK: -- CAMERA
    
    @IBAction func onCameraPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            showAlertDialog(title: "Error", message: "This device does not seem to have a camera!")
        }
    }
    
    @IBAction func onGalleryPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePicture.image = image
    }
    
    
    // MARK: -- ALERT
    
    func showAlertDialog(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch title {
        case "Saved":
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in
                                            self.dismiss(animated: true, completion: nil)
            }))
        case "Error":
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .destructive,
                                          handler: nil))
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
