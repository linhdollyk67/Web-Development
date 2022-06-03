*** Keywords ***
Open chrome web browser
    [Arguments]                     ${url}                        ${browser}=chrome
    Open Browser                    ${url}                         ${browser}
    Maximize Browser Window
    Set Browser Implicit Wait       10

Closer browser
    Close Window