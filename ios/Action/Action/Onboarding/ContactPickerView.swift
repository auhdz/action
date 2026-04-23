import Combine
import Contacts
import SwiftUI
import Supabase

// MARK: - ContactPickerView

struct ContactPickerView: View {
    @ObservedObject var onboardingState: OnboardingState
    @EnvironmentObject var appModel: AppModel

    @StateObject private var contactsService = ContactsService()
    @State private var searchText = ""
    @State private var selectedContactIds: Set<String> = []
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var showErrorAlert = false

    // Maximum allowed contacts
    private let maxContacts = 5

    // Filtered contacts based on search text
    var filteredContacts: [TrustedContact] {
        if searchText.isEmpty {
            return contactsService.contacts
        }
        return contactsService.contacts.filter { contact in
            contact.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    // Count of selected contacts
    var selectedCount: Int {
        selectedContactIds.count
    }

    // Button text based on selection state
    var buttonText: String {
        if selectedCount == 0 {
            return "Continuar sin contactos"
        } else {
            return "Continuar (\(selectedCount))"
        }
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with title and safety nudge
                VStack(spacing: 12) {
                    Text("Contactos de Confianza")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Para tu seguridad, te recomendamos agregar al menos un contacto de confianza.")
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 20)

                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField("Buscar contacto", text: $searchText)
                        .font(.system(size: 16, weight: .regular, design: .default))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.05))
                .cornerRadius(8)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                // Contacts list
                if filteredContacts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)

                        Text("Sin resultados")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundStyle(.secondary)

                        if !searchText.isEmpty {
                            Text("No se encontraron contactos con ese nombre")
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal, 24)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredContacts) { contact in
                                ContactRow(
                                    contact: contact,
                                    isSelected: selectedContactIds.contains(contact.id),
                                    isDisabled: selectedCount >= maxContacts && !selectedContactIds.contains(contact.id),
                                    onTap: {
                                        toggleContact(contact.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                    }
                }

                // Continue button
                VStack(spacing: 12) {
                    Button(action: {
                        Task {
                            await saveContactsAndContinue()
                        }
                    }) {
                        Text(buttonText)
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.0, green: 0.45, blue: 0.90))
                            .cornerRadius(12)
                            .opacity(isSaving ? 0.6 : 1.0)
                    }
                    .disabled(isSaving)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            contactsService.requestAuthorizationIfNeeded()
            Task {
                _ = await contactsService.fetchAllContacts()
            }
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK") {
                showErrorAlert = false
            }
        } message: {
            Text(errorMessage ?? "Ocurrió un error desconocido")
        }
    }

    // MARK: - Private Methods

    private func toggleContact(_ contactId: String) {
        if selectedContactIds.contains(contactId) {
            selectedContactIds.remove(contactId)
        } else if selectedCount < maxContacts {
            selectedContactIds.insert(contactId)
        }
    }

    private func saveContactsAndContinue() async {
        isSaving = true
        defer { isSaving = false }

        do {
            // Ensure we have an authenticated session
            let supabaseClient = AppConfiguration.current.supabaseClient
            try await ensureAnonymousSessionIfNeeded(supabaseClient)

            // Get the current user ID
            let session = try await supabaseClient.auth.session
            let userId = session.user.id.uuidString

            // Delete any existing trusted contacts for this user
            _ = try await supabaseClient
                .from("trusted_contacts")
                .delete()
                .eq("user_id", value: userId)
                .execute()

            // Insert selected contacts
            let selectedContactsList = contactsService.contacts
                .filter { selectedContactIds.contains($0.id) }

            if !selectedContactsList.isEmpty {
                for contact in selectedContactsList {
                    _ = try await supabaseClient
                        .from("trusted_contacts")
                        .insert([
                            "user_id": userId,
                            "name": contact.name,
                            "phone_number": contact.phoneNumber
                        ])
                        .execute()
                }
            }

            // Ensure viewer token exists
            let viewerTokenService = ViewerTokenService(supabaseClient: supabaseClient)
            await viewerTokenService.ensureViewerTokenExists()

            // Update onboarding state and move to next step
            onboardingState.selectedContacts = selectedContactsList
            onboardingState.step = .locationPermission
        } catch {
            errorMessage = "No se pudo guardar los contactos: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }

    private func ensureAnonymousSessionIfNeeded(_ supabaseClient: SupabaseClient) async throws {
        do {
            _ = try await supabaseClient.auth.session
            return
        } catch {
            // No session; try anonymous sign-in.
        }

        _ = try await supabaseClient.auth.signInAnonymously()
    }
}

// MARK: - ContactRow

struct ContactRow: View {
    let contact: TrustedContact
    let isSelected: Bool
    let isDisabled: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Avatar with initials
                ZStack {
                    Circle()
                        .fill(Color(red: 0.0, green: 0.45, blue: 0.90).opacity(0.1))

                    Text(contact.name.prefix(1).uppercased())
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(Color(red: 0.0, green: 0.45, blue: 0.90))
                }
                .frame(width: 44, height: 44)

                // Contact info
                VStack(alignment: .leading, spacing: 4) {
                    Text(contact.name)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundStyle(.primary)

                    Text(contact.phoneNumber)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.0, green: 0.45, blue: 0.90))
                } else {
                    Image(systemName: "circle")
                        .font(.system(size: 24))
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(8)
            .opacity(isDisabled ? 0.5 : 1.0)
        }
        .disabled(isDisabled)
    }
}

#Preview {
    @Previewable @StateObject var onboardingState = OnboardingState()

    ContactPickerView(onboardingState: onboardingState)
        .environmentObject(AppModel())
}
