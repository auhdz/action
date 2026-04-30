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
    @Published private(set) var lastError: String?

    private let contactStore = CNContactStore()

    override init() {
        authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        super.init()
    }

    // MARK: - Authorization

    func requestAuthorizationIfNeeded() {
        switch authorizationStatus {
        case .notDetermined:
            contactStore.requestAccess(for: .contacts) { [weak self] granted, error in
                Task { @MainActor [weak self] in
                    self?.authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
                    if !granted {
                        if let error = error {
                            print("Contact access denied: \(error.localizedDescription)")
                            self?.lastError = "Contact access denied: \(error.localizedDescription)"
                        }
                    } else {
                        await self?.fetchAllContacts()
                    }
                }
            }
        case .authorized:
            Task { await fetchAllContacts() }
        case _ where {
            if #available(iOS 18.0, *) { return authorizationStatus == .limited }
            return false
        }():
            Task { await fetchAllContacts() }
        case .denied, .restricted:
            break
        @unknown default:
            break
        }
    }

    // MARK: - Fetch Contacts

    func fetchAllContacts() async -> [TrustedContact] {
        let isLimited: Bool
        if #available(iOS 18.0, *) { isLimited = authorizationStatus == .limited } else { isLimited = false }
        guard authorizationStatus == .authorized || isLimited else {
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
                        let phoneValue = phoneNumber.value.stringValue
                        // Generate stable ID based on contact identifier and phone number
                        let contactId = "\(contact.identifier)-\(phoneValue)"
                        let id = String(contactId.hashValue.magnitude)

                        let trustedContact = TrustedContact(
                            id: id,
                            name: fullName,
                            phoneNumber: phoneValue
                        )
                        trustedContacts.append(trustedContact)
                    }
                }
            }

            self.contacts = trustedContacts
            self.lastError = nil
            return trustedContacts
        } catch {
            print("Contacts error: \(error.localizedDescription)")
            self.lastError = "Failed to load contacts: \(error.localizedDescription)"
            return []
        }
    }
}
