//
//  AppContainer.swift
//  TGLabNBA
//

import Foundation

@MainActor
struct AppContainer {
    let teamsViewModel: TeamsListViewModel
    let playersViewModel: PlayersSearchViewModel

    private let fetchGamesUseCase: FetchTeamGamesUseCase
    private let logger: AppLogging

    init() {
        let isUITesting = ProcessInfo.processInfo.arguments.contains("UI_TESTING")
        let useLocalData = ProcessInfo.processInfo.arguments.contains("USE_LOCAL_DATA")
        let logger = OSAppLogger(category: "TGLabNBA")
        self.logger = logger

        let baseClient: HTTPClient
        if isUITesting {
            baseClient = StubHTTPClient()
        } else if useLocalData {
            baseClient = LocalJSONDataSource()
        } else {
            //MARK: - please if APIKEY not working you can replace it because the limitation from Website or using the next commented line for local data.

            // baseClient = LocalJSONDataSource()
            baseClient = AuthenticatedHTTPClient(
                base: URLSession.shared,
                apiKey: "ad591509-ce27-4ea1-bfe8-ac3858a6327f"
            )
        }
        let client: HTTPClient = LoggingHTTPClient(base: baseClient, logger: logger)

        let teamsRepo: TeamsRepository = TeamsRepositoryImpl(client: client, logger: logger)
        let gamesRepo: GamesRepository = GamesRepositoryImpl(client: client, logger: logger)
        let playersRepo: PlayersRepository = PlayersRepositoryImpl(client: client, logger: logger)

        let fetchTeams = FetchTeamsUseCase(repository: teamsRepo, logger: logger)
        let fetchGames = FetchTeamGamesUseCase(repository: gamesRepo, logger: logger)
        let searchPlayers = SearchPlayersUseCase(repository: playersRepo, logger: logger)
        self.fetchGamesUseCase = fetchGames

        self.teamsViewModel = TeamsListViewModel(fetchTeamsUseCase: fetchTeams, logger: logger)
        self.playersViewModel = PlayersSearchViewModel(searchPlayersUseCase: searchPlayers, logger: logger)
    }

    func makeTeamGamesViewModel() -> TeamGamesViewModel {
        TeamGamesViewModel(fetchGamesUseCase: fetchGamesUseCase, logger: logger)
    }
}
