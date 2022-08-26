//
//  Job.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 26/08/2022.
//

import Foundation


struct Job {
    var company: String
    var location: String
    var status: String
}

// dummy data
let jobs: [Job] = [
    Job(company: "Apple", location: "Cupertino, USA", status: "Applied"),
    Job(company: "Juicy App", location: "Hong Kong", status: "Rejection email"),
    Job(company: "Duolingo", location: "Pittsburgh, USA", status: "Take home project"),
    Job(company: "Google", location: "Mountain View, USA", status: "Rejection email")
]
