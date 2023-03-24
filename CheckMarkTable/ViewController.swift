//
//  ViewController.swift
//  CheckMarkTable
//
//  Created by Dastan on 13/3/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private lazy var aTableView: UITableView = {
        let a = UITableView()
        a.dataSource = self
        a.delegate = self
        a.register(ATableVeiwCell.self, forCellReuseIdentifier: "cell")
        a.rowHeight = 60
        a.backgroundColor = .clear
        
        return a
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.backgroundColor = color
        button.clipsToBounds = true
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.titleLabel?.textAlignment = .center
        
        return button
    }()
    
    @objc func addButtonTapped() {
        addNewTitleAlert()
    }
    
    private lazy var colorButton: UIButton = {
        let c = UIButton()
        c.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        c.backgroundColor = color
        c.clipsToBounds = true
        c.setTitle("...", for: .normal)
        c.setTitleColor(.black, for: .normal)
        c.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        c.titleLabel?.textAlignment = .center
        
        return c
    }()
    
    @objc func colorButtonTapped() {
        colorDetail.isHidden.toggle()
        colorRed.isHidden.toggle()
        colorGreen.isHidden.toggle()
        colorBlue.isHidden.toggle()
        colotBool.toggle()
        if colotBool == true {
            colorButton.backgroundColor = self.color
        } else if colotBool == false {
            colorButton.backgroundColor = UIColor.darkGray
        }
    }
    
    var colotBool = true
    var color = UIColor.systemYellow
    
    private lazy var colorDetail: UIView = {
        let d = UIView()
        d.isHidden = true
        d.layer.cornerRadius = 10
        d.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        return d
    }()
    
    private lazy var colorRed: UILabel = {
        let k = UILabel()
        k.text = "Red"
        k.textColor = .white
        k.font = UIFont.systemFont(ofSize: 20)
        k.isUserInteractionEnabled = true
        k.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(redTapped))
        k.addGestureRecognizer(tap)
        
        return k
    }()
    
    @objc func redTapped() {
        addButton.backgroundColor = .systemRed
        color = UIColor.systemRed
        saveColor()
        reloadData()
    }
    
    private lazy var colorGreen: UILabel = {
        let k = UILabel()
        k.text = "Green"
        k.textColor = .white
        k.font = UIFont.systemFont(ofSize: 20)
        k.isUserInteractionEnabled = true
        k.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(greenTapped))
        k.addGestureRecognizer(tap)
    
        return k
    }()
   
    
    @objc func greenTapped() {
        color = UIColor.systemGreen
        addButton.backgroundColor = .systemGreen
        saveColor()
        reloadData()
    }
    
    private lazy var colorBlue: UILabel = {
        let k = UILabel()
        k.text = "Blue"
        k.textColor = .white
        k.font = UIFont.systemFont(ofSize: 20)
        k.isUserInteractionEnabled = true
        k.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(blueTapped))
        k.addGestureRecognizer(tap)
        
        return k
    }()
    
    @objc func blueTapped() {
        color = UIColor.systemBlue
        addButton.backgroundColor = .systemBlue
        saveColor()
        reloadData()
    
    }
    
    var aidar = "ne gey"
    
    private func addNewTitleAlert() {
        colorDetail.isHidden = true
        colorRed.isHidden = true
        colorGreen.isHidden = true
        colorBlue.isHidden = true
        colotBool = true
        colorButton.backgroundColor = self.color
        let alert = UIAlertController(title: "Добавить запись", message: nil, preferredStyle: .alert)
        var newText = UITextField()
        
        alert.addTextField { (textField) in
            newText = textField
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .default) { (action) in
        }
        
        let sendAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            guard let text = newText.text else {return}
            
            if text.isEmpty == false {
                let task = Task(id: UUID().uuidString, title: text, isDone: false)
                if self.rowsName.count < 2 {
                    self.rowsName.append(task)
                } else {
                    self.rowsName.insert(task, at: (self.rowsName.count - 1))
                }
                
                if self.rowsName.count == 2 {
                    self.rowsName.insert(self.all, at: self.rowsName.count)
                }
                self.saveData()
                self.reloadData()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(sendAction)
        present(alert, animated: true)
    }
    
    var rowsName: [Task] = []
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Tasks.plist")
    let all = Task(id: "0", title: "Отметить все", isDone: false)
    var userDef = UserDefaults.standard
    var userDefKey = "view"
    
    private func saveColor() {
        let saveColor = self.color
        let colorData = try? NSKeyedArchiver.archivedData(withRootObject: saveColor, requiringSecureCoding: false)
        userDef.set(colorData, forKey: userDefKey)
    }
    
    private func getColor() -> UIColor? {
        if let colorData = userDef.data(forKey: userDefKey) {
            if let decodedColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                return decodedColor
            }
        }
        reloadData()
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        if let savedColor = getColor() {
            self.color = savedColor
        }
        
        view.addSubview(aTableView)
        aTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorButton)
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorDetail)
        colorDetail.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(colorRed)
        view.addSubview(colorGreen)
        view.addSubview(colorBlue)
        
        colorRed.translatesAutoresizingMaskIntoConstraints = false
        colorGreen.translatesAutoresizingMaskIntoConstraints = false
        colorBlue.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        
        aTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-70)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        
        colorButton.snp.makeConstraints {
            $0.top.equalTo(addButton.safeAreaLayoutGuide.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.width.equalTo(40)
        }
        
        colorDetail.snp.makeConstraints {
            $0.bottom.equalTo(addButton.safeAreaLayoutGuide.snp.top).offset(-20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.width.equalTo(200)
        }
        
        colorRed.snp.makeConstraints {
            $0.top.equalTo(colorDetail.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(colorDetail.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        colorGreen.snp.makeConstraints {
            $0.top.equalTo(colorRed.safeAreaLayoutGuide.snp.bottom).offset(20)
            $0.leading.equalTo(colorDetail.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        colorBlue.snp.makeConstraints {
            $0.top.equalTo(colorGreen.safeAreaLayoutGuide.snp.bottom).offset(20)
            $0.leading.equalTo(colorDetail.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.rowsName)
            try data.write(to: filePath!)
        } catch  {
            print("Failed to encode Data \(error)")
        }
    }
    
    func getTasksData() {
        let decoder = PropertyListDecoder()
        
        do {
            if let data = try? Data(contentsOf: filePath!) {
                self.rowsName = try decoder.decode([Task].self, from: data)
                self.reloadData()
            }
        } catch {
            print("Failed to encode Data \(error)")
        }
    }
    
//    func someRxSwift() {
//        let label = UILabel()
//        let observable = Observable<String>.just("Hello, Aidar!")
//        _ = UIBindingObserver<UILabel, String>(UIElement: label, binding: { (label, text) in
//            label.text = text
//        }).onNext("Hello, world!")
//    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.aTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTasksData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.layer.cornerRadius = addButton.frame.size.height / 2
        colorButton.layer.cornerRadius = colorButton.frame.size.height / 2
       
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = aTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ATableVeiwCell
        
        let task = rowsName[indexPath.row]
        cell.initialSetup(name: task.title, bool: task.isDone, color: self.color)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowsName[indexPath.row].isDone.toggle()
//        if rowsName[rowsName.count - 1].isDone == true {
//            for i in 0...rowsName.count - 2 {
//                rowsName[i].isDone = true
//            }
//        } else if rowsName[rowsName.count - 1].isDone == false {
//            rowsName[1].isDone = false
//            for i in 0...rowsName.count - 2 {
//                rowsName[i].isDone = false
//            }
//        } else {
//
//        }
        self.saveData()
        tableView.deselectRow(at: indexPath, animated: true)
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if rowsName.count > 1 {
            if indexPath.row == rowsName.count - 1 {
                return false
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            rowsName.remove(at: indexPath.row)
            if rowsName.count == 2 {
                rowsName.removeAll{$0 == self.all}
                self.saveData()
                self.reloadData()
            }
            self.saveData()
            self.reloadData()

        }
    }
}
