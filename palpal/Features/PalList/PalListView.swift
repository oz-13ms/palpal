import SwiftUI
import ComposableArchitecture

@ViewAction(for: PalList.self)
struct PalListView: View {
    @Bindable var store: StoreOf<PalList>
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    TextField("Search", text: $store.searchQuery.sending(\.searchQueryChanged))
                        .foregroundColor(.primary)
                        .padding(Margin.mini)
                        .background(Color(.systemGray6))
                        .cornerRadius(CornerRadius.small)
                }
                .padding(.bottom, Margin.average)
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: Margin.average) {
                        ForEach(store.filteredPals, id: \.id) { pal in
                            PalGridCell(pal: pal) {
                                send(.didTapDetailsButton(pal))
                            }
                        }
                    }
                }
            }
            .sheet(
                item: $store.scope(
                    state: \.route?.palDetails,
                    action: \.route.palDetails
                )
            ) { store in
                PalDetailsView(store: store)
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Pal List")
                        .foregroundStyle(Color.white)
                }
                ToolbarItem(placement: .automatic) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(Color(.systemBlue))
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .background(color: .primaryL)
            .onAppear {
                send(
                    .onAppear
                )
            }
        }
    }
}

extension PalGridCell {
    struct Constants {
        static let imageHeight: CGFloat = 80
    }
}

struct PalGridCell: View {
    let pal: PalModel
    let didTapCell: () -> Void
    
    var body: some View {
        Button {
            didTapCell()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Color.white.opacity(0.2))
                VStack {
                    HStack (alignment: .top) {
                        Image(palNatureType: pal.element)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Margin.average, height: Margin.average)
                            .padding([.top, .leading] ,Margin.mini)
                        Spacer()
                        AsyncImage(url: URL(string: pal.avatarUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: Constants.imageHeight)
                        Spacer()
                        Text("#\(pal.id)")
                            .foregroundColor(.white)
                            .bold()
                            .padding([.top, .trailing], Margin.mini)
                    }
                    Spacer()
                    Text(pal.name)
                        .foregroundColor(.white)
                        .padding(Margin.mini)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#if DEBUG
struct PalListView_Previews: PreviewProvider {
    static var previews: some View {
        PalListView(store: .init(
            initialState: PalList.State(searchQuery: "", pals: [], filteredPals: []),
            reducer: {
                PalList()
            })
        )
    }
}
#endif
