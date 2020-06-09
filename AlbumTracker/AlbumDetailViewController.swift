//
//  AlbumDetailViewController.swift
//  AlbumTracker
//
//  Created by Zachary Long on 6/7/20.
//  Copyright © 2020 Zachary Long. All rights reserved.
//

import UIKit
import os.log

class AlbumDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var recordLabelTextField: UITextField!
    @IBOutlet weak var trackListTextField: UITextView!
    
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal(album).
     */
    var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        
        //Set up views if editing an existing album
        if let album = album {
            navigationItem.title = album.name + ", " + album.artist
            nameTextField.text = album.name
            photoImageView.image = album.photo
            //rest of the data here
            artistTextField.text = album.artist
            yearTextField.text = album.year
            recordLabelTextField.text = album.recordLabel
            trackListTextField.text = album.trackList
        }
        
        //Placeholder text for the UITextView
        if trackListTextField.text.isEmpty {
            trackListTextField.text = "Enter Track Listing"
            trackListTextField.textColor = UIColor.lightGray
        }
        
        //Enable the save button only if the text field has a valid name
        updateSaveButtonState()

        
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the save button while editing
        saveButton.isEnabled = false
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user cancelled
        dismiss(animated: true, completion: nil)
    }
    
     //imagePicker from the apple tutorial
     
    //Original method with the red fix button
    //private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //Change from String to UIImagePickerController.InfoKEy seems to fix it
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //the info may include multiple references
        /*
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
         */
        
        //Original tutorial version
        //let selectedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        //Fix with changing String to InfoKey so don't need raw value any more
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //set photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        //Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        //Depending on the style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways
        
        let isPresentingInAddAlbumMode = presentingViewController is UINavigationController
        
        if isPresentingInAddAlbumMode {
            dismiss(animated: true, completion: nil)
        }
        
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        
        else {
            fatalError("The AlbumViewController is not inside a navigation controller.")
        }
        
        //dismiss(animated: true, completion: nil)
    }
    
    
    //This method configures the view controller before it's presented
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        super.prepare(for: segue, sender: sender)
    
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
    
    let name = nameTextField.text ?? ""
    let photo = photoImageView.image
    let artist = artistTextField.text ?? ""
    let year = yearTextField.text ?? ""
    let recordLabel = recordLabelTextField.text ?? ""
    let trackList = trackListTextField.text ?? ""
    
    //Set the album object to be passed to AlbumTableViewController after the unwind segue
    album = Album(name: name, artist: artist, year: year, recordLabel: recordLabel, photo: photo, trackList: trackList)
    
    
    }

    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        //Disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    //Helper function to make a placeholder for the UITextView
    //https://stackoverflow.com/questions/27652227/how-can-i-add-placeholder-text-inside-of-a-uitextview-in-swift
    func textViewDidBeginEditing(_ textView: UITextView) {
        if trackListTextField.textColor == UIColor.lightGray {
            trackListTextField.text = nil
            trackListTextField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if trackListTextField.text.isEmpty {
            trackListTextField.text = "Enter Track Listing"
            trackListTextField.textColor = UIColor.lightGray
        }
    }
    
    
}
