//
//  ListViewController.swift
//  TodoIt
//
//  Created by 酒井智弘 on 2016/02/16.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit
import CoreData

/*
 TODO一覧表示コントローラ

 TODO: UIViewControllerを継承したほうが自由度が高そう
*/
class ListViewController : UITableViewController {
    
    var appDel: AppDelegate?
    var context: NSManagedObjectContext?
    var todos = [Todo]()
    
    /**
     初期化
     TODO: 本当はinit()を使いたかったがよくわからず一旦viewDidLoad()で
    */
    override func viewDidLoad() {
        self.appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        self.context = self.appDel!.managedObjectContext
        
        // 長押し時のイベント設定
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "editTodos:")
        longPressGesture.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    /**
      編集モード切り替え
     */
    @IBAction func editTodos(sender: UILongPressGestureRecognizer) {
        if editing {
            super.setEditing(false, animated: true)
            tableView.setEditing(false, animated: true)
        } else {
            // TOOD: 「+」ボタンを「完了」ボタンに切り替え、「完了」ボタンを押したら編集モード終了としたい
            super.setEditing(true, animated: true)
            tableView.setEditing(true, animated: true)
        }
    }
    
    /**
     TODO一覧データ読み込み
     */
    override func viewWillAppear(animated: Bool) {
        self.todos = [Todo]()
        
        let todoRequest = NSFetchRequest(entityName: "Todo")
        todoRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try self.context!.executeFetchRequest(todoRequest) as! [Todo]
            // TODOリスト読み込み
            for todo in results {
                self.todos.append(todo);
            }
        } catch {
            print ("error")
        }
        
        super.viewWillAppear(animated)
        // 画面表示更新
        self.tableView.reloadData()
    }
    
    // テーブルの件数セット
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }
    // テーブルのコンテンツセット
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodoCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.todos[indexPath.row].content
        return cell
    }
    // テーブルの並び替え設定
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // 全てのセルが並び替え可能
        return true
    }
    
    /**
     並び替えられた後の挙動
     TODO: 仮でまだ動いていない
     */
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let targetTitle = self.todos[sourceIndexPath.row]
        if let index = self.todos.indexOf(targetTitle) {
            self.todos.removeAtIndex(index)
            self.todos.insert(targetTitle, atIndex: destinationIndexPath.row)
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 削除が押された時の挙動
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            // 削除
            self.context!.deleteObject(self.todos[indexPath.row] as NSManagedObject)
            do {
                try self.context!.save()
            } catch {
                print ("error")
            }
            // リストからも削除しておく
            self.todos.removeAtIndex(indexPath.row)
            
            // 画面リロード
            self.tableView.reloadData()
        }
    }
    
    /**
     TODOが押されたらAddTodoControllerに遷移
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let todo = self.todos[indexPath.row]
            let controller = segue.destinationViewController as! AddTodoController
            controller.editTodo = todo
        }
    }
    
    
}