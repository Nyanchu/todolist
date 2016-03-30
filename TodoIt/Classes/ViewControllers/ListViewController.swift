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
 親クラスのUIViewControllerを継承したほうが自由度が高そうだが、
 一旦UITableViewControllerを継承しておく
*/
class ListViewController : UITableViewController {
    
    var appDel: AppDelegate?
    var context: NSManagedObjectContext?
    var todos = [Todo]()
    
    // TODO: 本当はinitを使いたかったがわからず断念
    override func viewDidLoad() {
        self.appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        self.context = self.appDel!.managedObjectContext
    }
    
    /**
     読み込み開始時の処理
     - parameter animated: <#animated description#>
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let todo = self.todos[indexPath.row]
            let controller = segue.destinationViewController as! AddTodoController
            controller.editTodo = todo
        }
    }
    
    
}