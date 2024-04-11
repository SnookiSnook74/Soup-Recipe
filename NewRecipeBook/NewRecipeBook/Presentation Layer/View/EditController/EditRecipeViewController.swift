//
//  EditRecipeViewController.swift
//  NewRecipeBook
//
//  Created by DonHalab on 20.12.2023.
//

import UIKit

extension Notification.Name {
    static let reloadTable = Notification.Name("reloadTable")
}

class EditRecipeViewController: UIViewController {
    
    var recipe: WrapperModel?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(EditImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(EditTitleCell.self, forCellWithReuseIdentifier: "TitleCell")
        collectionView.register(EditDescriptionCell.self, forCellWithReuseIdentifier: "DescriptionCell")
        collectionView.keyboardDismissMode = .onDrag
        collectionView.collectionViewLayout = createLayout()
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        title = "Редактор"
        let saveButton = UIBarButtonItem(title: "Сохрнаить", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
        addConstraint()
        registerForKeyboardNotifications()
    }
    
    @objc func save() {
        StorageDataManager.shared.updateRecipeInformation(recipe: recipe!, newName: recipe?.name ?? "",
                                                          newDescription: recipe?.description ?? " " ,
                                                          newStep: recipe?.step ?? " ")
        NotificationCenter.default.post(name: .reloadTable, object: self)
        navigationController?.popToRootViewController(animated: true)
    }
    
   private func createLayout() -> UICollectionViewLayout {
       let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(50))
       let item = NSCollectionLayoutItem(layoutSize: itemSize)
       
       let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50))
       let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
       
       
       let section = NSCollectionLayoutSection(group: group)
       
       let layout = UICollectionViewCompositionalLayout(section: section)
       return layout
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension EditRecipeViewController:  UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return EditRecipeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let selection = EditRecipeSection(rawValue: indexPath.section) else {fatalError("Ошибка в секции колекции в Edit")}
        
        let identificator = selection.cellIdentifier(for: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identificator, for: indexPath)
       
        switch selection {
        case .name:
            if let cell = cell as? EditDescriptionCell {
                cell.textDescriptiont.text = recipe?.name
                cell.delegate = self
            } else if let cell = cell as? EditTitleCell {
                cell.title.text = "Название"
            }
        case .photo:
            if let cell = cell as? EditImageCell, let imageDate = recipe?.image {
                cell.imageView.image = UIImage(data: imageDate)
            } else if let cell = cell as? EditTitleCell {
                cell.title.text = "Фото"
            }
        case .descripion:
            if let cell = cell as? EditDescriptionCell {
                cell.textDescriptiont.text = recipe?.description
                cell.delegate = self
            } else if let cell = cell as? EditTitleCell {
                cell.title.text = "Описание"
            }
        case .step:
            if let cell = cell as? EditDescriptionCell {
                cell.textDescriptiont.text = recipe?.step
                cell.delegate = self
            } else if let cell = cell as? EditTitleCell {
                cell.title.text = "Пошаговый рецепт"
            }
        }
        return cell
    }
}

// MARK: - UITextView delegat
extension EditRecipeViewController: EditDescriptionCellDelegate {
    func textDidChange(in cell: EditDescriptionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        switch EditRecipeSection(rawValue: indexPath.section) {
        case .name:
            recipe?.name = cell.textDescriptiont.text
        case .descripion:
            recipe?.description = cell.textDescriptiont.text
        case .step:
            recipe?.step = cell.textDescriptiont.text
        default:
            break
        }
    }
}

// MARK: - Keyboard
extension EditRecipeViewController {
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + 50, right: 0.0)
        
        collectionView.contentInset = contentInsets
        collectionView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        collectionView.contentInset = contentInsets
        collectionView.scrollIndicatorInsets = contentInsets
    }
}
