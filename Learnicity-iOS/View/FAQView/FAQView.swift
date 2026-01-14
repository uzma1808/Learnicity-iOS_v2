//
//  FAQView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 05/10/2025.
//

import SwiftUI

struct FAQView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = FAQViewModel()
    @State private var searchText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Custom header
            CustomHeaderView(title: "FAQ") {
                path.pop()
            }

            // Scrollable content
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.faqs) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.question)
                                .customFont(style: .black, size: .h22)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.primary)

                            Text(item.answer)
                                .customFont(style: .medium, size: .h16)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10)
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            Task {
                await viewModel.fetchFAQs()
            }
        }
        .navigationBarBackButtonHidden()
        .loadingIndicator($viewModel.isLoading)

    }
}


#Preview {
    FAQView(path: .constant(NavigationPath()))
}
