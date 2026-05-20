// BuggyFormView.swift
// Contains: 2 logic/state bugs

import SwiftUI

struct BuggyFormView: View {
    // BUG 1: Missing @State — these variables won't update the UI
    var name: String = ""
    var email: String = ""
    var agreedToTerms: Bool = false
    var submitted: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section("Personal Info") {
                    TextField("Your Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        // BUG 2: Email field should be lowercase only, missing modifier
                }

                Section("Terms") {
                    Toggle("I agree to the terms", isOn: $agreedToTerms)
                }

                Section {
                    Button("Submit") {
                        // BUG 3: No validation — should check name/email not empty AND terms agreed
                        submitted = true
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }

                if submitted {
                    Text("✅ Profile saved!")
                        .foregroundColor(.green)
                }
            }
            .navigationTitle("My Profile")
        }
    }
}

// ─────────────────────────────────────────
// FIXES
// ─────────────────────────────────────────
//
// FIX 1: Add @State to all four variables:
//   @State private var name: String = ""
//   @State private var email: String = ""
//   @State private var agreedToTerms: Bool = false
//   @State private var submitted: Bool = false
//
// FIX 2: Add .textInputAutocapitalization(.never) and .autocorrectionDisabled() to email field
//
// FIX 3: Replace button action with:
//   if !name.isEmpty && !email.isEmpty && agreedToTerms {
//       submitted = true
//   }
