//
//  Job.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 26/08/2022.
//

import Foundation


struct Job {
    var company: String
    var position: String
    var location: String
    var status: String
}

// dummy data
let jobs: [Job] = [
    Job(company: "Apple", position: "iOS developer", location: "Cupertino, USA", status: "Applied"),
    Job(company: "DeepL", position: "Junior iOS developer", location: "Berlin, Germany", status: "Rejection email"),
    Job(company: "Duolingo", position: "Junior iOS developer", location: "Pittsburgh, USA", status: "Take home project"),
    Job(company: "Google", position: "iOS engineer", location: "Mountain View, USA", status: "Rejection email"),
    Job(company: "Line", position: "iOS engineer", location: "Fukuoka, Japan", status: "Applied")
]
