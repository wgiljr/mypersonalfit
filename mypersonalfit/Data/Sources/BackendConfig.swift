//
//  BackendConfig.swift
//  mypersonalfit
//

import Foundation

/// Supabase project the app talks to (see docs/adr/0001-backend-stack.md).
///
/// The publishable (anon) key is meant to ship inside the app: Row Level Security
/// protects the data. Never put the secret / service_role key here.
enum BackendConfig {
    static let supabaseURL = URL(string: "https://niisxhicbcwezbobfveq.supabase.co")!
    static let supabasePublishableKey = "sb_publishable_yyOQTPYsNMqvCYOWinQIHQ_nY6aQ_5f"
}
