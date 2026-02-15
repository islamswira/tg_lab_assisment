//
//  StubHTTPClient.swift
//  TGLabNBA
//

import Foundation

struct StubHTTPClient: HTTPClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let url = request.url else {
            throw NetworkError.invalidURL
        }

        let path = url.path()
        let json: String

        if path.contains("/teams") {
            json = """
            {
                "data": [
                    {"id":1,"conference":"East","division":"Southeast","city":"Atlanta","name":"Hawks","full_name":"Atlanta Hawks","abbreviation":"ATL"},
                    {"id":2,"conference":"West","division":"Pacific","city":"Los Angeles","name":"Clippers","full_name":"Los Angeles Clippers","abbreviation":"LAC"}
                ]
            }
            """
        } else if path.contains("/games") {
            json = """
            {
                "data": [
                    {"id":1001,"date":"2024-11-01","home_team_score":110,"visitor_team_score":105,"home_team":{"id":1,"conference":"East","division":"Southeast","city":"Atlanta","name":"Hawks","full_name":"Atlanta Hawks","abbreviation":"ATL"},"visitor_team":{"id":2,"conference":"West","division":"Pacific","city":"Los Angeles","name":"Clippers","full_name":"Los Angeles Clippers","abbreviation":"LAC"}}
                ],
                "meta": {"next_cursor": null, "per_page": 25}
            }
            """
        } else if path.contains("/players") {
            json = """
            {
                "data": [
                    {"id":101,"first_name":"Trae","last_name":"Young","position":"G","team":{"id":1,"conference":"East","division":"Southeast","city":"Atlanta","name":"Hawks","full_name":"Atlanta Hawks","abbreviation":"ATL"}}
                ],
                "meta": {"next_cursor": null, "per_page": 25}
            }
            """
        } else {
            throw NetworkError.resourceNotFound("stub")
        }

        let data = Data(json.utf8)
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!

        return (data, response)
    }
}
