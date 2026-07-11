import Foundation
import Supabase

let supabase: SupabaseClient = {
    guard
        let urlString = Bundle.main.object(forInfoDictionaryKey: "SupabaseURL") as? String,
        let url = URL(string: urlString),
        let key = Bundle.main.object(forInfoDictionaryKey: "SupabasePublishableKey") as? String,
        !key.isEmpty
    else {
        preconditionFailure("Supabase configuration is missing")
    }

    return SupabaseClient(supabaseURL: url, supabaseKey: key)
}()
