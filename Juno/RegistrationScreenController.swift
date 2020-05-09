///
//  RegistrationScreenController.swift
//  Juno
//
//  Created by Nobel Gebru on 4/14/20.
//  Copyright © 2020 Nobel Gebru. All rights reserved.
//
import UIKit
import Parse

class RegistrationScreenController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var usernamefield: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    let datePicker = UIDatePicker()
    let manager = CLLocationManager()
    var date: Date!
    
    var zodiac = Zodiac()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupButton.isEnabled = true
        
        manager.delegate = self
        
        usernamefield.delegate = self
        passwordField.delegate = self
        nameField.delegate = self
        dobField.delegate = self
        
        usernamefield.returnKeyType = UIReturnKeyType.done
        passwordField.returnKeyType = UIReturnKeyType.done
        nameField.returnKeyType = UIReturnKeyType.done
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
        
        let camTap = UITapGestureRecognizer(target: self, action:#selector(self.onTap))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(camTap)
        
        showDatePicker()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        hideKeyboard();
        return true
    }
    
    func hideKeyboard() {
        usernamefield.resignFirstResponder()
        passwordField.resignFirstResponder()
        nameField.resignFirstResponder()
        dobField.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height + 100
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        dobField.inputAccessoryView = toolbar
        dobField.inputView = datePicker

     }

     @objc func doneDatePicker(){

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = TimeZone(abbreviation: "GMT")

        
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = datePicker.date.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        date = Date(timeIntervalSince1970: timezoneEpochOffset)
        
        dobField.text = formatter.string(from: date)
        
        self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
     }

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onSignup(_ sender: Any) {
        
        signupButton.isEnabled = false
        
        manager.requestWhenInUseAuthorization()
        createUser()
        
//
//        let username = usernamefield.text!
//        let password = passwordField.text!
//
//        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
//            if user != nil {
//                self.getUserProfile()
//                self.performSegue(withIdentifier: "loginSegue", sender: nil)
//            } else {
//                print("Error: \(error?.localizedDescription)")
//            }
//        }
    }
    
    func createUser() {
        let user = PFUser()
        user.username = usernamefield.text
        user.password = passwordField.text

        user.signUpInBackground { (success, error) in
            if success {
               self.createProfile()
               print("signup")
            } else {
               print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @objc func onTap(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if imageView.image != nil {
            alert.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: {
                action in
                self.imageView.image = nil
            }))
        }
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func createProfile() {
        let profile = PFObject(className: "Profile")
        
//        let formatter = DateFormatter()
//        formatter.timeZone = .current
        
//        let birthDate = DateFormatter().date(from: date)
        
//        manager.requestLocation()
//        print(date)
        profile["name"] = nameField.text
        profile["owner"] = PFUser.current()!
        profile["dob"] = date
        profile["sign"] = getZodiacSign(dob: date)
        profile["likes"] = Array<String>()
        profile["dislikes"] = Array<String>()
        profile["matches"] = 0
        profile["interest"] = "everyone"
        profile["identity"] = "everyone"
        if imageView.image != nil {
            let imageData = imageView.image!.pngData()
            let file = PFFileObject(name:"image.png", data: imageData!)
            
            profile["profilePhoto"] = file
        }
        
        PFGeoPoint.geoPointForCurrentLocation{ (point, error) in
            if error == nil {
                profile["location"] = point
                
                profile.saveInBackground { (success, error) in
                    if success {
                        self.getUserProfile()
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    } else {
                        print (error)
                    }
                }
                
            } else {
                print (error)
            }
        }
    }
    
    func getZodiacSign(dob: Date) -> String {
        let calendar = Calendar.current
        var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dob)
        component.year = 2020
        print(Calendar.current.date(from: component)!)
        return zodiac.getSunSign(date: Calendar.current.date(from: component)!)
    }
    
    func getUserProfile() {
        
        let user = PFUser.current()
        let query = PFQuery(className: "Profile")
        query.includeKey("owner")
        
        query.whereKey("owner", equalTo: user).findObjectsInBackground{(prof, error) in
            if prof != nil {
                Global.shared.userProfile = prof![0]
            } else {
                print("no posts")
            }
        }
    }
    
//    loc
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if CLLocationManager.locationServicesEnabled() {
//            switch CLLocationManager.authorizationStatus() {
//                case .notDetermined, .restricted, .denied:
//                    let alert = UIAlertController(title: "Enable Location Services", message: "Location authorization is required.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
//                        action in alert.dismiss(animated: true, completion: nil)
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                    signupButton.isEnabled = true
//                case .authorizedAlways, .authorizedWhenInUse:
//                    createUser()
//                @unknown default:
//                break
//            }
//            } else {
//                print("Location services are not enabled")
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        if CLLocationManager.locationServicesEnabled() {
//            switch CLLocationManager.authorizationStatus() {
//                case .notDetermined, .restricted, .denied:
//                    let alert = UIAlertController(title: "Enable Location Services", message: "Location authorization is required.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
//                        action in alert.dismiss(animated: true, completion: nil)
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                    signupButton.isEnabled = true
//                case .authorizedAlways, .authorizedWhenInUse:
//                    createUser()
//                @unknown default:
//                break
//            }
//            } else {
//                print("Location services are not enabled")
//        }
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
