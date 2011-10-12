module AuthMacros
  def login(user = nil)
    user ||= Factory(:user)

    credentials=
      {"scope"=>["https://www.google.com/fusiontables/api/query"],
       "token"=>"test_token",
       "secret"=>"test_secret"}
    user_info= {"name" => user.name,
                "email" => user.email}

    OmniAuth.config.add_mock(:google_hybrid, 
                             {:uid => user.uid,
                              "credentials" => credentials,
                              "user_info" => user_info})
    visit "/auth/google_hybrid"
    @_current_user = user
  end

  def current_user
    @_current_user
  end
end
