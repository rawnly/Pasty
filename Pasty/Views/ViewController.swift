//
//  ViewController.swift
//  Pasty
//
//  Created by Federico Vitale on 22/05/2019.
//  Copyright © 2019 Federico Vitale. All rights reserved.
//

import Cocoa


struct PasteboardRow {
    var value:String
    var date: Date
}

class ViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBAction func onRandomStuff(_ sender: NSButton) {
        let pb = NSPasteboard.general
        
        pb.clearContents()
        pb.setString(.random, forType: .string)
    }
    
    var rows: [PasteboardRow] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onPasteboardChanged), name: .NSPasteboardDidChange, object: nil)
    }
    
    @objc
    func onPasteboardChanged(_ notification: Notification) {
        guard let pb = notification.object as? NSPasteboard else { return }
        guard let items = pb.pasteboardItems else { return }
        
        print(items.count)
        
        guard let item = items.first?.string(forType: .string) else { return }
        
        rows.append(.init(value: item, date: .now))
    }
    
    @objc
    func resetClipboard() {
        NSPasteboard.general.clearContents()
    }
}


extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var identifier: String = ""
        
        if tableView.tableColumns[0] == tableColumn {
            identifier = "DateCell"
        } else if tableView.tableColumns[1] == tableColumn {
            identifier = "ContentCell"
        }
        
        guard let cell: NSTableCellView = tableView.makeView(withIdentifier: .init(rawValue: identifier), owner: nil) as? NSTableCellView else {
            return nil
        }
        
        let pasteboardItem = rows[row]
        
        if identifier == "DateCell" {
            cell.textField?.stringValue = pasteboardItem.date.stringTimeWithSeconds
        } else {
            cell.textField?.stringValue = pasteboardItem.value
        }
        
        return cell
    }
}

extension String {
    public static var random:String {
        let alphabet = "a b c d e f g h i j k l m n o p q r s t u v z 0 1 2 3 4 5 6 7 8 9"
        var str: String = ""
        
        for _ in 1...8 {
            let letters = alphabet.split(separator: Character(" "))
            let randomIndex = Int.random(in: 0...(letters.count - 1))
            str += String(letters[randomIndex])
        }
        
        return str
    }
}
