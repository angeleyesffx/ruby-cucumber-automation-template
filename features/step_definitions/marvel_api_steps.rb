# encoding: utf-8

# ─── Setup ─────────────────────────────────────────────────────────────────────

Given("I have a valid Marvel App API token") do
  @marvel   = MarvelAppClient.new
  @response = nil
end

Given("I have an invalid Marvel App API token") do
  @marvel   = MarvelAppClient.new.with_invalid_token
  @response = nil
end

# ─── Queries ───────────────────────────────────────────────────────────────────

When("I query the current user") do
  @response = @marvel.current_user
end

When("I query the auth context") do
  @response = @marvel.auth_context
end

# ─── Generic assertions ────────────────────────────────────────────────────────

Then("the GraphQL response has no errors") do
  errors = MarvelAppClient.errors_from(@response)
  expect(errors).to be_empty,
    "Expected no GraphQL errors but got: #{errors.map { |e| e['message'] }.join(', ')}"
end

Then("the response data contains {string}") do |key|
  data = MarvelAppClient.data_from(@response)
  expect(data).not_to be_nil, "Response has no 'data' key. Body: #{@response.body.to_s[0, 300]}"
  expect(data).to have_key(key), "Expected 'data.#{key}' but got keys: #{data.keys.join(', ')}"
  expect(data[key]).not_to be_nil
end

Then("the GraphQL response contains an authentication error") do
  errors = MarvelAppClient.errors_from(@response)
  expect(errors).not_to be_empty, "Expected GraphQL errors but response had none"
  expect(errors.first["message"]).to match(/token|auth|oauth|invalid/i),
    "Expected auth error message but got: #{errors.first['message'].inspect}"
end

# ─── User-specific assertions ──────────────────────────────────────────────────

Then("the user data has an email address") do
  user = MarvelAppClient.data_from(@response, "user")
  expect(user).not_to be_nil
  expect(user["email"]).to match(/@/), "Expected a valid email but got: #{user['email'].inspect}"
end

# ─── Auth-specific assertions ──────────────────────────────────────────────────

Then("the auth data has a non-empty scopes string") do
  auth = MarvelAppClient.data_from(@response, "auth")
  expect(auth).not_to be_nil
  expect(auth["scopes"]).not_to be_nil
  expect(auth["scopes"].split(" ").length).to be > 1,
    "Expected multiple scopes but got: #{auth['scopes'].inspect}"
end

Then("the auth data has an expiry date") do
  auth = MarvelAppClient.data_from(@response, "auth")
  expect(auth["expires"]).not_to be_nil
  expect { Time.parse(auth["expires"]) }.not_to raise_error,
    "Expected a parseable date but got: #{auth['expires'].inspect}"
end
