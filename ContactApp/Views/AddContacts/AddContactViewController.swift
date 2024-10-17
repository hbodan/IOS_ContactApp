//
//  AddContactViewController.swift
//  ContactApp
//
//  Created by User-UAM on 10/13/24.
//

import UIKit
import PhotosUI



class AddContactViewController: UIViewController {
    
    var isEditingContact: Bool = false
    var existingContact: ContactModel?
    
    let controller: MainController
    
    let nameTextField = UITextField()
    let lastNameTextField = UITextField()
    let phoneTextField = UITextField()
    let emailTextField = UITextField()
    let addressTextField = UITextField()
    let notesTextField = UITextField()
    
    let scrollView = UIScrollView()
    let contentView = UIView()

    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 65
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()

    let changeImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cambiar imagen", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Guardar", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    init(controller: MainController, contact: ContactModel? = nil) {
        self.controller = controller
        self.existingContact = contact
        self.isEditingContact = contact != nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Agregar Contacto"
        view.backgroundColor = .white
        
        setupScrollView()
        setupUIElements()
        setupConstraints()
        
        // Añadir acción al botón de guardar
        saveButton.addTarget(self, action: #selector(onTapAddContactButton), for: .touchUpInside)
        changeImageButton.addTarget(self, action: #selector(onTapAddImage), for: .touchUpInside)
        
        if isEditingContact, let contact = existingContact {
                nameTextField.text = contact.name
                lastNameTextField.text = contact.lastName
                phoneTextField.text = contact.phoneNumber
                emailTextField.text = contact.mail
                addressTextField.text = contact.address
                notesTextField.text = contact.notes
                
                // Si el contacto tiene una imagen guardada
                if let imageData = contact.image {
                    profileImageView.image = UIImage(data: imageData)
                }
                
                // Cambia el título y el botón si estás editando
                title = "Editar Contacto"
                saveButton.setTitle("Actualizar", for: .normal)
            } else {
                title = "Agregar Contacto"
                saveButton.setTitle("Guardar", for: .normal)
            }
    }

    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    func setupUIElements() {
        // Add fields to contentView
        [profileImageView, changeImageButton, nameTextField, lastNameTextField, phoneTextField, emailTextField, addressTextField, notesTextField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        // Configure Text Fields
        configureTextField(textField: nameTextField, placeholder: "Nombre")
        configureTextField(textField: lastNameTextField, placeholder: "Apellido")
        configureTextField(textField: phoneTextField, placeholder: "Número de teléfono")
        configureTextField(textField: emailTextField, placeholder: "Correo electrónico")
        configureTextField(textField: addressTextField, placeholder: "Dirección")
        configureTextField(textField: notesTextField, placeholder: "Notas")
        
        // Add save button to the main view
        view.addSubview(saveButton)
    }

    func configureTextField(textField: UITextField, placeholder: String) {
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10),
            
            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Profile Image Constraints
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 130),
            profileImageView.heightAnchor.constraint(equalToConstant: 130),
            
            // Change Image Button Constraints
            changeImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            changeImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Text Fields Constraints
            nameTextField.topAnchor.constraint(equalTo: changeImageButton.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            lastNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            lastNameTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            lastNameTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            phoneTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 10),
            phoneTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            addressTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            addressTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            addressTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            notesTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 10),
            notesTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            notesTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            notesTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Save Button Constraints
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    @objc func onTapAddContactButton() {
        var binaryData: Data? = nil
        
        // Si la imagen no es la predeterminada, convertirla a datos binarios
        if let image = profileImageView.image,
           let personCircleImage = UIImage(systemName: "person.circle"),
           image.pngData() != personCircleImage.pngData() {
            binaryData = image.pngData()
        }
        
        // Obtener los campos de texto
        guard let name = nameTextField.text else { return }
        
        let lastName = lastNameTextField.text ?? ""
        let phoneNumber = phoneTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let notes = notesTextField.text ?? ""
        
        if isEditingContact {
            // Actualizar el contacto existente
            existingContact?.name = name
            existingContact?.lastName = lastName
            existingContact?.phoneNumber = phoneNumber
            existingContact?.mail = email
            existingContact?.address = address
            existingContact?.notes = notes
            existingContact?.image = binaryData
            
            controller.updateContact(contact: existingContact!)
        } else {
            // Crear un nuevo contacto
            controller.saveContact(binaryData: binaryData, name: name, lastName: lastName, phoneNumber: phoneNumber, email: email, address: address, notes: notes)
        }

        navigationController?.popViewController(animated: true)
    }

    
    @objc func onTapAddImage(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
}

extension AddContactViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else { return }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { reading, error in
                guard error == nil, let image = reading as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            })
        }
    }
}
