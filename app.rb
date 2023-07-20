require "sinatra"
require "omniauth/builder"

require "omniauth-twitter"
require "omniauth/twitter2"

require "dotenv/load"

# https://developer.twitter.com/en/docs/authentication/oauth-2-0/authorization-code
TWITTER_V2_SCOPE = "tweet.read tweet.write users.read offline.access"

use Rack::Session::Cookie
use OmniAuth::Builder do
  if ENV["TWITTER_V1_CLIENT_ID"] && ENV["TWITTER_V1_CLIENT_SECRET"]
    provider :twitter, ENV["TWITTER_V1_CLIENT_ID"], ENV["TWITTER_V1_CLIENT_SECRET"]
  end

  if ENV["TWITTER_V2_CLIENT_ID"] && ENV["TWITTER_V2_CLIENT_SECRET"]
    provider :twitter2, ENV["TWITTER_V2_CLIENT_ID"], ENV["TWITTER_V2_CLIENT_SECRET"],
             callback_path: "/auth/twitter2/callback",
             scope: TWITTER_V2_SCOPE
  end
end

get "/" do
  # c.f. https://github.com/BobbyMcWho/omniauth_2_examples/blob/0e97264994313e4000c5f2ca5cc4df082355663c/sinatra_app.ru#L18-L21
  <<-HTML
    <form action="/auth/twitter" method="post">
      <input type="hidden" name="authenticity_token" value='#{request.env["rack.session"]["csrf"]}'>
      <button type="submit">Sign in with Twitter (v1)</button>
    </form>

    <form action="/auth/twitter2" method="post">
      <input type="hidden" name="authenticity_token" value='#{request.env["rack.session"]["csrf"]}'>
      <button type="submit">Sign in with Twitter (v2)</button>
    </form>
  HTML
end

get "/auth/:name/callback" do
  auth = request.env["omniauth.auth"]
  pp auth
  auth.to_json
end

get "/auth/failure" do
  <<-HTML
    <dl>
      <dt>message</dt>
      <dd>#{params[:message]}</dd>
      <dt>origin</dt>
      <dd>#{params[:origin]}</dd>
      <dt>strategy</dt>
      <dd>#{params[:strategy]}</dd>
    </dl>
  HTML
end
