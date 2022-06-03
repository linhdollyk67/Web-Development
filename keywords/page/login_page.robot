***Variables***
&{login_page}
...     email_box=xpath=//form[@class='form form-login']//input[@name='login[username]']
...     pw_box=xpath=//form[@class='form form-login']//input[@name='login[password]']
...     SignIn_btn=xpath=//button[@class='action login primary']/span[text()='Sign In']

***Keywords***
Input email
    [Arguments]    ${email}
    common_keywords.Verify Web Elements Are Visible    ${login_page.email_box}
    common_keywords.Input Text And Verify Input For Web Element  ${login_page.email_box}  ${email}  

Input password
    [Arguments]    ${password}
    common_keywords.Verify Web Elements Are Visible    ${login_page.pw_box}
    common_keywords.Input Text And Verify Input For Web Element    ${login_page.pw_box}    ${password}

Click login
    common_keywords.Verify Web Elements Are Visible    ${login_page.SignIn_btn}
    common_keywords.Click Element    ${login_page.SignIn_btn}