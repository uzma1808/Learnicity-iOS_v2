//
//  ChooseSubjectView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 16/08/2025.
//

import SwiftUI
import PopupView

struct ChooseSubjectView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = SubjectViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            CustomHeaderView(title: "Choose Subject") {
                path.pop()
            }

            ScrollView {
                VStack(alignment: .leading) {
                    // Choose Subject
                    Text("Choose your Subject")
                        .customFont(style: .bold, size: .h24)

                    FlowLayout(items: viewModel.subjects, itemSpacing: 8, lineSpacing: 12) { subject in
                        Button(action: { viewModel.selectedSubject = subject }) {
                            Text(subject.subject ?? "")
                                .customFont(style: .medium, size: .h24)
                                .foregroundColor(viewModel.selectedSubject == subject ? .white : .black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(viewModel.selectedSubject == subject ? Color.blue : Color.gray.opacity(0.2))
                                )
                        }
                    }

                    if !viewModel.subjects.isEmpty {
                        Text("Difficulty")
                            .customFont(style: .bold, size: .h24)
                            .padding(.top, 28)

                        HStack(spacing: 16) {
                            ForEach(viewModel.dificulties, id: \.self) { difficulty in
                                let isSelected = viewModel.selectedDificultyLevel == difficulty
                                Button(action: { viewModel.selectedDificultyLevel = difficulty }) {
                                    VStack(spacing: 6) {
                                        Text(difficulty.difficulty ?? "")
                                            .customFont(style: .bold, size: .h24)
                                            .foregroundColor(isSelected ? .white : .black)

                                        HStack {
                                            Image(systemName: isSelected ? "dollarsign.circle.fill" : "dollarsign.circle")
                                                .foregroundColor(isSelected ? .white : .gray)
                                                .font(.system(size: 20))
                                            Text("\(difficulty.coins ?? "0") Coins")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(isSelected ? .white : .black)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(isSelected ? Color.green : Color.gray.opacity(0.2))
                                    )
                                }
                            }
                        }
                    }
                    Spacer()
                }

            }
            CustomButtonView(title: "Confirm", action: {
                if viewModel.validateSubjectSelection() {
                    //
                    Task {
                        let resp = try await viewModel.setQuizSettings()
                        if resp.status ?? false {
                            UserSession.shared.saveQuizSettings(subject: viewModel.selectedSubject, difficulty: viewModel.selectedDificultyLevel)
                            path.push(screen: .home)
                        } else {
                            viewModel.errorMessage = "Something went wrong. Please try again."
                            viewModel.showError = true
                        }
                    }

                } else {
                    viewModel.showError = true
                }
            })
            .padding(.bottom)

        }
        .padding()
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .onAppear {
            Task {
                await viewModel.fetchSubjects()
            }
        }
        .popup(isPresented: $viewModel.showError) {
            ErrorView(errorMessage: viewModel.errorMessage ?? "" )
        } customize: {
            $0
                .type(.toast)
                .autohideIn(1.5)
                .position(.top)
        }
        .loadingIndicator($viewModel.isLoading)
    }
}


// Simple FlowLayout for wrapping buttons
struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let items: Data
    let itemSpacing: CGFloat
    let lineSpacing: CGFloat
    let content: (Data.Element) -> Content

    init(
        items: Data,
        itemSpacing: CGFloat = 8,
        lineSpacing: CGFloat = 8,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.items = items
        self.itemSpacing = itemSpacing
        self.lineSpacing = lineSpacing
        self.content = content
    }

    var body: some View {
        FlexibleView(
            availableWidth: UIScreen.main.bounds.width - 32, // account for padding
            data: items,
            spacing: itemSpacing,
            lineSpacing: lineSpacing,
            content: content
        )
    }
}

/// A helper view that actually measures child sizes and arranges them into wrapped rows
struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let lineSpacing: CGFloat
    let content: (Data.Element) -> Content

    @State private var elementsSize: [Data.Element: CGSize] = [:]

    var body: some View {
        VStack(alignment: .leading, spacing: lineSpacing) {
            ForEach(computeRows(), id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { element in
                        content(element)
                            .fixedSize() // don’t shrink
                            .background(SizeReader(size: $elementsSize[element]))
                    }
                }
            }
        }
    }

    private func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRowWidth: CGFloat = 0

        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            if currentRowWidth + elementSize.width + spacing > availableWidth {
                rows.append([element])
                currentRowWidth = elementSize.width + spacing
            } else {
                rows[rows.count - 1].append(element)
                currentRowWidth += elementSize.width + spacing
            }
        }

        return rows
    }
}

/// Reads the size of a view and stores it in a binding
private struct SizeReader: View {
    @Binding var size: CGSize?

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: SizeKey.self, value: geometry.size)
        }
        .onPreferenceChange(SizeKey.self) { self.size = $0 }
    }
}

private struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize?
    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = nextValue() ?? value
    }
}



#Preview {
    ChooseSubjectView(path: .constant(NavigationPath()))
}
