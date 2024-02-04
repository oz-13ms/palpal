import SwiftUI
import ComposableArchitecture

extension PalDetailsView {
    struct Constants {
        static let imageHeight: CGFloat = 120.0
        static let teamSectionHeight: CGFloat = 80.0
    }
}

@ViewAction(for: PalDetails.self)
struct PalDetailsView: View {
    var store: StoreOf<PalDetails>
    
    var body: some View {
        VStack {
            VStack(spacing: Margin.small) {
                Text("Your team")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                Group {
                    ForEach(store.palDisplayData.indices, id: \.self) { index in
                        HStack(spacing: Margin.small) {
                            ForEach(store.palDisplayData[index].indices, id: \.self) { palSpaceIndex in
                                switch store.palDisplayData[index][palSpaceIndex] {
                                case .pal(let pal):
                                    CircularPalButton(
                                        imageURL: pal.avatarUrl,
                                        tapAction: { send(.didTapPalCircle(store.pal, index, palSpaceIndex)) },
                                        longpressAction: { send(.didLongpressPalCircle(index, palSpaceIndex)) }
                                    )
                                case .empty:
                                    CircularPalButton(
                                        imageURL: nil,
                                        tapAction: { send(.didTapPalCircle(store.pal, index, palSpaceIndex)) },
                                        longpressAction: { send(.didLongpressPalCircle(index, palSpaceIndex)) }
                                    )
                                }
                            }
                        }
                    }
                }
                .frame(height: Constants.teamSectionHeight)
            }
            .padding(Margin.small)
            Divider()
                .background(color: .white)
                .padding(.horizontal)
            ScrollView {
                HStack {
                    Image(palNatureType: store.pal.element)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Margin.large)
                    Spacer()
                    Text(store.pal.name)
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                    Spacer()
                    Text("#\(store.pal.id)")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                }
                .padding()
                AsyncImage(url: URL(string: store.pal.avatarUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: Constants.imageHeight)
                WorkSuitabilitySection(pal: store.pal)
                StatsSection(stats: store.pal.readableStats)
                DescriptionSection(description: store.pal.description)
                PossibleDropsSection(drops: store.pal.possibleDrops)
            }
            .padding(.vertical, Margin.small)
        }
        .background(color: .primaryL)
        .onAppear {
            send(
                .onAppear
            )
        }
    }
}

struct DescriptionSection: View {
    var description: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Description")
                .foregroundColor(.white)
                .font(.title2)
                .bold()
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .fill(Color.white.opacity(0.2))
                Text(description)
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding()
            }
        }
        .padding()
    }
}

struct StatsSection: View {
    var stats: [PalStatType: Int]
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Stats")
                .foregroundColor(.white)
                .font(.title2)
                .bold()
            VStack {
                ForEach(Array(stats.sorted(by: { $0.key.rawValue < $1.key.rawValue })), id: \.0) { stat in
                    StatLabel(stat: stat.0, value: stat.1)
                }
            }
        }
        .padding()
    }
}

struct StatLabel: View {
    var stat: PalStatType
    var value: Int
    
    var body: some View {
        ZStack {
            Color.primaryD
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                .overlay(RoundedRectangle(cornerRadius: CornerRadius.small).stroke(.primaryD, lineWidth: 1))
            HStack {
                Text(stat.getStringValue)
                    .foregroundColor(.white)
                    .font(.title3)
                Spacer()
                Text("\(value)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .bold()
            }
            .padding()
        }
    }
}


struct PossibleDropsSection: View {
    var drops: [DropModel]
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Possible drops")
                .foregroundColor(.white)
                .font(.title2)
                .bold()
            LazyVGrid(columns: [
                GridItem(alignment: .leading),
                GridItem(alignment: .leading),
                GridItem(alignment: .leading)
            ], alignment: .leading, spacing: Margin.average) {
                Text("Item")
                    .font(.headline)
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                Text("Amount")
                    .font(.headline)
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                Text("Rate")
                    .font(.headline)
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                
                
                ForEach(drops, id: \.name) { item in
                        Text(item.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                            .font(.subheadline)
                        Text(item.minAmount == item.maxAmount ? "\(item.minAmount)" :"\(item.minAmount) - \(item.maxAmount)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.subheadline)
                        Text("\(item.dropRate)%")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .background(item.dropRate > 50 ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                }
            }
        }
        .padding()
    }
}

struct WorkSuitabilitySection: View {
    var pal: PalModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Work suitability")
                .foregroundColor(.white)
                .font(.title2)
                .bold()
            VStack {
                ForEach(pal.workSuitability, id: \.skill) { workSuitability in
                    WorkSuitabilityLabel(
                        workSuitability: workSuitability
                    )
                    .padding(.bottom, Margin.mini)
                }
            }
        }
        .padding()
    }
}

struct WorkSuitabilityLabel: View {
    var workSuitability: WorkModel
    
    var body: some View {
        ZStack {
            Color.primaryM
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                .overlay(RoundedRectangle(cornerRadius: CornerRadius.small).stroke(.primaryD, lineWidth: 1))
            HStack {
                Image(workSkillType: workSuitability.skill)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Margin.big, height: Margin.big)
                Text(workSuitability.skill.getStringValue)
                    .foregroundColor(.white)
                    .font(.title3)
                Spacer()
                Text("Level \(workSuitability.level)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}


struct CircularPalButton: View {
    let imageURL: String?
    let tapAction: () -> Void
    let longpressAction: () -> Void
    
    var body: some View {
        Button(action: tapAction) {
            ZStack {
                Circle()
                    .foregroundColor(.white.opacity(0.2))
                if let imageUrl = imageURL {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "plus")
                        .foregroundStyle(Color(.systemBlue))
                    
                }
            }
        }.supportsLongPress(longPressAction: longpressAction)
    }
}

#if DEBUG
struct PalDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PalDetailsView(store: .init(
            initialState: PalDetails.State(
                pal: .mock,
                team: TeamModel(myTeam: [])
            ),
            reducer: {
                PalDetails()
            })
        )
    }
}
#endif
