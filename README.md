# twitter_omniauth_sandbox_app
Sandbox app to authenticate and get tokens for Twitter on localhost

## Setup
At first Create Twitter App.

Register following callback urls

* `http://localhost:4567/auth/twitter/callback` (for API v1.1)
* `http://localhost:4567/auth/twitter2/callback` (for API v2)

```bash
bundle install
cp .env.example .env
vi .env
```

Edit `TWITTER_V2_SCOPE` in  [app.rb](app.rb) if necessary

## Usage
```bash
bundle exec ruby app.rb
```

1. open http://localhost:4567/
2. Click login button 
    * If an error occurs, please browser back and reload 
3. Copy tokens in response
