# encoding: utf-8
require "httparty"

# Client for the Marvel App GraphQL API (marvelapp.com)
# Endpoint: https://marvelapp.com/graphql
# Auth:     Bearer token — generate at https://marvelapp.com/oauth/devtoken
class MarvelAppClient
  include HTTParty

  GRAPHQL_ENDPOINT = "https://marvelapp.com/graphql"

  # ─── Queries ────────────────────────────────────────────────────────────────

  QUERY_USER = <<~GQL.freeze
    query User {
      user {
        pk
        username
        email
        firstName
        lastName
      }
    }
  GQL

  QUERY_AUTH = <<~GQL.freeze
    query Auth {
      auth {
        token
        expires
        scopes
      }
    }
  GQL

  INTROSPECT_SCHEMA = <<~GQL.freeze
    query {
      __schema {
        queryType  { name }
        mutationType { name }
        types { name kind fields { name } }
      }
    }
  GQL

  # ─── Public interface ───────────────────────────────────────────────────────

  def initialize(token: nil)
    @token = token || ENV.fetch("MARVEL_APP_TOKEN", "")
  end

  def current_user
    query(QUERY_USER)
  end

  def auth_context
    query(QUERY_AUTH)
  end

  def schema
    query(INTROSPECT_SCHEMA)
  end

  def with_invalid_token
    self.class.new(token: "invalid_token_for_testing")
  end

  # ─── Response helpers ───────────────────────────────────────────────────────

  def self.errors_from(response)
    parse_body(response).fetch("errors", [])
  end

  def self.data_from(response, *keys)
    body = parse_body(response)
    keys.empty? ? body["data"] : body.dig("data", *keys)
  end

  def self.auth_error?(response)
    errors_from(response).any? { |e| e["message"].to_s =~ /token|auth|oauth|invalid/i }
  end

  def self.parse_body(response)
    JSON.parse(response.body)
  rescue JSON::ParserError
    {}
  end

  private

  def query(gql, variables: {})
    self.class.post(
      GRAPHQL_ENDPOINT,
      headers: {
        "Authorization" => "Bearer #{@token}",
        "Content-Type"  => "application/json",
        "Accept"        => "application/json"
      },
      body: { query: gql, variables: variables }.to_json
    )
  end
end
