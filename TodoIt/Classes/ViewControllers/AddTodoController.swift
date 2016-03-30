//
//  AddTodoController.swift
//  TodoIt
//
//  Created by 酒井智弘 on 2016/02/22.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit
import CoreData

class AddTodoController: UIViewController, UITextViewDelegate {

    // TODOの編集時に格納される
    var editTodo:Todo?
    
    // TODOが格納されるテキストフィールド
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 自分をテキストフィールドのデリゲートに指定
        self.textView.delegate = self
        // TODOの編集だったら
        if self.editTodo != nil {
            self.textView.text = self.editTodo?.content
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Todo保存処理
     */
    func createTodo() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let todoEntity: NSEntityDescription! = NSEntityDescription.entityForName("Todo", inManagedObjectContext: context)
        let newData = Todo(entity: todoEntity, insertIntoManagedObjectContext: context)
        newData.content = self.textView.text!
        newData.register_time = NSDate()
        do {
            try context.save()
        } catch {
            print("error")
        }
    }
    
    /**
     Todo更新処理
     */
    func updateTodo() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        self.editTodo?.content = self.textView.text!
        do {
            try context.save()
        } catch {
            print ("error")
        }
    }
    
    func dismissViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     テキストフィールド以外がタッチされたらキーボードをしまう
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /**
     キーボードのreturnが押されたらキーボードをしまう
     */
    func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    /**
     ナビゲーションの「戻る」ボタン押下時
     */
    override func viewWillDisappear(animated: Bool) {
        var isReturn = true
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                // 「戻る」が押された場合はviewControllers中にselfは存在しない
                if viewController == self {
                    isReturn = false
                    break
                }
            }
        }
        // 「戻る」が押されていて、入力値があったら保存処理
        if isReturn && !self.textView.text.isEmpty {
            if self.editTodo != nil {
                updateTodo()
            } else {
                createTodo()
            }
        }
        super.viewWillDisappear(animated)
    }
    
    /**
     「完了」ボタン押下時
     */
    @IBAction func done(sender: AnyObject) {
        // 保存処理
        if self.editTodo != nil {
            updateTodo()
        } else {
            createTodo()
        }
    }

}

