import Combine
import Contacts
import Foundation

// MARK: - TrustedContact Model

struct TrustedContact: Identifiable, Codable {
    let id: String
    let name: String
    let phoneNumber: String
}

// MARK: - ContactsService

@MainActor
final class ContactsService: NSObject, ObservableObject {
    @Published private(set) var contacts: [TrustedContact] = []
    @Published private(set) var authorizationStatus: CNAuthorizationStatus

    private let contactStore = CNContactStore()
    static let shared = ContactsService()

    override init() {
        authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        super.init()
    }

    // MARK: - Authorization

    func requestAuthorizationIfNeeded() {
        switch authorizationStatus {
        case .notDetermined:
            contactStore.requestAccess(for: .contacts) { [weak self] granted, _ in
                Task { @MainActor [weak self] in
                    self?.authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
                    if granted {
                        await self?.fetchAllContacts()
                    }
                }
            }
        case .authorized:
            Task {
                await fetchAllContacts()
            }
        case .denied, .restricted:
            break
        @unknown default:
            break
        }
    }

    // MARK: - Fetch Contacts

    func fetchAllContacts() async -> [TrustedContact] {
        guard authorizationStatus == .authorized else {
            #if DEBUG
            print("Contacts: not authorized")
            #endif
            return []
        }

        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]

        do {
            let containers = try contactStore.containers(matching: nil)
            var trustedContacts: [TrustedContact] = []

            for container in containers {
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                let fetchedContacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keys)

                for contact in fetchedContacts {
                    let givenName = contact.givenName
                    let familyName = contact.familyName
                    let fullName = [givenName, familyName]
                        .filter { !$0.isEmpty }
                        .joined(separator: " ")
                        .trimmingCharacters(in: .whitespaces)

                    // Skip contacts without a name
                    if fullName.isEmpty {
                        continue
                    }

                    // Create a TrustedContact entry for each phone number
                    for phoneNumber in contact.phoneNumbers {
                        let trustedContact = TrustedContact(
                            id: UUID().uuidString,
                            name: fullName,
                            phoneNumber: phoneNumber.value.stringValue
                        )
                        trustedContacts.append(trustedContact)
                    }
                }
            }

            self.contacts = trustedContacts
            return trustedContacts
        } catch {
            #if DEBUG
            print("Contacts error: \(error.localizedDescription)")
            #endif
            return []
        }
    }
}
