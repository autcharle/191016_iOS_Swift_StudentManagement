//
//  DetailViewController.swift
//  hw02
//
//  Created by Tuyen Tran on 10/15/19.
//  Copyright © 2019 Tuyen Tran. All rights reserved.
//

import UIKit

protocol UpdatingInfoDelegate
{
    func updateInfo(name: String,gender: String,birthDay: String,className: String,otherInfo: String, index: Int)
}

class DetailViewController: UIViewController
{
    var delegate : UpdatingInfoDelegate?
    var getName = String()
    var getGender = String()
    var getBDay = String()
    var getClass = String()
    var getOtherInfo = String()
    var selectedRowIdx = Int()
    var selectedIdxPath = IndexPath()
    var getImage = String()
    private var activeField: UITextField?
    private var datePicker: UIDatePicker?
    private var selectedGender: String?
    let genders = ["Male","Female"]
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var bdayTF: UITextField!
    @IBOutlet weak var classTF: UITextField!
    @IBOutlet weak var otherInfoTF: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Edit Student"
        initTextField()
        createGenderPicker()
        createDatePicker()
        createToolbar()
        nameTF.delegate = self
        classTF.delegate = self
        otherInfoTF.delegate = self
            
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
        
    func createGenderPicker()
    {
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderTF.inputView = genderPicker
            
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
            
        genderTF.inputAccessoryView = toolBar
        bdayTF.inputAccessoryView = toolBar
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
        bdayTF.inputView = datePicker
            
            //Customizations
        datePicker?.backgroundColor = .white
    }
        
    @objc func dateChanged(datePicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        bdayTF.text = dateFormatter.string(for: datePicker.date)
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
            
        if self.activeField == otherInfoTF
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
    @IBAction func editedSaveInfo(_ sender: Any)
    {
        let name: String? = nameTF.text
        let gender: String? = genderTF.text
        let birthday: String? = bdayTF.text
        let classname: String? = classTF.text
        let otherInfo: String? = otherInfoTF.text
        
        delegate?.updateInfo(name: name ?? "", gender: gender ?? "", birthDay: birthday ?? "", className: classname ?? "", otherInfo: otherInfo ?? "", index: selectedRowIdx)
        self.navigationController?.popViewController(animated: true)
    }
    
    func initTextField()
    {
        nameTF.text! = getName
        genderTF.text! = getGender
        bdayTF.text! = getBDay
        classTF.text! = getClass
        otherInfoTF.text! = getOtherInfo
        profileImg.image = UIImage(named: getImage)
    }

}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource
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
        genderTF.text = selectedGender
    }
}

extension DetailViewController: UITextFieldDelegate
{
    
}
