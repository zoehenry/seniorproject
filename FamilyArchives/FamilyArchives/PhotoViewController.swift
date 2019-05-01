//
//  ViewController.swift
//  FamilyArchives
//
//  Created by Zoe Henry on 4/10/19.
//  Copyright © 2019 Zoe Henry. All rights reserved.
//

import UIKit
import os.log

class PhotoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var personEventDescriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var personEvent: PersonEvent?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        nameTextField.textColor = UIColor(red: 0.302, green: 0.1882, blue: 0.4, alpha: 1.0)
        
        personEventDescriptionTextView.delegate = self
        personEventDescriptionTextView.text = "Enter description"
        personEventDescriptionTextView.textColor = UIColor(red: 0.302, green: 0.1882, blue: 0.4, alpha: 1.0)
        personEventDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        personEventDescriptionTextView.heightAnchor.constraint(equalToConstant: 160.0).isActive = true
        personEventDescriptionTextView.widthAnchor.constraint(equalToConstant: 340.0).isActive = true
        personEventDescriptionTextView.layer.cornerRadius = 8
        
        if let personEvent = personEvent {
            navigationItem.title = personEvent.name
            nameTextField.text = personEvent.name
            photoImageView.image = personEvent.photo
            personEventDescriptionTextView.text = personEvent.personEventDescription
            personEventDescriptionTextView.textColor = UIColor(red: 0.2745, green: 0.1255, blue: 0.4, alpha: 1.0)
        }
        
        // Enable the Save button only if the text field has a valid PersonEvent name.
        updateSaveButtonState()
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = UIColor(red: 0.302, green: 0.1882, blue: 0.4, alpha: 1.0)
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Use the original image
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info)")
        }
        
        //set photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        //dismiss picker
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UITextViewDelegate
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        // Hide the keyboard.
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(red: 0.302, green: 0.1882, blue: 0.4, alpha: 1.0) {
            textView.text = nil
            textView.textColor = UIColor(red: 0.2745, green: 0.1255, blue: 0.4, alpha: 1.0)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            personEventDescriptionTextView.text = "Enter description"
            personEventDescriptionTextView.textColor = UIColor(red: 0.302, green: 0.1882, blue: 0.4, alpha: 1.0)
        } else {
            personEventDescriptionTextView.text = textView.text
            personEventDescriptionTextView.textColor = UIColor(red: 0.2745, green: 0.1255, blue: 0.4, alpha: 1.0)
        }
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddPersonEventMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPersonEventMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The PhotoViewController is not inside a navigation controller.")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let audioURL = URL(string: "")
        let personEventDescription = personEventDescriptionTextView.text ?? ""
        
        personEvent = PersonEvent(name: name, photo: photo, audioURL: audioURL, personEventDescription: personEventDescription)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        personEventDescriptionTextView.resignFirstResponder()
        
        // UIImagePickerController allows user to access photo library
        let imagePickerController = UIImagePickerController()
        
        // Starting with only uploading photos
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)

    }
    
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

