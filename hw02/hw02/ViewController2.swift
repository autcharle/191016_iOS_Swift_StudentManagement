//
//  ViewController2.swift
//  hw02
//
//  Created by Tuyen Tran on 10/15/19.
//  Copyright © 2019 Tuyen Tran. All rights reserved.
//

import UIKit

protocol AddingInfoDelegate
{
    func addInfo(name: String,gender: String,birthDay: String,className: String,otherInfo: String,profileImg: String)
}

class ViewController2: UIViewController
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var bdLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var bdField: UITextField!
    @IBOutlet weak var classField: UITextField!
    @IBOutlet weak var otherInfoField: UITextField!
    
    @IBOutlet weak var previewButton: UIButton!
    let genders = ["Male","Female"]
    let rand = ["unknown","bunny","dragon","chicken","shiba","unicorn","penguin","eagle","lion","fox"]
    
    private var selectedGender: String?
    
    private var datePicker: UIDatePicker?
    
    private var activeField: UITextField?
    
    private var randImg: UInt32 = 0
    
    var delegate : AddingInfoDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Add Student"
        createRandImg()
        createGenderPicker()
        createDatePicker()
        createToolbar()
        nameField.delegate = self
        classField.delegate = self
        otherInfoField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func createRandImg()
    {
        repeat
        {
            randImg = arc4random_uniform(UInt32(rand.count))
        }while(randImg == 0)
        profileImgView.image = UIImage(named: rand[Int(randImg)])
    }
    
    func createGenderPicker()
    {
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderField.inputView = genderPicker
        
        //Customizations
        genderPicker.backgroundColor = .white
    }
    
    func createToolbar()
    {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector((ViewController2.dismissKeyboard)))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        genderField.inputAccessoryView = toolBar
        bdField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func createDatePicker()
    {
        datePicker = UIDatePicker()
        
        //Generating maxdate, mindate
        let currentDate = Date()
        var comps = DateComponents()
        let calendar = Calendar(identifier: .gregorian)
        comps.year = 0
        datePicker?.maximumDate = calendar.date(byAdding: comps, to: currentDate)
        comps.year = -60
        datePicker?.minimumDate = calendar.date(byAdding: comps, to: currentDate)
        
        //Picking a date
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ViewController2.dateChanged(datePicker:)), for: .valueChanged)
        bdField.inputView = datePicker
        
        //Customizations
        datePicker?.backgroundColor = .white
    }
    
    @objc func dateChanged(datePicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        bdField.text = dateFormatter.string(for: datePicker.date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        dismissKeyboard()
        return true
    }
    
    //
    @objc func keyboardWillChange(notification: Notification)
    {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else
        {
            return
        }
        
        if self.activeField == otherInfoField
        {
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification
            {
                view.frame.origin.y = -keyboardRect.height
            }
            else
            {
                view.frame.origin.y = 0
            }
        }
        else
        {
            view.frame.origin.y = 0
        }
    }
    
    @IBAction func previewInfo(_ sender: Any)
    {
        if (nameField.text != "" )
        {
            nameLabel.text = nameField.text
        }
        if (genderField.text != "")
        {
            genderLabel.text = genderField.text
        }
        if (bdField.text != "")
        {
            bdLabel.text = bdField.text
        }
        if (classField.text != "")
        {
            classLabel.text = classField.text
        }
    }
    @IBAction func touchUp(_ sender: Any)
    {
        let name: String? = nameField.text
        let gender: String? = genderField.text
        let birthday: String? = bdField.text
        let classname: String? = classField.text
        let otherInfo: String? = otherInfoField.text
        
        delegate?.addInfo(name: name ?? "", gender: gender ?? "", birthDay: birthday ?? "", className: classname ?? "", otherInfo: otherInfo ?? "",profileImg: rand[Int(randImg)])
        self.navigationController?.popViewController(animated: true)
    }
}

extension ViewController2: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genders[row]
        genderField.text = selectedGender
    }
}

extension ViewController2: UITextFieldDelegate
{
    
}
