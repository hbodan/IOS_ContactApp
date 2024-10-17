//
//  ViewController.swift
//  ContactApp
//
//  Created by User-UAM on 10/13/24.
//

import UIKit

enum Section{
    case main
}

class ViewController: UIViewController, UISearchBarDelegate{
    
    typealias DataSource = UITableViewDiffableDataSource<Section, ContactModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ContactModel>
    
    @IBOutlet weak var tableViewContent: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var contacts = [ContactModel]()
    
    let controller = MainController()
    
    var filteredData: [ContactModel]!
    
    private lazy var datasource: DataSource = {
        let dataSource = DataSource(tableView: tableViewContent) { tableView, indexPath, itemIdentifier in
            // Intentamos obtener la celda reutilizable
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell else {
                return UITableViewCell() // Retornar una celda vacía si hay un error
            }
            
            // Imagen
            if let imageData = itemIdentifier.image,
               let image = UIImage(data: imageData) {
                cell.contactImage.image = image
            } else {
                cell.contactImage.image = UIImage(systemName: "person.circle") // Imagen por defecto
            }
            
            // Nombre completo
            let firstName = itemIdentifier.name ?? ""
            let lastName = itemIdentifier.lastName ?? ""
            let fullName = "\(firstName) \(lastName)"
            cell.completeName.text = fullName.trimmingCharacters(in: .whitespaces)
            
            // Número de teléfono
            cell.phoneNumber.text = itemIdentifier.phoneNumber ?? "Sin número"
            
            // Fecha
            cell.dateLabel.text = itemIdentifier.updatedAt?.formatted(date: .long, time: .shortened) ?? "Sin fecha"
            
            cell.email.text = itemIdentifier.mail ?? "Sin correo"
            
            return cell // Retornar la celda configurada
        }
        
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contactos"
        searchBar.delegate = self
        tableViewContent.delegate = self
        buttonConfiguration()
        cellRegistration()
        filteredData = contacts

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    private func cellRegistration() {
        print("Registering cell...")
        tableViewContent.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        print("Cell registered.")
    }

    func getData() {
        print("Fetching data...")
        contacts = controller.getContacts()
        filteredData = contacts
        print("Contacts loaded: \(contacts.count)")
        applySnapshot()
    }
    
    func buttonConfiguration(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addContact))
    }
    
    private func applySnapshot(){
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        
        snapshot.appendItems(filteredData.isEmpty ? contacts : filteredData)
        
        datasource.apply(snapshot, animatingDifferences: false)
        
    }
    
    func convertStringToData(string: String?) -> Data {
        // Si el string es nulo, devuelve Data vacío. Si no, convierte el string a Data
        return string?.data(using: .utf8) ?? Data() // Devuelve Data vacío si string es nil
    }
    
    @objc func addContact(){
        let addContactVC = AddContactViewController(controller: controller)
        navigationController?.pushViewController(addContactVC, animated: true)
    }
    
    //MARK: Search Bar Configuration
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == ""{
            filteredData = contacts
        }
        
        for contact in contacts{
            if let name = contact.name?.lowercased(), name.contains(searchText.lowercased()) {
                filteredData.append(contact)
            }
        }
        
        applySnapshot()
    }
    

}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"
        ){
            action, view, completion in
            if let selectedModel = self.datasource.itemIdentifier(for: indexPath){
                self.controller.removeContact(contact: selectedModel)
                completion(true)
                self.getData()
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit"
        ){
            action, view, completion in
            if let selectedModel = self.datasource.itemIdentifier(for: indexPath){
                
                let editContactVC = AddContactViewController(controller: self.controller, contact: selectedModel)
                self.navigationController?.pushViewController(editContactVC, animated: true)
                completion(true)
            }
        }
        
        editAction.backgroundColor = UIColor.green
        deleteAction.image = UIImage(systemName: "trash")
        editAction.image = UIImage(systemName: "pencil")
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeAction
    }
}

