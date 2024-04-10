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

    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    var descriptionLabelName: UILabel = {
        var descript = UILabel()
        descript.translatesAutoresizingMaskIntoConstraints = false
        descript.font = .boldSystemFont(ofSize: 22)
        descript.text = "Название"
        return descript
    }()

    var recipeNameTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 20)
        textField.isScrollEnabled = true
        textField.isEditable = true
        textField.backgroundColor = .tertiarySystemGroupedBackground
        return textField
    }()

    var descriptionLabelImage: UILabel = {
        var descript = UILabel()
        descript.translatesAutoresizingMaskIntoConstraints = false
        descript.font = .boldSystemFont(ofSize: 22)
        descript.text = "Фото"
        return descript
    }()

    var imagesView: UIImageView = {
        let images = UIImageView()
        images.translatesAutoresizingMaskIntoConstraints = false
        images.contentMode = .scaleAspectFill
        images.clipsToBounds = true
        return images
    }()

    var descriptionLabel: UILabel = {
        var descript = UILabel()
        descript.translatesAutoresizingMaskIntoConstraints = false
        descript.font = .boldSystemFont(ofSize: 22)
        descript.text = "Описание"
        return descript
    }()

    var descriptionViewList: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 18)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.backgroundColor = .tertiarySystemGroupedBackground
        return textView
    }()

    var stepsViewLabel: UILabel = {
        let stepsView = UILabel()
        stepsView.translatesAutoresizingMaskIntoConstraints = false
        stepsView.font = .boldSystemFont(ofSize: 22)
        stepsView.text = "Рецепт"
        return stepsView
    }()

    var descriptionViewSteps: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 18)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.backgroundColor = .tertiarySystemGroupedBackground
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        setupView()
        setupConstraint()
        setupNavigationBar()
        view.backgroundColor = .white
    }
}

// MARK: - Кнопки

extension EditRecipeViewController {
    @objc func imageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    @objc func saveChanges() {
        StorageDataManager.shared.updateRecipeName(recipe: recipe!, newName: recipeNameTextField.text)
        NotificationCenter.default.post(name: .reloadTable, object: self)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Работа с фото из библиотеки

extension EditRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imagesView.image = selectedImage
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension EditRecipeViewController {
    func addView() {
        title = "Редактор"
        view.addSubview(scrollView)
        scrollView.addSubview(descriptionLabelName)
        scrollView.addSubview(recipeNameTextField)
        scrollView.addSubview(descriptionLabelImage)
        scrollView.addSubview(imagesView)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(descriptionViewList)
        scrollView.addSubview(stepsViewLabel)
        scrollView.addSubview(descriptionViewSteps)
    }
}

extension EditRecipeViewController {
    func setupConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            descriptionLabelName.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            descriptionLabelName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabelName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            recipeNameTextField.topAnchor.constraint(equalTo: descriptionLabelName.bottomAnchor, constant: 10),
            recipeNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            recipeNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            recipeNameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

            descriptionLabelImage.topAnchor.constraint(equalTo: recipeNameTextField.bottomAnchor, constant: 20),
            descriptionLabelImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabelImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            imagesView.topAnchor.constraint(equalTo: descriptionLabelImage.bottomAnchor, constant: 20),
            imagesView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imagesView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imagesView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imagesView.heightAnchor.constraint(equalToConstant: 350),

            descriptionLabel.topAnchor.constraint(equalTo: imagesView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionViewList.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionViewList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionViewList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            descriptionViewList.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            stepsViewLabel.topAnchor.constraint(equalTo: descriptionViewList.bottomAnchor, constant: 20),
            stepsViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stepsViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionViewSteps.topAnchor.constraint(equalTo: stepsViewLabel.bottomAnchor, constant: 10),
            descriptionViewSteps.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionViewSteps.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            descriptionViewSteps.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),

            descriptionViewSteps.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 20),
        ])
    }
}

extension EditRecipeViewController {
    private func setupView() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imagesView.isUserInteractionEnabled = true
        imagesView.addGestureRecognizer(imageTapGesture)
    }
}

extension EditRecipeViewController {
    private func setupNavigationBar() {
        let buttonEdit = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveChanges))
        navigationItem.rightBarButtonItem = buttonEdit
    }
}
