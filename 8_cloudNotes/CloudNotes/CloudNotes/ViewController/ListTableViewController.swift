//
//  ListTableViewController.swift
//  CloudNotes
//
//  Created by steven on 2021/05/31.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var memoList: [Memo] = []
    var lastClickedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoList = CoreDataManager.shared.fetchMemos()
        setNavigationItem()
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        self.tableView.estimatedRowHeight = 90.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let detailNavigationController = self.splitViewController?.viewControllers.last as? UINavigationController,
           let textViewController = detailNavigationController.topViewController as? TextViewController,
           memoList.count != 0 {
            // TODO: - 메모에 아무것도 없을 때도 처리해줘야 함.
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
            textViewController.changedTextBySelectedCell(with: memoList[0])
        }
    }
    
    func changeSelectedCellLabelValue(with text: String) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            return
        }
        if selectedIndexPath.row != 0 {
            let movedItem = memoList.remove(at: selectedIndexPath.row)
            memoList.insert(movedItem, at: 0)
            tableView.moveRow(at: selectedIndexPath, to: IndexPath(row: 0, section: 0))
            lastClickedIndexPath = IndexPath(row: 0, section: 0)
        } else {
            memoList[selectedIndexPath.row].title = text.subString(before: "\n")
            memoList[selectedIndexPath.row].body = text.subString(after: "\n")
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    func setNavigationItem() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTouched(_:)))
    }
     
    @objc func addBarButtonTouched(_ sender: UIBarButtonItem) {
        if let detailNavigationController = self.splitViewController?.viewControllers.last as? UINavigationController,
           let textViewController = detailNavigationController.topViewController as? TextViewController {
            textViewController.textView.text = ""
            memoList.insert(CoreDataManager.shared.makeNewMeno(), at: 0)
            tableView.performBatchUpdates({
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }, completion: nil)
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
            textViewController.changedTextBySelectedCell(with: memoList[0])
            lastClickedIndexPath = IndexPath(row: 0, section: 0)
        } else {
            let navigationEmbeddTextViewController = UINavigationController(rootViewController: TextViewController())
            self.splitViewController?.showDetailViewController(navigationEmbeddTextViewController, sender: nil)
        }
    }
    
}

extension ListTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("moverowat")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        let memoItem = memoList[indexPath.row]
        cell.titleLabel.text = memoItem.title ?? "새로운 메모"
        cell.dateLabel.text = memoItem.lastModified?.formatDate()
        cell.bodyLabel.text = memoItem.body ?? "추가 텍스트 없음"
        cell.accessoryType = .disclosureIndicator
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.systemYellow
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailNavigationController = self.splitViewController?.viewControllers.last as? UINavigationController,
           let textViewController = detailNavigationController.topViewController as? TextViewController {
            textViewController.textView.isEditable = false
            if textViewController.textView.text.isEmpty && lastClickedIndexPath != indexPath {
                memoList.remove(at: lastClickedIndexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [lastClickedIndexPath], with: .automatic)
                tableView.endUpdates()
                textViewController.changedTextBySelectedCell(with: memoList[indexPath.row - 1])
            } else {
                CoreDataManager.shared.editMemo(memo: memoList[lastClickedIndexPath.row],
                                                title: textViewController.textView.text.subString(before: "\n"),
                                                body: textViewController.textView.text.subString(after: "\n"))
                textViewController.changedTextBySelectedCell(with: memoList[indexPath.row])
            }
            textViewController.textView.isEditable = true
            lastClickedIndexPath = indexPath
        } else {
            let textViewController = TextViewController()
            let navigationController = UINavigationController(rootViewController: textViewController)
            self.splitViewController?.showDetailViewController(navigationController, sender: nil)
            textViewController.changedTextBySelectedCell(with: memoList[indexPath.row])
        }
    }
    
}

extension Date {
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
}

extension String {
    
    func subString(before: Character) -> String {
        let selectedIndex = self.firstIndex(of: before) ?? self.index(before: self.endIndex)
        print(String(self[..<selectedIndex]))
        return String(self[..<selectedIndex])
    }
    
    func subString(after: Character) -> String {
        let selectedIndex = self.firstIndex(of: after) ?? self.index(before: self.endIndex)
        let nextselectedIndex = self.index(after: selectedIndex)
        print(String(self[nextselectedIndex...]))
        return String(self[nextselectedIndex...])
    }
    
}

