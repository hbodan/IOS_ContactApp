//
//  MainController.swift
//  ContactApp
//
//  Created by User-UAM on 10/13/24.
//

import Foundation
import UIKit

final class MainController{
    private let coreDataStack = CoreDataStack(modelName: "ContactApp")
    
    func getContacts() -> [ContactModel]{
        let fetchRequest = ContactModel.fetchRequest()
        
        do{
            let contacts = try coreDataStack.context.fetch(fetchRequest)
            return contacts
        }catch{
            print("Fetch error: \(error.localizedDescription)")
        }
        
        return []
    }
    
    func convertImageToData(image: UIImage?) -> Data? {
        // Comprueba si la imagen no es nil
        guard let image = image else { return nil }
        
        // Convertir a Data en formato JPEG o PNG
        let imageData = image.jpegData(compressionQuality: 1.0) // Para JPEG
        // let imageData = image.pngData() // Para PNG, si prefieres PNG
        
        return imageData
    }
    
    func saveContact(binaryData: Data?, name: String, lastName: String, phoneNumber: String, email: String, address: String, notes: String){
        let newContact = ContactModel(context: coreDataStack.context)
        
        newContact.id = UUID().uuidString
        newContact.image = binaryData
        newContact.name = name
        newContact.lastName = lastName
        newContact.phoneNumber = phoneNumber
        newContact.mail = email
        newContact.address = address
        newContact.notes = notes
        newContact.updatedAt = Date()
        
        coreDataStack.save()
    }
    
    func removeContact(contact: ContactModel){
        coreDataStack.context.delete(contact)
        coreDataStack.save()
    }
    
    func updateContact(contact: ContactModel) {
        contact.updatedAt = Date()
        
        coreDataStack.save()
    }
}
