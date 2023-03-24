//
//  ATableVeiwCell.swift
//  CheckMarkTable
//
//  Created by Dastan on 13/3/23.
//


import UIKit
 
class ATableVeiwCell: UITableViewCell {
    
    private lazy var aLabel: UILabel = {
        let a = UILabel()
        a.text = "WoW"
        a.textAlignment = .left
        a.numberOfLines = 0
        
        return a
    }()
    
    private lazy var checkMarkImage: UIImageView = {
        let check = UIImageView()
        check.image = uncheckedImage

        return check
    }()
    
    let checkedImage = UIImage.init(systemName: "checkmark.circle")
    let uncheckedImage = UIImage.init(systemName: "circle")
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(aLabel)
        contentView.addSubview(checkMarkImage)
        
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        checkMarkImage.translatesAutoresizingMaskIntoConstraints = false
        
        aLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        aLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        aLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -64).isActive = true
        aLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        checkMarkImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkMarkImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        checkMarkImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkMarkImage.leadingAnchor.constraint(equalTo: aLabel.trailingAnchor, constant: 20).isActive = true
        
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetup(name: String, bool: Bool, color: UIColor) {
        aLabel.text = name
        checkMarkImage.image = bool ? checkedImage : uncheckedImage
        checkMarkImage.tintColor = color
    }
}
