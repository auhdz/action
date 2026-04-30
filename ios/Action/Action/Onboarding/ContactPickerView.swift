import Combine
import Contacts
import SwiftUI
import Supabase

// MARK: - ContactPickerView

struct ContactPickerView: View {
    @ObservedObject var onboardingState: OnboardingState
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var lang: LanguageManager

    @StateObject private var contactsService = ContactsService()
    @State private var searchText = ""
    @State private var selectedContactIds: Set<String> = []
    @State private var isSaving = false

    private let maxContacts = 5

    var filteredContacts: [TrustedContact] {
        if searchText.isEmpty { return contactsService.contacts }
        return contactsService.contacts.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var selectedCount: Int { selectedContactIds.count }

    var buttonText: String {
        if selectedCount == 0 {
            return lang.isSpanish ? "Continuar sin contactos" : "Continue without contacts"
        }
        return lang.isSpanish ? "Continuar (\(selectedCount))" : "Continue (\(selectedCount))"
    }

    var body: some View {
        ZStack {
            Color.safeCream.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    HStack {
                        Text(lang.isSpanish ? "Contactos de Confianza" : "Trusted Contacts")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.primary)
                        Spacer()
                        LanguageToggle()
                    }

                    Text(lang.isSpanish
                         ? "Las personas que agregues aquí recibirán tu ubicación si activas una alerta. No necesitan descargar ninguna app. Agrega solo a personas de plena confianza."
                         : "The people you add here will receive your location if you activate a safety alert. They do not need to download any app. Only add people you fully trust.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 20)

                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField(lang.isSpanish ? "Buscar contacto" : "Search contact", text: $searchText)
                        .font(.system(size: 16))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.05))
                .cornerRadius(8)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                // Contacts list
                if filteredContacts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)

                        Text(lang.isSpanish ? "Sin resultados" : "No results")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.secondary)

                        if !searchText.isEmpty {
                            Text(lang.isSpanish
                                 ? "No se encontraron contactos con ese nombre"
                                 : "No contacts found with that name")
                                .font(.system(size: 14))
                                .foregroundStyle(.tertiary)
                        } else if contactsService.authorizationStatus != .authorized && contactsService.authorizationStatus != .limited {
                            Text(lang.isSpanish
                                 ? "Permite el acceso a contactos en Ajustes"
                                 : "Allow contacts access in Settings")
                                .font(.system(size: 14))
                                .foregroundStyle(.tertiary)
                                .multilineTextAlignment(.center)
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
                                    onTap: { toggleContact(contact.id) }
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                    }
                }

                // Continue button
                Button(action: {
                    Task { await saveContactsAndContinue() }
                }) {
                    Group {
                        if isSaving {
                            ProgressView().tint(.white)
                        } else {
                            Text(buttonText)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.actionRed)
                    .cornerRadius(12)
                    .opacity(isSaving ? 0.6 : 1.0)
                }
                .disabled(isSaving)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            contactsService.requestAuthorizationIfNeeded()
            Task { _ = await contactsService.fetchAllContacts() }
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

        let selectedContactsList = contactsService.contacts
            .filter { selectedContactIds.contains($0.id) }

        // Always proceed — never block onboarding on network calls
        await MainActor.run {
            onboardingState.selectedContacts = selectedContactsList
            onboardingState.step = .locationPermission
            isSaving = false
        }

        // Save to Supabase in background (non-blocking)
        Task.detached {
            do {
                let config = AppConfiguration.current
                let client = SupabaseClient(
                    supabaseURL: config.supabaseURL,
                    supabaseKey: config.supabaseAnonKey
                )

                // Ensure session
                if (try? await client.auth.session) == nil {
                    _ = try await client.auth.signInAnonymously()
                }

                let userId = try await client.auth.session.user.id.uuidString

                _ = try await client.from("trusted_contacts")
                    .delete().eq("user_id", value: userId).execute()

                for contact in selectedContactsList {
                    _ = try await client.from("trusted_contacts")
                        .insert(["user_id": userId, "name": contact.name, "phone_number": contact.phoneNumber])
                        .execute()
                }

                let tokens: [[String: AnyJSON]] = try await client
                    .from("viewer_tokens").select().eq("user_id", value: userId).execute().value
                if tokens.isEmpty {
                    _ = try await client.from("viewer_tokens").insert(["user_id": userId]).execute()
                }
            } catch {
                print("Background Supabase sync failed: \(error.localizedDescription)")
            }
        }
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
                ZStack {
                    Circle()
                        .fill(Color.actionRed.opacity(0.1))
                    Text(contact.name.prefix(1).uppercased())
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.actionRed)
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(contact.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(contact.phoneNumber)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected
                        ? Color.actionRed
                        : Color(UIColor.tertiaryLabel))
            }
            .padding(12)
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
        .environmentObject(LanguageManager())
}
