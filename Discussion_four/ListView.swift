//
//  ListView.swift
//  Discussion_four
//
//  Created by Dylan Chhum on 2/27/25.
//
import SwiftUI

struct ListView : View {
    @State private var viewModel = ListViewModel()
    
    var body : some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField ("New Todo", text: $viewModel.newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button (action: viewModel.addTodo) {
                        Image (systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .disabled(viewModel.newTodo.trimmingCharacters(in: .whitespaces)
                        .isEmpty)
                }
                .padding()
                
                FilterView (viewModel: viewModel)
                    .padding(.horizontal)
                
                List {
                    ForEach($viewModel.todoItems) {$list in
                        if helper(list: list) {
                            ListRowView(list: $list)
                        }
                    }
                    .onDelete(perform: viewModel.removeTodo)
                }
                
                StatsFooterView(activeCount: viewModel.activeCount, completedCount: viewModel.completeCount)
                    .padding()
            }
            .navigationTitle("Oski's Todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sample Data") {
                        viewModel.addSampleData()
                    }
                }
            }
        }
    }
    
    private func helper(list: ListItem) -> Bool {
            switch viewModel.filterMode {
            case .all:
                return true
            case .active:
                return !list.isComplete
            case .completed:
                return list.isComplete
            }
        }
}

struct FilterView : View {
    var viewModel: ListViewModel
    
    var body: some View {
        HStack {
            
            FilterButtonView(title: "All", isActive: viewModel.filterMode == .all) {
                viewModel.setFilter(.all)
            }
            
            FilterButtonView(title: "Active", isActive: viewModel.filterMode == .active) {
                viewModel.setFilter(.active)
            }
            
            FilterButtonView(title: "Completed", isActive: viewModel.filterMode == .completed) {
                viewModel.setFilter(.completed)
            }
            
        }
        
    }
    
    struct FilterButtonView : View {
        let title : String
        let isActive : Bool
        let action: () -> Void
        
        var body : some View {
            Button(action: action) {
                Text(title)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(isActive ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
                
            }
            .foregroundColor(isActive ? .blue: .primary)
        }
    }
}

#Preview {
    ListView()
}

