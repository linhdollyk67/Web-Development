***Keywords***
Login by email, password successfully
    [Arguments]     ${email}    ${password}
    home_page.Hover on user icon 
    home_page.Click on Sign In button
    login_page.Input email  ${email}
    login_page.Input password  ${password}
    login_page.Click login