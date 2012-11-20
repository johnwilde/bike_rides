module AuthMacros
  def login(user = nil)
    user ||= Factory(:user)

    credentials={"token"=>"ya29.AHES6ZR2ZxXlXtduasdD9C0suKGQUxIlkWCt-6b6_lKMCQ", 
                 "refresh_token"=>"1/UZDu8DHlrB-1vf6vT945K8cfRxILZKiAou6HQqLZBvo", "expires_at"=>1348469521, "expires"=>true}
    extra={"raw_info"=>{"id"=>"104009305006165168598", 
                        "email"=>"johnwilde@gmail.com", 
                        "verified_email"=>true, "name"=>"John Wilde", 
                        "given_name"=>"John", "family_name"=>"Wilde", 
                        "link"=>"https://plus.google.com/104009305006165168598", 
                        "picture"=>"https://lh4.googleusercontent.com/-FC2gR_Eh7FI/AAAAAAAAAAI/AAAAAAAAGCw/nudXajQVy50/photo.jpg", 
                        "gender"=>"male", "birthday"=>"0000-08-24", "locale"=>"en-US"}}
    # credentials=
    #   {"scope"=>["https://www.google.com/fusiontables/api/query"],
    #    "token"=>"test_token",
    #    "secret"=>"test_secret"}
    info= {"name" => user.name,
           "email" => user.email}

    OmniAuth.config.add_mock(:google_oauth2,
                             {:uid => user.uid,
                              "credentials" => credentials,
                              "info" => info,
                              "extra" => extra})
    visit "/auth/google_oauth2/callback"
    @_current_user = user
  end

  def current_user
    puts "getting current_user from AuthMacros"
    @_current_user
  end
end
