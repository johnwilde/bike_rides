module AuthMacros
  def login(user = nil)
    user ||= Factory(:user)

    credentials=
      {"scope"=>["https://www.google.com/fusiontables/api/query"],
       "token"=>"test_token",
       "secret"=>"test_secret"}
    info= {"name" => user.name,
                "email" => user.email}

    OmniAuth.config.add_mock(:google_hybrid, 
                             {:uid => user.uid,
                              "credentials" => credentials,
                              "info" => info})
    visit "/auth/google_oauth2/callback"
    @_current_user = user
  end

  def current_user
    puts "getting current_user from AuthMacros"
    @_current_user
  end
end
