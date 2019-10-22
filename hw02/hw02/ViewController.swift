//
//  ViewController.swift
//  hw02
//
//  Created by Tuyen Tran on 10/15/19.
//  Copyright © 2019 Tuyen Tran. All rights reserved.
//

import UIKit
class Student
{
    var name = ""
    var gender = ""
    var birthday = ""
    var classname = ""
    var otherInfo = ""
}

class ViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var stdList : [Student] = []
    var imgList : [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Students"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?)
    {
        if segue.identifier == "editInfo"
        {
            let editView = segue.destination as! ViewController2
            editView.delegate = self
        }
    }
}

extension ViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stdList.count;
    }
    
    private func numberOfSections(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbViewCell", for: indexPath)
        let std = stdList[indexPath.row]
        cell.textLabel?.text = " \(std.name) (\(std.gender))"
        cell.detailTextLabel?.text = "Birthday: \(std.birthday)\nClass: \(std.classname)\nOther Info: \(std.otherInfo)"
        //

            cell.imageView?.image = UIImage(named: imgList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.getName = stdList[indexPath.row].name
        vc?.getGender = stdList[indexPath.row].gender
        vc?.getBDay = stdList[indexPath.row].birthday
        vc?.getClass = stdList[indexPath.row].classname
        vc?.getOtherInfo = stdList[indexPath.row].otherInfo
        vc?.selectedRowIdx = indexPath.row
        vc?.selectedIdxPath = indexPath
        vc?.getImage = imgList[indexPath.row]
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ViewController : AddingInfoDelegate
{
    func addInfo(name: String,gender: String,birthDay: String,className: String,otherInfo: String,profileImg: String)
    {
        let std = Student()
        std.name = name
        std.gender = gender
        std.birthday = birthDay
        std.classname = className
        std.otherInfo = otherInfo
        stdList.append(std)
        imgList.append(profileImg)
        tableView.reloadData()
    }
}

extension ViewController : UpdatingInfoDelegate
{
    func updateInfo(name: String,gender: String,birthDay: String,className: String,otherInfo: String, index: Int)
    {
        stdList[index].name = name
        stdList[index].gender = gender
        stdList[index].birthday = birthDay
        stdList[index].classname = className
        stdList[index].otherInfo = otherInfo
        tableView.reloadData()
    }
}
